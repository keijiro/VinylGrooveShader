Shader "Custom/Vinyl"
{
	Properties
    {
		_MainTex ("Base and Gloss", 2D) = "white" {}
        _Color ("Color", Color) = (0, 0, 0, 0)
        _InvAlphaX ("Invert Alpha X", float) = 1
        _InvAlphaY ("Invert Alpha Y", float) = 1
	}

    CGINCLUDE

    #pragma exclude_renderers d3d11 xbox360
    #include "UnityCG.cginc"

    struct v2f
    {
        float4 position : SV_POSITION;
        float2 texcoord : TEXCOORD0;
        float3 normal;
        float3 tangent;
        float3 viewDir;
        float3 lightDir;
    };

    sampler2D _MainTex;
    half4 _Color;
    float _InvAlphaX;
    float _InvAlphaY;

    v2f vert(appdata_tan v)
    {
        v2f o;

        o.position = mul(UNITY_MATRIX_MVP, v.vertex);
        o.texcoord = v.texcoord.xy;

        o.normal = v.normal;
        o.tangent = v.tangent;

        o.viewDir = ObjSpaceViewDir(v.vertex);
        o.lightDir = ObjSpaceLightDir(v.vertex);

        return o;
    }

    half4 frag(v2f i) : SV_Target
    {
        half4 bc = tex2D(_MainTex, i.texcoord);

        float3 l = normalize(i.lightDir);
        float3 v = normalize(i.viewDir);
        float3 n = normalize(i.normal);
        float3 t = normalize(i.tangent);
        float3 b = cross(n, t);
        float3 h = normalize(l + v);

        float ln = dot(l, n);
        float hn = dot(h, n);
        float vn = dot(v, n);
        float ht = dot(h, t) * _InvAlphaX;
        float hb = dot(h, b) * _InvAlphaY;

        float spec = sqrt(max(0, ln / vn)) * exp(-2 * (ht * ht + hb * hb) / (1 + hn));

        half4 c;
        c.rgb = _Color * ln * bc.a + spec * bc.a;
        c.a = 0;

        return c;
    }

    ENDCG

	SubShader
    {
		Tags { "RenderType"="Opaque" }
        pass
        {
            CGPROGRAM
            #pragma fragmentoption ARB_precision_hint_fastest 
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
	} 
	FallBack "Diffuse"
}
