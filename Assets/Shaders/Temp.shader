// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Temp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (0.38,0.26,0.98,1.0)
        _Size("Size", float) = 0.1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma target 4.0

            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 wpos : TEXCOORD1;
                float4 vpos : TEXCOORD2;
                fixed4 color : COLOR;
            };
            
            struct g2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Size;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = v.vertex;
                //o.vertex.xyz += float3(o.vertex.x, cos(o.vertex.z + _Time.z), o.vertex.z)*0.2;
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.wpos = mul (unity_ObjectToWorld, v.vertex).xyz;
                o.vpos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = 1;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            
            [maxvertexcount(4)]
            void geom(point v2f IN[1], inout TriangleStream<g2f> outStream)
            {
                float dx = _Size;
                float dy = _Size * _ScreenParams.x / _ScreenParams.y;
                g2f OUT;
                OUT.pos = IN[0].vpos + float4(-dx, dy,0,0); OUT.uv=float2(0,0); OUT.color = IN[0].color; outStream.Append(OUT);
                OUT.pos = IN[0].vpos + float4( dx, dy,0,0); OUT.uv=float2(1,0); OUT.color = IN[0].color; outStream.Append(OUT);
                OUT.pos = IN[0].vpos + float4(-dx,-dy,0,0); OUT.uv=float2(0,1); OUT.color = IN[0].color; outStream.Append(OUT);
                OUT.pos = IN[0].vpos + float4( dx,-dy,0,0); OUT.uv=float2(1,1); OUT.color = IN[0].color; outStream.Append(OUT);
                outStream.RestartStrip();
            }
            ENDCG
        }
    }
    Fallback Off
}
