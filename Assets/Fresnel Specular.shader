Shader "Custom/Fresnel Specular"
{
    Properties
    {
        _MainTex("Base", 2D) = "white" {}
        _Color("Color", Color) = (0.5, 0.5, 0.5, 1)
        _Gloss("Gloss", float) = 1
        _Specular("Specular", float) = 0.8 
        _Fresnel("Fresnel", float) = 0.6
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf FresnelSpecular

        sampler2D _MainTex;
        half4 _Color;
        half _Gloss;
        half _Specular;
        half _Fresnel;

        half4 LightingFresnelSpecular(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half3 h = normalize(lightDir + viewDir);

            half ln = dot(lightDir, s.Normal);
            half hn = dot(h, s.Normal);
            half vh = dot(viewDir, h);

            float f_e = pow(1 - vh, 5);
            float f = f_e + _Fresnel * (1 - f_e);

            float diff = max(0, ln);
            float spec = pow(hn, s.Specular * 128) * f * s.Gloss;

            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * (atten * 2);

            c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 tc = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = tc.rgb;
            o.Gloss = _Gloss;
            o.Specular = _Specular;
            o.Alpha = tc.a;
        }
        ENDCG
    } 
    FallBack "Specular"
}
