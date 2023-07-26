Shader "Unlit/ChallengeA"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HeightTex ("Height Map", 2D) = "white" {}
        _CloudTex ("Clouds Map", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _WaterTex ("Water Map", 2D) = "white" {}
        _CloudSpeed ("Cloud Speed", Vector) = (1,1,0,0)
        _CloudPower ("Cloud Power", Float) = 1
        _CloudColor ("Cloud Color", Color) = (1,1,1,1)
        _WaterColor ("Cloud Color", Color) = (0,0,1,1)
        _WaterGlowColor ("Cloud Color", Color) = (0,0,1,1)
        _WaterSpeed ("Water Speed", Vector) = (1,1,0,0)
        _Height ("Float", Float) = 1
        _Specular ("Float", Float) = 1
        _Atmosphere ("Atmosphere", Float) = 1
        _AtmosphereColor ("Atmosphere Color", Color) = (1,1,1,1)
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
                float2 uvClouds : TEXCOORD1;
                float2 uvNoise : TEXCOORD2;
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
                float3 viewDir : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _HeightTex;
            float4 _HeightTex_ST;

            sampler2D _CloudTex;
            float4 _CloudTex_ST;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;

            sampler2D _WaterTex;
            float4 _WaterTex_ST;

            float2 _CloudSpeed;
            float _CloudPower;
            
            float _Atmosphere;
            float4 _AtmosphereColor;

            float4 _CloudColor;
            float4 _WaterColor;
            float4 _WaterGlowColor;
            float4 _WaterSpeed;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvClouds = TRANSFORM_TEX(v.uv, _CloudTex);
                o.uvNoise = TRANSFORM_TEX(v.uv, _NoiseTex);
                o.normal = v.normal;
                o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                fixed4 clouds = tex2D(_CloudTex, float2(i.uvClouds.x + _Time.x * _CloudSpeed.x,
                                                        i.uvClouds.y + _Time.x * _CloudSpeed.y)) * _CloudColor;
                fixed4 noise = tex2D(_NoiseTex, i.uvNoise + float2(_Time.x * _WaterSpeed.x, _Time.x * _WaterSpeed.y));
                fixed4 waterMap = (1 - tex2D(_WaterTex, i.uv));
                fixed4 heightMap = tex2D(_HeightTex, i.uv);

                float4 fresnel = (pow(1-dot(normalize(i.viewDir), i.normal), _Atmosphere)) * _AtmosphereColor;

                waterMap = lerp(_WaterColor, _WaterGlowColor,
                                pow(noise, (sin(_Time.y * 3.14) + 1) / 2 * _WaterSpeed.z + _WaterSpeed.w)) * waterMap;

                clouds = pow(clouds, _CloudPower);
                col = col + clouds;

                col *= 1 - waterMap;
                return saturate(fresnel + col + waterMap);
            }
            ENDCG
        }
    }
}