Shader "ShaderWorkshop/Vertex/Position"
{
    Properties
    {
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Opaque" "LightMode" = "ForwardBase"
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 pos : TEXCOORD1;
                float3 wpos : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.pos = v.vertex;
                o.uv = v.uv;
                o.wpos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }


            fixed4 frag(v2f i) : SV_Target
            {
                const float3 baseWorldPos = unity_ObjectToWorld._m03_m13_m23;
                return float4(i.wpos - baseWorldPos, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}