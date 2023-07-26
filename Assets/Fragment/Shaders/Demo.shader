// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Workshop/Demo"
{
    Properties
    {
        _Color ("My Color", Color) = (1,0,0,1)
    }
    
    SubShader {
        Tags {"RenderType" = "Opaque"}
        LOD 100
        
        Pass{
            CGPROGRAM

            #pragma vertex vertexShader
            #pragma fragment fragShader

            struct vertexData
            {
                half4 vertex : POSITION;
                half2 uv : TEXCOORD0;
            };

            struct meshData
            {
                half4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
            };

            half4 _Color;

            vertexData vertexShader (meshData data)
            {
                vertexData vData;
                vData.uv = data.uv;
                vData.vertex = UnityObjectToClipPos(data.vertex);
                return vData;
            }

            fixed4 fragShader(vertexData data) : SV_Target
            {
                return _Color;
            }
            
            ENDCG
        }        
    }
}