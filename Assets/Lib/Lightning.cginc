#include <UnityShaderVariables.cginc>
            
#if defined (SHADOWS_DEPTH) && !defined (SPOT)
#define SHADOW_COORDS(idx1) unityShadowCoord2 _ShadowCoord : TEXCOORD##idx1;
#define TRANSFER_SHADOW(a)
#define SHADOW_ATTENUATION(a) 1.0
#endif

uniform float4 _LightColor0;

float3 Lambert(float3 normal)
{
    float atten = 1.0;
    float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

    float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normal, lightDirection));

    return UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection;
}
