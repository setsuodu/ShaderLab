using System.Collections;
using UnityEngine;

public class HoleThrough : MonoBehaviour
{
    void Start()
    {

    }

    void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hitInfo;
        if (Physics.Raycast(ray, out hitInfo))
        {
            Renderer renderer = hitInfo.transform.GetComponent<Renderer>();
            if (renderer)
            {
                renderer.material.SetVector("_HolePos", hitInfo.textureCoord);
            }
        }
    }
}