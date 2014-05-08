Shader "Custom/Aniso Vinyl Groove"
{
	Properties
    {
		_MainTex("Anisotropy Map", 2D) = "white" {}
        _Gloss("Gloss", float) = 1
        _Specular("Specular", float) = 0.8 
        _Fresnel("Fresnel", float) = 0.6
        _InvAlphaX("Inv Alpha X", float) = 10
        _InvAlphaY("Inv Alpha Y", float) = 0.6
	}
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf AnisoGroove vertex:vert noambient

        sampler2D _MainTex;
        half _Gloss;
        half _Specular;
        half _Fresnel;
        half _InvAlphaX;
        half _InvAlphaY;

        struct CustomSurfaceOutput
        {
            half3 Albedo;
            half3 Normal;
            half4 Tangent;
            half3 Emission;
            half Specular;
            half Gloss;
            half Alpha;
        };

        half4 LightingAnisoGroove(CustomSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half3 b = cross(s.Normal, s.Tangent.xyz) * s.Tangent.w;
            half3 h = normalize(lightDir + viewDir);

            half ln = dot(lightDir, s.Normal);
            half hn = dot(h, s.Normal);
            half vn = dot(viewDir, s.Normal);
            half vh = dot(viewDir, h);
            half ht = dot(h, s.Tangent.xyz) * _InvAlphaX;
            half hb = dot(h, b) * _InvAlphaY;

            float f_e = pow(1 - vh, 5);
            float f = f_e + _Fresnel * (1 - f_e);

            float spec_iso = pow(hn, s.Specular * 128) * f;
            float spec_aniso = sqrt(max(0, ln / vn)) * exp(-2 * (ht * ht + hb * hb) / (1 + hn));
            float spec = lerp(spec_iso, spec_aniso, s.Alpha) * s.Gloss;

            return half4(_LightColor0.rgb * (spec * atten * 2), s.Alpha);
        }

        struct Input
        {
            half4 tangent;
            float2 uv_MainTex;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.tangent = half4(mul((half3x3)_Object2World, v.tangent.xyz * unity_Scale.w), v.tangent.w);
        }

        void surf(Input IN, inout CustomSurfaceOutput o)
        {
            o.Alpha = tex2D(_MainTex, IN.uv_MainTex).r;
            o.Gloss = _Gloss;
            o.Specular = _Specular;
            o.Tangent = IN.tangent;
        }
        ENDCG
    } 
	FallBack "Specular"
}
