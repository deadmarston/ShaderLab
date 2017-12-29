using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlurWithDepthTexture : PostEffectsBase {
	public Shader blurShader;
	private Material blurMaterial = null;
	public Material material{
		get{
			blurMaterial = CheckShaderAndCreateMaterial (blurShader, blurMaterial);
			return blurMaterial;
		}
	}

	[Range(0f, 1f)]
	public float blurSize = 0.5f;

	private Matrix4x4 previousViewProjectionMatrix;

	private Camera myCamera;
	public Camera MyCamera{
		get{
			if (myCamera == null) {
				myCamera = GetComponent<Camera> ();
			}
			return myCamera;
		}
	}

	void OnEnable(){
		MyCamera.depthTextureMode |= DepthTextureMode.Depth;
		previousViewProjectionMatrix = MyCamera.projectionMatrix * MyCamera.worldToCameraMatrix;
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest){
		if (material != null) {
			material.SetFloat ("_BlurSize", blurSize);
			material.SetMatrix ("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);
			Matrix4x4 currentViewProjectionMatirx = MyCamera.projectionMatrix * MyCamera.worldToCameraMatrix;
			Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatirx.inverse;
			material.SetMatrix ("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
			previousViewProjectionMatrix = currentViewProjectionMatirx;

			Graphics.Blit (src, dest, material);
		} else {
			Graphics.Blit (src, dest);
		}
	}
}
