using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlur : PostEffectsBase {
	public Shader blurShader;
	private Material blurMaterial = null;
	public Material material{
		get{
			blurMaterial = CheckShaderAndCreateMaterial (blurShader, blurMaterial);
			return blurMaterial;
		}
	}

	[Range(0f, 0.95f)]
	public float blurAmount = 0.5f;

	private RenderTexture accumulatonTexture;

	void OnDisable(){
		DestroyImmediate (accumulatonTexture);
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest){
		if (material != null) {
			if (accumulatonTexture == null || accumulatonTexture.width != src.width || accumulatonTexture.height != src.height) {
				DestroyImmediate (accumulatonTexture);
				accumulatonTexture = new RenderTexture (src.width, src.height, 0);
				accumulatonTexture.hideFlags = HideFlags.HideAndDontSave;
				Graphics.Blit (src, accumulatonTexture);
			}
			accumulatonTexture.MarkRestoreExpected ();

			material.SetFloat ("_BlurAmount", 1.0f - blurAmount);

			Graphics.Blit (src, accumulatonTexture, material);
			Graphics.Blit (accumulatonTexture, dest);
		} else {
			Graphics.Blit (src, dest);
		}
	}
}
