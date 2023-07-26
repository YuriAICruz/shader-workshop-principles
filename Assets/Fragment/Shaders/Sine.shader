Shader "ShaderWorkshop/Fragment/Sine"
{
    Properties
    {
        _ColorX ("Color X", Color) = (1,1,1,1)
        _ColorY ("Color Y", Color) = (1,1,1,1)
        _Size ("Size", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _ColorX;
            float4 _ColorY;
            float _Size;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = sin(_ColorX * i.uv.x*_Size) + (1-cos(_ColorY * i.uv.y*_Size));
                return saturate(col);
            }
            ENDCG
        }
    }
}
