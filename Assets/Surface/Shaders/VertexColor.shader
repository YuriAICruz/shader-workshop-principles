Shader "ShaderWorkshop//Surface/VertexColor"
{
    Properties {}
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float4 color : COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = IN.color;
        }
        ENDCG
    }
}