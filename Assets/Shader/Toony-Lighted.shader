// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'
// Upgrade NOTE: commented out 'float4x4 _Object2World', a built-in variable
// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'
// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "Toon/Lighted" 
{
    Properties
    {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Ramp ("Toon Ramp (RGB)", 2D) = "gray" {}
    }
    SubShader
    {
        LOD 200
        Tags { "RenderType"="Opaque" }
        Pass
        {
            Name "FORWARD"
            Tags { "LIGHTMODE"="ForwardBase" "SHADOWSUPPORT"="true" "RenderType"="Opaque" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            // float4x4 _Object2World;
            float4 _MainTex_ST;
            #include "UnityLightingCommon.cginc"
            sampler2D _Ramp;
            sampler2D _MainTex;
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
                float3 texcoord2 : TEXCOORD2;
                float4 vertex : POSITION;
            };
            v2f vert(appdata_t v)
            {
                v2f o;
                float3 shlight_1;
                float3 tmpvar_2;
                float3 tmpvar_3;
                float3x3 tmpvar_4;
                tmpvar_4[0] = unity_ObjectToWorld[0].xyz;
                tmpvar_4[1] = unity_ObjectToWorld[1].xyz;
                tmpvar_4[2] = unity_ObjectToWorld[2].xyz;
                float3 tmpvar_5;
                tmpvar_5 = mul(tmpvar_4, (normalize(v.normal) * 1.0));
                tmpvar_2 = tmpvar_5;
                float4 tmpvar_6;
                tmpvar_6.w = 1.0;
                tmpvar_6.xyz = tmpvar_5;
                float3 tmpvar_7;
                float4 normal_8;
                normal_8 = tmpvar_6;
                float vC_9;
                float3 x3_10;
                float3 x2_11;
                float3 x1_12;
                float tmpvar_13;
                tmpvar_13 = dot (unity_SHAr, normal_8);
                x1_12.x = tmpvar_13;
                float tmpvar_14;
                tmpvar_14 = dot (unity_SHAg, normal_8);
                x1_12.y = tmpvar_14;
                float tmpvar_15;
                tmpvar_15 = dot (unity_SHAb, normal_8);
                x1_12.z = tmpvar_15;
                float4 tmpvar_16;
                tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
                float tmpvar_17;
                tmpvar_17 = dot (unity_SHBr, tmpvar_16);
                x2_11.x = tmpvar_17;
                float tmpvar_18;
                tmpvar_18 = dot (unity_SHBg, tmpvar_16);
                x2_11.y = tmpvar_18;
                float tmpvar_19;
                tmpvar_19 = dot (unity_SHBb, tmpvar_16);
                x2_11.z = tmpvar_19;
                float tmpvar_20;
                tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
                vC_9 = tmpvar_20;
                float3 tmpvar_21;
                tmpvar_21 = (unity_SHC.xyz * vC_9);
                x3_10 = tmpvar_21;
                tmpvar_7 = ((x1_12 + x2_11) + x3_10);
                shlight_1 = tmpvar_7;
                tmpvar_3 = shlight_1;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord0 = ((v.texcoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
                o.texcoord1 = tmpvar_2;
                o.texcoord2 = tmpvar_3;
                return o;
            }
            float4 frag(v2f i) : SV_TARGET
            {
                float4 c_1;
                float3 tmpvar_2;
                float4 c_3;
                float4 tmpvar_4;
                tmpvar_4 = tex2D (_MainTex, i.texcoord0);
                float4 tmpvar_5;
                tmpvar_5 = (tmpvar_4 * _Color);
                c_3 = tmpvar_5;
                float3 tmpvar_6;
                tmpvar_6 = c_3.xyz;
                tmpvar_2 = tmpvar_6;
                float3 lightDir_7;
                lightDir_7 = _WorldSpaceLightPos0.xyz;
                float4 c_8;
                float3 ramp_9;
                float tmpvar_10;
                tmpvar_10 = ((dot (i.texcoord1, lightDir_7) * 0.5) + 0.5);
                float3 tmpvar_11;
               tmpvar_11 = tex2D(_Ramp, tmpvar_10).xyz;

                ramp_9 = tmpvar_11;
                c_8.xyz = (((tmpvar_2 * _LightColor0.xyz) * ramp_9) * 2.0);
                c_8.w = 0.0;
                c_1 = c_8;
                c_1.xyz = (c_1.xyz + (tmpvar_2 * i.texcoord2));
                return c_1;
            }
            ENDCG
        }
        Pass
        {
            Name "FORWARD"
            Tags { "LIGHTMODE"="ForwardAdd" "RenderType"="Opaque" }
            ZWrite Off
            Fog {
            Color (0,0,0,0)
            }
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            // float4x4 _Object2World;
            float4x4 unity_WorldToLight;
            float4 _MainTex_ST;
            #include "UnityLightingCommon.cginc"
            sampler2D _LightTexture0;
            sampler2D _Ramp;
            sampler2D _MainTex;
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
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 vertex : POSITION;
            };
            v2f vert(appdata_t v)
            {
                v2f o;
                float3 tmpvar_1;
                float3 tmpvar_2;
                float3x3 tmpvar_3;
                tmpvar_3[0] = unity_ObjectToWorld[0].xyz;
                tmpvar_3[1] = unity_ObjectToWorld[1].xyz;
                tmpvar_3[2] = unity_ObjectToWorld[2].xyz;
                float3 tmpvar_4;
                tmpvar_4 = mul(tmpvar_3, (normalize(v.normal) * 1.0));
                tmpvar_1 = tmpvar_4;
                float3 tmpvar_5;
                tmpvar_5 = (_WorldSpaceLightPos0.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                tmpvar_2 = tmpvar_5;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord0 = ((v.texcoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
                o.texcoord1 = tmpvar_1;
                o.texcoord2 = tmpvar_2;
                o.texcoord3 = mul(unity_WorldToLight, mul(unity_ObjectToWorld, v.vertex)).xyz;
                return o;
            }
            float4 frag(v2f i) : SV_TARGET
            {
                float4 c_1;
                float3 lightDir_2;
                float3 tmpvar_3;
                float4 c_4;
                float4 tmpvar_5;
                tmpvar_5 = tex2D (_MainTex, i.texcoord0);
                float4 tmpvar_6;
                tmpvar_6 = (tmpvar_5 * _Color);
                c_4 = tmpvar_6;
                float3 tmpvar_7;
                tmpvar_7 = c_4.xyz;
                tmpvar_3 = tmpvar_7;
                float3 tmpvar_8;
                tmpvar_8 = normalize(i.texcoord2);
                lightDir_2 = tmpvar_8;
                float tmpvar_9;
                tmpvar_9 = dot (i.texcoord3, i.texcoord3);
                float4 tmpvar_10;
            tmpvar_10 = tex2D(_LightTexture0, tmpvar_9);

                float3 lightDir_11;
                lightDir_11 = lightDir_2;
                float atten_12;
                atten_12 = tmpvar_10.w;
                float4 c_13;
                float3 ramp_14;
                float3 tmpvar_15;
                tmpvar_15 = normalize(lightDir_11);
                lightDir_11 = tmpvar_15;
                float tmpvar_16;
                tmpvar_16 = ((dot (i.texcoord1, tmpvar_15) * 0.5) + 0.5);
                float3 tmpvar_17;
               tmpvar_17 = tex2D(_Ramp, tmpvar_16).xyz;

                ramp_14 = tmpvar_17;
                c_13.xyz = (((tmpvar_3 * _LightColor0.xyz) * ramp_14) * (atten_12 * 2.0));
                c_13.w = 0.0;
                c_1.xyz = c_13.xyz;
                c_1.w = 0.0;
                return c_1;
            }
            ENDCG
        }
    }
    Fallback "Mobile/Diffuse"
}