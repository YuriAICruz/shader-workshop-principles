Shader "Unlit/Reflections"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Reflection ("Reflection", Cube) = "" {}

        [Range(0,1)]
        _Smoothness ("Reflection", Float) = 1
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
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Smoothness;
            samplerCUBE _Reflection;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                o.worldPos = (mul((float3x3)unity_ObjectToWorld, v.vertex));
                o.viewDir = (mul((float3x3)unity_ObjectToWorld, _WorldSpaceCameraPos));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 reflection = reflect(-_WorldSpaceCameraPos + i.worldPos, i.worldNormal);
                float3 colReflected = texCUBE(_Reflection, reflection);
                return float4(lerp(col, colReflected, _Smoothness), col.a);
            }
            ENDCG
        }
    }
}