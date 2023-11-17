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
    }

    CGINCLUDE
    #include "Assets/Lib/Math.cginc"

    #include "UnityCG.cginc"

    struct appdata
    {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
    };

    struct v2f
    {
        float2 uv : TEXCOORD0;
        float4 vertex : SV_POSITION;
    };

    sampler2D _MainTex;
    float4 _MainTex_ST;
    float _Size;
    float _Height;
    float _MaxHeight;
    float _Cap;
    float4 _Color;

    v2f Position(float height, appdata v)
    {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.vertex.y -= height;
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        return o;
    }

    float4 Draw(float height, v2f i)
    {
        float heightNorm = height / _MaxHeight;
        fixed4 col = tex2D(_MainTex, i.uv)*(_Color+heightNorm);
        float noise = Noise(i.uv.xy * _Size);
        noise = noise * (1 - heightNorm);
        noise = round(noise);
        col = col * noise;
        return col;
    }
    ENDCG
    
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma vertex vert
            #pragma fragment frag

            v2f vert(appdata v)
            {
                return Position(0, v);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv)*_Color;

                return col;
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
    }
}