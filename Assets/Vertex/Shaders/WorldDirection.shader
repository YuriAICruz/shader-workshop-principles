// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "ShaderWorkshop/Vertex/WorldDirection"
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
        
        [KeywordEnum(OFF, ON)] LIGHT ("Light", float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma target 2.0

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile LIGHT_ON LIGHT_OFF

            #include "UnityCG.cginc"
            #include "Assets/Lib/Lightning.cginc"

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
                float3 wNormal : TEXTCOORD1;
                float3 normal : TEXCOORD2;
                float3 wpos : TEXCOORD3;
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
                o.normal = normalize( mul( float4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                o.wpos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                // World Normal Debug
                // return float4(i.wNormal,1);

                

                float4 color = lerp(_Color, _UpColor, saturate(pow(saturate(i.wNormal.y)*_UpIntensity, _UpPower)));
                color = lerp(color, _DownColor, saturate(pow(saturate((1-i.wNormal.y) * _DownIntensity), _DownPower)));

                #if LIGHT_ON
                
                float3 lightColor = Lambert(i.normal);
                return float4(lightColor * color.rgb,1);
                
                #endif
                
                color.a = 1;
                return color;
            }
            ENDCG
        }
    }
    Fallback Off
}
