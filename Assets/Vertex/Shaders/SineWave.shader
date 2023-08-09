Shader "ShaderWorkshop/Vertex/SineWave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size("Size", float) = 0.1
        _Speed("Speed", float) = 0.1
        _Length("Length", float) = 0.1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		Cull Off

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
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 wpos : TEXCOORD1;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Size;
            float _Speed;
            float _Length;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = v.vertex;

                o.wpos = mul (unity_ObjectToWorld, v.vertex).xyz;

                o.vertex.xyz += float3(
                    0,
                    sin(o.wpos.x * 3.14 * _Length + (_Time.z*_Speed))+cos(o.wpos.z * 3.14 * _Length + (_Time.z*_Speed)),
                    0)
                *_Size;

                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = 1;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
    Fallback Off
}
