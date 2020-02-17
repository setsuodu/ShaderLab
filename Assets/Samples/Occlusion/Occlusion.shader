Shader "Highlight/Occlusion"
{
    Properties
    {
        _Color("Occlusion Color", Color) = (0,1,1,1)
        _Width("Occlusion Width", Range(0, 10)) = 1
        _Intensity("Occlusion Intensity",Range(0, 10)) = 1

        _MainTex("MainTex", 2D) = "white"{}
    }

    SubShader
    {
        Tags{"Queue" = "Transparent"}

        Pass
        {
            ZTest Greater   //渲染遮挡的高亮部分
            ZWrite Off      //
            Blend SrcAlpha OneMinusSrcAlpha //混合

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 worldPos : SV_POSITION;
                float3 viewDir : TEXCOORD0;
                float3 worldNor : TEXCOORD1;
            };

            fixed4 _Color;
            fixed _Width;
            half _Intensity;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.worldPos = UnityObjectToClipPos(v.vertex);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.worldNor = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                half NDotV = saturate(dot(i.worldNor, i.viewDir));
                NDotV = pow(1 - NDotV, _Width) * _Intensity;

                fixed4 color;
                color.rgb = _Color.rgb;
                color.a = NDotV;
                return color;
            }
            ENDCG
        }

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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
