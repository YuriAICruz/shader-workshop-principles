Shader "Unlit/ChallngeA"
{
    Properties
    {
        _BaseTex ("Base Texture", 2D) = "white" {}

        [Space]
        _UpperTex("Upper Texture", 2D) = "white" {}
        _UpperPower("Upper Power", float) = 1
        _UpperMult("Upper Multiplier", float) = 1

        [Space]
        _UpperNoiseSize("Upper Noise Size", float) = 1
        _UpperNoiseStrength("Upper Noise Strength", float) = 1
        _UpperNoisePower("Upper Noise Power", float) = 1

        [Space]
        _LowerTex("Lower Texture", 2D) = "white" {}
        _LowerPower("Lower Power", float) = 1
        _LowerMult("Lower Multiplier", float) = 1

        [Space]
        _LowerNoiseSize("Lower Noise Size", float) = 1
        _LowerNoiseStrength("Lower Noise Strength", float) = 1
        _LowerNoisePower("Lower Noise Power", float) = 1
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
            #include "Assets/Lib/Math.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
                float3 wPos : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            sampler2D _BaseTex;
            float4 _BaseTex_ST;

            sampler2D _UpperTex;
            float4 _UpperTex_ST;

            sampler2D _LowerTex;
            float4 _LowerTex_ST;

            float _UpperPower;
            float _UpperMult;
            float _UpperNoiseSize;
            float _UpperNoiseStrength;
            float _UpperNoisePower;

            float _LowerPower;
            float _LowerMult;
            float _LowerNoiseSize;
            float _LowerNoiseStrength;
            float _LowerNoisePower;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                o.uv2 = TRANSFORM_TEX(v.uv, _UpperTex);
                o.uv3 = TRANSFORM_TEX(v.uv, _LowerTex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_BaseTex, i.uv);
                fixed4 upper = tex2D(_UpperTex, i.uv2);
                fixed4 lower = tex2D(_LowerTex, i.uv3);


                float upperNoise = Noise(i.uv2 * _UpperNoiseSize);
                float lowerNoise = Noise(i.uv2 * _LowerNoiseSize);

                float3 worldDirection = i.wPos - unity_ObjectToWorld._m03_m13_m23;

                fixed4 upperOverlay = lerp(col, upper, clamp(
                                               (pow(upperNoise, _UpperNoisePower) * _UpperNoiseStrength) * pow(
                                                   max(0, worldDirection.y * _UpperMult), _UpperPower), 0, 1));

                return lerp(upperOverlay, lower, clamp(
                                pow(lowerNoise, _LowerNoisePower) * _LowerNoiseStrength *
                                pow(max(0, (-worldDirection.y) * _LowerMult), _LowerPower),
                                0, 1
                            ));
            }
            ENDCG
        }
    }
}