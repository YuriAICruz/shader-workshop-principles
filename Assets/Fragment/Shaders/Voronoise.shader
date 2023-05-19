Shader "ShaderWorkshop/Fragment/Voronoise"
{
    Properties
    {
        _ColorX ("Color X", Color) = (1,1,1,1)
        _ColorY ("Color Y", Color) = (1,1,1,1)
        _Background ("Background", Color) = (1,1,1,1)
        _Definition ("Definition", Range(-1.0, 1.0)) = 1
        _Mosaic ("Mosaic", Range(-1.0, 1.0)) = 1
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
            float4 _Background;
            float _Definition;
            float _Mosaic;

            float3 hash3( float2 p )
            {
                float3 q = float3( dot(p,float2(127.1,311.7)), 
                            dot(p,float2(269.5,183.3)), 
                            dot(p,float2(419.2,371.9)) );
                return frac(sin(q)*43758.5453);
            }

            // function got on shadertoy shader from Inigo Quilez https://www.shadertoy.com/view/Xd23Dh
            float voronoise( in float2 p )
            {
                float k = 1.0+63.0*pow(1.0-_Definition,6.0);

                float2 i = floor(p);
                float2 f = frac(p);
                
                float2 a = float2(0.0,0.0);
                for( int y=-2; y<=2; y++ )
                for( int x=-2; x<=2; x++ )
                {
                    float2  g = float2( x, y );
                    float3  o = hash3( i + g )*float3(_Mosaic,_Mosaic,1.0);
                    float2  d = g - f + o.xy;
                    float w = pow( 1.0-smoothstep(0.0,1.414,length(d)), k );
                    a += float2(o.z*w,w);
                }
                
                return a.x/a.y;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed noise = voronoise(i.uv*100);
                float4 c = saturate(lerp(_ColorX, _ColorY, noise));
                
                return lerp(_Background, c, c.a);
            }
            ENDCG
        }
    }
}
