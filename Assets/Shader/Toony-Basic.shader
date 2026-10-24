// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_modelview0' with 'UNITY_MATRIX_MV'
// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "Toon/Basic" 
{
    Properties
    {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { TexGen CubeNormal }
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            Name "BASE"
            Tags { "RenderType"="Opaque" }
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            float4 _MainTex_ST;
            sampler2D _MainTex;
            samplerCUBE _ToonShade;
            float4 _Color;
            struct appdata_t
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord0 : TEXCOORD0;
            };
            struct v2f
            {
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 vertex : POSITION;
            };
            v2f vert(appdata_t v)
            {
                v2f o;
                float4 tmpvar_1;
                tmpvar_1.w = 0.0;
                tmpvar_1.xyz = normalize(v.normal);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord0 = ((v.texcoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
                o.texcoord1 = mul(UNITY_MATRIX_MV, tmpvar_1).xyz;
                return o;
            }
            float4 frag(v2f i) : SV_TARGET
            {
                float4 cube_1;
                float4 tmpvar_2;
                tmpvar_2 = tex2D (_MainTex, i.texcoord0);
                float4 tmpvar_3;
                tmpvar_3 = (_Color * tmpvar_2);
                float4 tmpvar_4;
                tmpvar_4 = texCUBE (_ToonShade, i.texcoord1);
                cube_1 = tmpvar_4;
                float4 tmpvar_5;
                tmpvar_5.xyz = ((2.0 * cube_1.xyz) * tmpvar_3.xyz);
                tmpvar_5.w = tmpvar_3.w;
                return tmpvar_5;
            }
            ENDCG
        }
    }
    Fallback "Mobile/VertexLit"
}