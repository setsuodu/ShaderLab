using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PixelShaderController : MonoBehaviour
{
    public Texture2D t2d;
    public RawImage rawImage;
    public Slider slider;
    public Material mat;

    void Awake()
    {
        slider.onValueChanged.AddListener((value) => Trans(value));
        ResetSize();
    }

    void Start()
    {
    }

    void OnDestroy()
    {
        ResetSize();
    }

    void Trans(float t)
    {
        //Debug.Log("slider: " + t);
        float width = t2d.width * (1 - t) * 0.5f + 1;
        float height = t2d.height * (1 - t) * 0.5f + 1;
        mat.SetFloat("_PixelWidth", width);
        mat.SetFloat("_PixelHeight", height);
    }

    void ResetSize()
    {
        mat.SetTexture("_MainTex", t2d);
        mat.SetFloat("_PixelWidth", t2d.width);
        mat.SetFloat("_PixelHeight", t2d.height);
        mat.SetFloat("_ScreenWidth", t2d.width);
        mat.SetFloat("_ScreenHeight", t2d.height);
    }
}

