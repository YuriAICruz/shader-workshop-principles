// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "ShaderWorkshop/Vertex/Position"
{
    Properties
    {
        _Color("Base Color", Color) = (1,1,1,1)
        
        [Space]
        _UpColor("Upper Color", Color) = (1,1,1,1)
        _UpIntensity("Upper Intensity", float) = 1
        _UpPower("Upper Power", float) = 1
        
        [Space]
        _DownColor("Botton Color", Color) = (1,1,1,1)
        _DownIntensity("Botton Intensity", float) = 1
        _DownPower("Botton Power", float) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma target 3.0

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

            float4 _DownColor;
            float4 _Color;
            float4 _UpColor;
            float _UpIntensity;
            float _UpPower;
            float _DownIntensity;
            float _DownPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.pos = v.vertex;
                o.uv = v.uv;
                o.wpos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                float3 baseWorldPos = unity_ObjectToWorld._m03_m13_m23;
                return float4(i.wpos-baseWorldPos,1);//float4(i.pos.xyz,1);
            }
            ENDCG
        }
    }
    Fallback Off
}
