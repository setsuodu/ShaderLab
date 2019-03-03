Shader "Custom/Alpha/CutoffAlpha" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _AlphaTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff("Cutoff Value",Range(0,1.1))=0.5
        
    }
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert alphatest:_Cutoff

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _AlphaTex;

        struct Input {
            float2 uv_MainTex;
            float2 uv_AlphaTex;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o) {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            //o.Alpha = c.b;

			fixed4 d = tex2D (_AlphaTex, IN.uv_AlphaTex) * _Color;
            o.Alpha = d.b;
        }
        ENDCG
    } 
    FallBack "Diffuse"
}
