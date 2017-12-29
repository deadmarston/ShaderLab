Shader "Chapter11/ImageSequence"
{
	Properties
	{
		_Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex("Image Sequence", 2D) = "white"{}
		_HorizontalAmount ("Horizontal Amount", Float) = 4
		_VerticalAmount ("Vertical Amount", Float) = 4
		_Speed ("Speed", Range(1,100)) = 30
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			ZWrite off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _HorizontalAmount;
			float _VerticalAmount;
			float _Speed;

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.pos);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float time = floor(_Time.y * _Speed);
				float row = floor(time / _HorizontalAmount);
				float col = time - row * _HorizontalAmount;
				half2 uv = i.uv + half2(col, -row);
				uv.x /= _HorizontalAmount;
				uv.y /= _VerticalAmount;
				fixed4 c = tex2D(_MainTex, uv);
				c.rgb *= _Color;
				return c;
			}
			ENDCG
		}
	}
	Fallback "Transparent/VertexLit"
}
