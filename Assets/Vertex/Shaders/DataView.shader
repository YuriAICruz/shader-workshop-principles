Shader "ShaderWorkshop/Vertex/CustomVertexData"
{
    Properties
    {
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma target 4.0

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
                float2 data1 : TEXCOORD1;
                float2 data2 : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                fixed2 data1 : TEXCOORD2;
                fixed2 data2 : TEXCOORD3;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uv = v.uv;
                o.data1 = v.data1;
                o.data2 = v.data2;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(i.data1.rg, i.data2.rg);
            }
            ENDCG
        }
    }
    Fallback Off
}
