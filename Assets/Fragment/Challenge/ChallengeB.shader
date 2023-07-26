// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/ChallengeB"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _LightColor ("Light Color", Color) = (1,1,1,1)
        _Clamp ("Clamp", Float) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include <UnityLightingCommon.cginc>

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            float4 _Color;
            float4 _LightColor;
            float _Clamp;

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldNormal = mul ((float3x3)unity_ObjectToWorld, i.normal );
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float4 lightColor = _LightColor0;

                float4 col = lerp(_Color, lightColor * _LightColor, saturate(round(dot(worldNormal, lightDir)*_Clamp)/_Clamp));
                col.a = 1;

                return col;
            }
            ENDCG
        }
    }
}