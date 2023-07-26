Shader "ShaderWorkshop/Fragment/GrabPass"
{
    Properties
    {
        _Refraction ("Refraction", Float) = 1
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        _FresnelBias ("Fresnel Bias", Float) = 0
        _FresnelScale ("Fresnel Scale", Float) = 1
        _FresnelPower ("Fresnel Power", Float) = 1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        LOD 100

        GrabPass
        {
            "_MainTex"
        }
        
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
				half3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
				float3 normal   : NORMAL;
                float2 uv       : TEXCOORD0;
                float3 viewDir  : TEXCOORD1;
                float4 grabPos  : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _FresnelColor;
            float _FresnelBias;
            float _FresnelScale;
            float _FresnelPower;
            float _Refraction;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = v.normal;
				o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
                
                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float fresnel = saturate(_FresnelBias + pow(dot(i.viewDir, i.normal),_FresnelPower) * _FresnelScale);
                
                float3 cr = pow(cross(i.viewDir, i.normal), 2);
                float4 zoom = saturate(float4(cr.x,cr.y,cr.z,0) * fresnel);
                
                fixed4 col = tex2Dproj(_MainTex, i.grabPos - zoom*_Refraction);
                
                return lerp(_FresnelColor,col,fresnel);
            }
            ENDCG
        }
    }
}
