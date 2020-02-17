Shader "Alpha/TransparentAlpha"
{
    Properties
    {
        _Alpha("Alpha", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags 
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent" 
        }
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            ZWrite On                           // 关闭深度写入
            Blend SrcAlpha OneMinusSrcAlpha     // 开启混合模式。SrcAlpha：源颜色混合因子，OneMinusSrcAlpha：已存在颜色混合因子

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            fixed _Alpha;

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
            //v2f vert(a2v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return fixed4(i.uv, 0, _Alpha);
            }

            ENDCG
        }
    }
}