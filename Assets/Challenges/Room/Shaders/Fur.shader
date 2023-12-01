Shader "Challenge01/Fur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Size ("Size", Float) = 1
        _Height ("Height", Float) = 1
        _MaxHeight ("Max Height", Float) = 1
        _Cap ("Cap", Float) = 0.2
        [Space]
        _ShadowColor ("Shadow Color", Color) = (0,0,0,1)
        _ShadowIntensity ("Shadow Intensity", Float) = 1
    }

    CGINCLUDE
    #include "Assets/Lib/Math.cginc"
    #include "Assets/Lib/Lightning.cginc"
    #include "UnityCG.cginc"
    #include "AutoLight.cginc"

    struct appdata
    {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
    };

    struct v2f
    {
        float4 pos : SV_POSITION;
        LIGHTING_COORDS(0, 1)
        float2 uv : TEXCOORD2;
    };

    sampler2D _MainTex;
    float4 _MainTex_ST;
    float _Size;
    float _Height;
    float _MaxHeight;
    float _Cap;
    float _ShadowIntensity;
    float4 _Color;
    float4 _ShadowColor;

    v2f Position(float height, appdata v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        TRANSFER_VERTEX_TO_FRAGMENT(o);
        o.pos.y -= height;
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        return o;
    }

    float4 Draw(float height, v2f i)
    {
        float heightNorm = height / _MaxHeight;
        fixed4 col = tex2D(_MainTex, i.uv) * (_Color + heightNorm);
        float noise = Noise(i.uv.xy * _Size);
        noise = noise * (1 - heightNorm);
        noise = round(noise);
        col = col * noise;
        float attenuation = (1 - LIGHT_ATTENUATION(i)) * _ShadowIntensity;
        return col.a*lerp(col, _ShadowColor, attenuation);
    }

    v2f vert_shadow(appdata_full v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
        TRANSFER_VERTEX_TO_FRAGMENT(o);
        return o;
    }

    half4 frag_shadow(v2f IN) : SV_Target
    {
        half atten = LIGHT_ATTENUATION(IN);
        return atten;
    }
    ENDCG

    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue" = "AlphaTest"
        }
        LOD 100

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            v2f vert(appdata v)
            {
                return Position(0, v);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                float attenuation = (1 - LIGHT_ATTENUATION(i)) * _ShadowIntensity;
                return lerp(col, _ShadowColor, attenuation);
            }
            ENDCG
        }

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            v2f vert(appdata v)
            {
                return Position(1 * _Height, v);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 noise = Draw(1 * _Height, i);

                if (noise.a <= _Cap)
                {
                    discard;
                }

                return noise;
            }
            ENDCG
        }

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            v2f vert(appdata v)
            {
                return Position(2 * _Height, v);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 noise = Draw(2 * _Height, i);

                if (noise.a <= _Cap)
                {
                    discard;
                }

                return noise;
            }
            ENDCG
        }

        // Forward add pass
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardAdd"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert_shadow
            #pragma fragment frag_shadow
            #pragma multi_compile_fwdadd_fullshadows
            ENDCG
        }

        // Pass to render object as a shadow caster
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing // allow instanced shadow pass for most of the shaders

            struct v2f_caster
            {
                V2F_SHADOW_CASTER;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f_caster vert(appdata_base v)
            {
                v2f_caster o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 frag(v2f_caster i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}