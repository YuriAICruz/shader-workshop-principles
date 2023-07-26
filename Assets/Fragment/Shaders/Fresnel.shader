Shader "ShaderWorkshop/Fragment/Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        _FresnelBias ("Fresnel Bias", Float) = 0
        _FresnelScale ("Fresnel Scale", Float) = 1
        _FresnelPower ("Fresnel Power", Float) = 1
    }
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

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				half3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
				float3 normal : NORMAL;
            };

            float4 _Color;
            float4 _FresnelColor;
            float _FresnelBias;
            float _FresnelScale;
            float _FresnelPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
				o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float fresnel = saturate(_FresnelBias + pow(dot(i.viewDir, i.normal),_FresnelPower) * _FresnelScale);

                return lerp(_FresnelColor,_Color, fresnel);
                
                float4 fColor = (1-fresnel) * _FresnelColor;
                float4 color = fresnel * _Color;

                
                return color + fColor;
            }
            ENDCG
        }
    }
}