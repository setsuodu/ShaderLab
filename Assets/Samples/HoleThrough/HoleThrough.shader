// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/HoleThrough" {
    Properties {
        _HolePos("HolePos",vector) = (1,1,1,1)
        _HoleSize("HoleSize",Range(0,10)) = 1
        _BlurThick("BlurThick",Range(0,10)) = 1
        _MainColor("MainColor",Color) = (1,1,1,1)
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
            uniform float4 _MainColor;

            struct v2f {
                float4 wPos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(float4 pos : POSITION ,float2 uv : TEXCOORD0) {
                v2f output;
                output.wPos = UnityObjectToClipPos(pos);
                output.uv = uv;
                return output;
            }

            float4 frag(v2f input) : SV_TARGET {
                half4 col = _MainColor;
                float2 pos = input.uv;

                float dist = distance(pos, float2(_HolePos.x, _HolePos.y));
                if(dist < _HoleSize) {
                    clip(-1.0);
                } else if(dist < _HoleSize + _BlurThick){
                    col.a = (dist - _HoleSize) * 10.0;
                    col.a = pow(col.a, 2.0);
                }

                return col;
            }

            ENDCG
        }
    }
}