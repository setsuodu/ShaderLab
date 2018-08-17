// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/HoleThroughSquare" {
    Properties {
        _HolePos("HolePos",vector) = (0.5,0.5,0,0)
        _HoleSize("HoleSize",Range(0,10)) = 0.1
        _BlurThick("BlurThick",Range(0,10)) = 0.1
        _MainCol("MainCol",COLOR) = (1,1,1,0)
        _MainTex("MainTex",2D) = "white"{}
		_Center("Center",vector)=(0.5,0.5,0,0)
    }

    SubShader {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
        ZWrite On
        ZTest LEqual
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            uniform float _HoleSize;
            uniform float4 _HolePos;
            uniform float _BlurThick;
            uniform fixed4 _MainCol;
            sampler2D _MainTex;
			float4 _Center;

			struct a2v {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

            struct v2f {
                float4 wPos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v) {
                v2f output;
                output.wPos = UnityObjectToClipPos(v.pos);
                output.uv = v.uv;
                return output;
            }

            float4 frag(v2f input) : COLOR {
                fixed4 col;
                float2 pos = input.uv;
				
				if(abs(pos.x) > _Center.x  && abs(pos.x) < _Center.y && abs(pos.y) > _Center.z && abs(pos.y) < _Center.w) {
					col = _MainCol;
				} else {
					col = tex2D(_MainTex, input.uv);
				}
				
                return col;
            }

            ENDCG
        }
    }
}