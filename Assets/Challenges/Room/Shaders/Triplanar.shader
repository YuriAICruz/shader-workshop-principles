Shader "Unlit/Triplanar"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Scale ("Scale", Float) = 8
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
                float3 worldPos : TEXCOORD1;
                float3 normal : NORMAL;
                float3 worldNormal : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Scale;
            
            float4 boxmap(in float3 p, in float3 n, in float k )
            {
                // project+fetch
	            float4 x = tex2D(_MainTex, p.yz );
	            float4 y = tex2D(_MainTex, p.zx );
	            float4 z = tex2D(_MainTex, p.xy );
                
                // and blend
                float3 m = pow( abs(n), float3(k, k, k) );
	            return (x*m.x + y*m.y + z*m.z) / (m.x + m.y + m.z);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul((float3x3)unity_ObjectToWorld, v.vertex);
                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = boxmap(i.worldPos*_Scale, i.worldNormal, 8);
                return col;
            }
            ENDCG
        }
    }
}
