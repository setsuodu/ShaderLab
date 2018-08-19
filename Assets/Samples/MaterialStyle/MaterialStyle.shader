Shader "Custom/MaterialStyle"   
{
    Properties
    {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Color("Color", Color) = (1, 0, 0, 1)
        _Point1("Point1", vector) = (100, 100, 0, 0)
		_Radius("Radius", range(0, 50000)) = 0
    }

    SubShader
    {
        Pass
		{    
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {    
                float4 vertex : POSITION;
            };

            struct v2f
            {    
                float4 vertex : SV_POSITION;
            };
			
            float4 _Color;
            float4 _Point1;
			float _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                if(pow((i.vertex.x - _Point1.x), 2) + pow((i.vertex.y - _Point1.y), 2) < _Radius) //set area to draw wave
                {
					return _Color; //set wave color
                }
                return fixed4(1, 1, 1, 1); //set background color
            }

            ENDCG
        }
    }
}
