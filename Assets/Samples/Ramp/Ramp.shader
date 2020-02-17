Shader "Custom/Ramp"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

        _Speed("Speed", Range(0,1)) = 0.5

        _Center("Center", range(0,1)) = 0       //中心点y坐标值
        _Range("Range", range(0,1)) = 0.2               //产生渐变的范围值

        [Enum(Horizontal,0,Vertical,1)] _Direction("方向", int) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed _Speed;

            float _Center;
            float _Range;

            float _Direction;

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

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv += frac(fixed2(0, _Speed * _Time.y));
                //o.uv += frac(fixed2(unity_DeltaTime.x, unity_DeltaTime.y)) * 10;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);
                float s = 0;
                if (_Direction == 0) 
                {
                    s = i.uv.x - (_Center - _Range / 2);
                }
                else if (_Direction == 1) 
                {
                    s = i.uv.y - (_Center - _Range / 2);
                }
                float f = saturate(s / _Range);
                fixed4 col = lerp(tex, _Color, f);
                return col;
            }
            ENDCG
        }
    }
}