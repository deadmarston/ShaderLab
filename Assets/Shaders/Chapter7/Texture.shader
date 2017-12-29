// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Chapter7/Texture"
{
	Properties
	{
		_Color ("Color Tine", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Specular;
			float _Gloss;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldNormal = normalize(i.worldNormal);
				float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));

				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1.0f);
			}
			ENDCG
		}
	}
	Fallback "Specular"
}
