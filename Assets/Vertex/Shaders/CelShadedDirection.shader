Shader "ShaderWorkshop/Vertex/CelShaded"
{
    Properties
    {
        _RampTexture ("Ramp", 2D) = "white"{}
        _Distance("Distance", float) = 1

        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)

        _ColorOutline("Outline Color", Color) = (0,0,0,1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass 
        {
            Name "Outline"
            
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };
            
            float4 _ColorOutline;
            float _Distance;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = v.vertex;
                o.vertex.xyz += v.normal.xyz * _Distance*0.001;
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.normal = -v.normal;
                o.uv = v.uv;
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                return _ColorOutline;
            }
            ENDCG
        }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Assets/Lib/Lightning.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _RampTexture;
            float4 _RampTexture_ST;
            float4 _ColorA;
            float4 _ColorB;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
				o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                float3 light = clamp(Lambert(i.normal),0.01,0.99);
                float intensity = (light.r+light.g+light.b)/3;
                float ramp = tex2D(_RampTexture, float2(intensity, 0)).r;
                float4 col = lerp(_ColorB, _ColorA, ramp);
                return col;
            }
            ENDCG
        }
    }
    Fallback Off
}
