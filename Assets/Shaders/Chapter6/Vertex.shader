// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Chapter6/Vertex"
{
	Properties
	{
		_Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float3 color : COLOR;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
					
				o.color = ambient + diffuse;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				return fixed4(i.color, 1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
