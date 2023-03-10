Shader "ShaderWorkshop//Surface/CustomLight"
{
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _Step ("Light Step", float) = 1
        _Power ("Light Power", float) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        CGPROGRAM
        #pragma surface surf Cel

        float _Step;
        float _Power;
        float4 _Color;

        float4 LightingCel(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
			float3 normal = normalize(s.Normal);

			float diffuse = saturate(dot(normal, lightDir)) * atten + UNITY_LIGHTMODEL_AMBIENT;
            
            diffuse = saturate(floor(pow(diffuse,_Power)*_Step)/_Step);
            
			return diffuse;
        }

        struct Input
        {
            float4 color : COLOR;
        };

        void surf(Input i, inout SurfaceOutput o)
        {
            o.Albedo = _Color;
        }
        ENDCG
    }
}