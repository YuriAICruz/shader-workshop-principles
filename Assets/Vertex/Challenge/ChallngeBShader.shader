Shader "Unlit/ChallngeA"
{
    Properties
    {
        _BaseTex ("Base Texture", 2D) = "white" {}
        _Velocity ("Velocity", Vector) = (0,0,0,0)
        _DisplacementScale ("Displacement Scale", Float) = 1
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 centerDistance : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _BaseTex;
            float4 _BaseTex_ST;

            float4 _Velocity;
            float _DisplacementScale;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = v.vertex;

                o.centerDistance = o.vertex.xyz;
                o.vertex = UnityObjectToClipPos(o.vertex);
                
                float4 wPos = mul(UNITY_MATRIX_M, v.vertex) + length(o.centerDistance) * -_Velocity * _DisplacementScale;
                o.vertex =  mul(UNITY_MATRIX_VP, wPos);
                
                
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_BaseTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}