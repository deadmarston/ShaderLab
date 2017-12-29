using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrightnessSaturationAndContrast : PostEffectsBase {
	public Shader briSatConShader;
	private Material briSatConMaterial;
	public Material material {
		get{
			briSatConMaterial = CheckShaderAndCreateMaterial (briSatConShader, briSatConMaterial);
			return briSatConMaterial;
		}
	}

	[Range(0f, 3f)]
	public float brightness = 1f;

	[Range(0f, 3f)]
	public float saturation = 1f;

	[Range(0f, 3f)]
	public float contrast = 1f;

	void OnRenderImage(RenderTexture src, RenderTexture dest){
		if (material != null) {
			material.SetFloat ("_Brightness", brightness);
			material.SetFloat ("_Saturtaion", saturation);
			material.SetFloat ("_Contrast", contrast);
			Graphics.Blit (src, dest, material);
		} else {
			Graphics.Blit (src, dest);
		}
	}

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
