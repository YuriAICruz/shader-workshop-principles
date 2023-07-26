// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/ChallengeC"
{
    Properties
    {
        _Kernel ("DitherKernel", Color) = (1,1,1,1)
        _Color ("Main Color", Color) = (1,1,1,1)
        _ShadowColorColor ("Shadow Color", Color) = (0,0,0,1)
        _Specular ("Specular", Float) = 1
        _Size ("Size", Int) = 1
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
                float4 worldPos : TEXCOORD1;
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
                float4 pos : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = v.vertex;
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            static const float DITHER_THRESHOLDS_2x2[4] =
            {
                1.0 / 5.0,  3.0 / 5.0,
                3.0 / 5.0,  4.0 / 5.0,
            };

            static const float DITHER_THRESHOLDS_4x4[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };

            float4 _Color;
            float4 _ShadowColorColor;
            static const int matrixSize = 4;
            int _Size;
            float _Specular;

            fixed4 frag(v2f i) : SV_Target
            {
                float2 pos = i.vertex.xy;
                //float2 pos = i.uv;
                pos *= _ScreenParams.xy;
                float aspect = _ScreenParams.x/_ScreenParams.y;
                pos /= float2(_Size*aspect, _Size);//_ScreenParams.xy;
                
                float3 worldNormal = mul ((float3x3)unity_ObjectToWorld, i.normal );
                float3 lightDir = _WorldSpaceLightPos0.xyz;

                float light = saturate(dot(worldNormal*_Specular, lightDir));

                int index = (round(pos.x+4) % matrixSize) * matrixSize + round(pos.y) % matrixSize;
           
                return lerp(_ShadowColorColor, _Color,ceil(light - DITHER_THRESHOLDS_4x4[index]));
            }
            ENDCG
        }
    }
}