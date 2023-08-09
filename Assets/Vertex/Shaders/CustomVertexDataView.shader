Shader "ShaderWorkshop/Vertex/CustomVertexData"
{
    Properties
    {
        [KeywordEnum(A, B)] DATA ("DATA", float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #pragma multi_compile DATA_A DATA_B

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float3 dataA : TEXCOORD1;
                float3 dataB : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
                float3 dataA : TEXCOORD2;
                float3 dataB : TEXCOORD3;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uv = v.uv;
                o.dataA = v.dataA;
                o.dataB = v.dataB;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                #if DATA_A
                return float4(i.dataA.rgb, 1);
                #endif
                
                #if DATA_B
                return float4(i.dataB.rgb, 1);
                #endif

                return 0;
            }
            ENDCG
        }
    }
    Fallback Off
}
