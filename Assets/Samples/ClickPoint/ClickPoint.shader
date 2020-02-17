Shader "Custom/ClickPoint" 
{
    Properties
    {
        _Point1("Point1", vector) = (0.5,0.5,0,0) // 屏幕左下角是(0,0,0,0)
        _ScreenWidth("ScreenWidth", Int) = 1920
        _ScreenHeight("ScreenHeight", Int) = 1080
        _Radius("Radius", Int) = 1
        //_MousePoint("MousePoint", Vector) = (0,0,0,1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Point1;
            int _ScreenWidth;
            int _ScreenHeight;
            int _Radius;
            float4 _MousePoint;
            //float4 _Points[64];

            struct appdata 
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f 
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v) 
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
                if (pow((i.vertex.x - _Point1.x * _ScreenWidth), 2) + pow((i.vertex.y - _Point1.y * _ScreenHeight), 2) < _Radius * _ScreenWidth)
                {
                    return fixed4(0,1,0,1);
                }
                if (pow((i.vertex.x - _MousePoint.x), 2) + pow((i.vertex.y - _MousePoint.y), 2) < _Radius * _ScreenWidth)
                {
                    return fixed4(1,0,0,1);
                }
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}