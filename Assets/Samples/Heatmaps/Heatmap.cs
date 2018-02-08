using UnityEngine;
using System.Collections;

public class Heatmap : MonoBehaviour
{
    public Vector4[] positions, properties;
    public float[] radiuses;
    public float[] intensities;

    private Material material;
    public int count = 50;

    void Awake()
    {
        material = GetComponent<MeshRenderer>().material;
    }

    void Start ()
    {
        positions = new Vector4[count];
        properties = new Vector4[count];
        radiuses = new float[count];
        intensities= new float[count];

        for (int i = 0; i < positions.Length; i++)
        {
            positions[i] = new Vector4(Random.Range(-0.4f, 0.4f), Random.Range(-0.4f, 0.4f), 0, 0);
            radiuses[i] = Random.Range(0f, 0.25f);
            intensities[i] = Random.Range(-0.25f, 1f);
        }
    }

    void Update()
    {
        material.SetInt("_Points_Length", positions.Length);

        
        for (int i = 0; i < positions.Length; i++)
        {
            positions[i] += new Vector4(Random.Range(-0.1f,+0.1f), Random.Range(-0.1f, +0.1f),0,0) * Time.deltaTime ;
            //material.SetVector("_Points" + i.ToString(), positions[i]);
            material.SetVectorArray("_Points", positions);

            properties[i] = new Vector4(radiuses[i], intensities[i],0,0);
            //material.SetVector("_Properties" + i.ToString(), properties);
            material.SetVectorArray("_Properties", properties);
        }
    }
}