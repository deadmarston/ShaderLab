using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDectNormalsAndDepth : PostEffectsBase {
	public Shader edgeShader;
	private Material edgeMaterial;
	public Material material{
		get{
			edgeMaterial = CheckShaderAndCreateMaterial (edgeShader, edgeMaterial);
			return edgeMaterial;
		}
	}

	[Range(0f, 1f)]
	public float edgesOnly = 0f;

	public Color edgeColor = Color.black;

	public Color backgroundColor = Color.white;

	public float sampleDistance = 1f;

	public float sensitivityDepth = 1f;

	public float sensitivityNormals = 1f;

	void OnEnable(){
		GetComponent<Camera> ().depthTextureMode |= DepthTextureMode.DepthNormals;
	}

	[ImageEffectOpaque]
	void OnRenderImage(RenderTexture src, RenderTexture dest){
		if (material != null) {
			material.SetFloat ("_EdgeOnly", edgesOnly);
			material.SetColor ("_EdgeColor", edgeColor);
			material.SetColor ("_BackgroundColor", backgroundColor);
			material.SetFloat ("_SampleDistance", sampleDistance);
			material.SetVector ("_Sensitivity", new Vector4 (sensitivityNormals, sensitivityDepth, 0f, 0f));
			Graphics.Blit (src, dest, material);
		} else {
			Graphics.Blit (src, dest);
		}
	}
}
