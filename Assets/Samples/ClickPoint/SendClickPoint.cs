using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendClickPoint : MonoBehaviour
{
    private MeshRenderer render;
    //public List<Vector4> mousePath;

    void Awake()
    {
        render = GetComponent<MeshRenderer>();
    }

    void Start()
    {
        render.material.SetInt("_ScreenWidth", Screen.width);
        render.material.SetInt("_ScreenHeight", Screen.height);
    }

    void Update()
    {
        //if (Input.GetMouseButtonDown(0))
        //{
        //    mousePath = new List<Vector4>();
        //}
        if (Input.GetMouseButton(0))
        {
            Vector4 point = new Vector4(Input.mousePosition.x, Input.mousePosition.y, 0, 0);
            render.material.SetVector("_MousePoint", point);

            //mousePath.Add(point);
            //render.material.SetVectorArray("_Points", mousePath);
        }
    }
}
