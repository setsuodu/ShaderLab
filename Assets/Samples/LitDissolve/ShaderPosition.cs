using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderPosition : MonoBehaviour
{
    void Update()
    {
        Shader.SetGlobalVector("_Position", transform.position);
    }
}