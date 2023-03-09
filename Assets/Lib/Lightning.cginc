#include <UnityShaderVariables.cginc>
            
uniform float4 _LightColor0;

float3 Lambert(float3 normal)
{
    float atten = 1.0;
    float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

    float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normal, lightDirection));

    return UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection;
}
