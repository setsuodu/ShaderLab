Shader "Highlight/Occlusion"
{
    Properties
    {
        _Color("Occlusion Color", Color) = (0,1,1,1)
        _Width("Occlusion Width", Range(0, 10)) = 1
        _Intensity("Occlusion Intensity",Range(0, 10)) = 1

        _Albedo("Albedo", 2D) = "white"{}
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

        CGPROGRAM
        #pragma surface surf StandardSpecular

        struct Input
        {
            float2 uv_Albedo;
        };

        sampler2D _Albedo;

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo = tex2D(_Albedo, IN.uv_Albedo).rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
