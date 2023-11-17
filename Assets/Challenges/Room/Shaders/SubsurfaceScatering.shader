Shader "Unlit/SubsurfaceScatering"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Intensity ("Intensity", Float) = 1
        _Pow ("Pow", Float) = 1
        [Range(0,1)]
        _Min ("Min", Float) = 0.1
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
                float3 normal : NORMAL;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float4 grabPos : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                float4 color : TEXCOORD4;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Intensity;
            float _Pow;
            float _Min;

            v2f vert(appdata v)
            {
                v2f o;
                o.color = v.color;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(unity_ObjectToWorld, v.normal));
                o.viewDir = normalize(mul((float3x3)unity_ObjectToWorld, _WorldSpaceCameraPos));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.grabPos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float view = saturate(pow(dot(i.viewDir, _WorldSpaceLightPos0), _Pow) * 0.5);
                float light = saturate(dot(i.worldNormal, -_WorldSpaceLightPos0.xyz)) * _Intensity;
                return col + (lerp(0, view, i.color.r) + i.color.r * _Min) * _Intensity;
            }
            ENDCG
        }
    }
}