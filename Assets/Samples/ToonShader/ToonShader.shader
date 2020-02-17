Shader "Outline/ToonShader"
{
    Properties
    {
        _MainTex("Main", 2D) = "white"{}
        _Outline("Outline Color", Color) = (0.1,0.1,0.1,0.1)
        _Width("Width", Range(0, 0.1)) = 0.05
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass //第一个Pass绘制背景填充
        {
            Cull Front //剔除前景色，让前景内容可以显示

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Outline;
            fixed _Width;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION; //把渲染模型到屏幕上的指定位置，剪裁空间中的顶点坐标
            };

            v2f vert(appdata v)
            {
                v2f o;
                v.vertex += float4(v.normal * _Width, 0); //沿法线向外扩张
                o.vertex = UnityObjectToClipPos(v.vertex); //即 UNITY_MATRIX_MVP，物体坐标转世界坐标
                return o;
            }

            fixed4 frag(v2f i) : SV_Target //输出到屏幕上的颜色
            {
                fixed4 col = _Outline;
                return col;
            }
            ENDCG
        }
        Pass //第二个Pass绘制前景
        {
            Cull Back //剔除背景色

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL; //用来接收光照
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);      //转屏幕坐标
                o.normal = UnityObjectToWorldNormal(v.normal);  //转世界坐标
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 frontCol = tex2D(_MainTex, i.uv);

                // 根据灯光方向绘制阴影
                half nl = max(0, dot(i.normal, _WorldSpaceLightPos0.xyz));
                if (nl <= 0.01f) nl = 0.1f; //暗部
                else if (nl <= 0.3f) nl = 0.3f; //中间
                else nl = 1.0f; //亮部

                fixed4 col = fixed4(nl, nl, nl, 1) * frontCol;
                return col;
            }
            ENDCG
        }
    }
}