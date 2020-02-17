using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Rigidbody rigid;
    private float speed = 10;
    private float vertical;

    void Awake()
    {
        rigid = GetComponent<Rigidbody>();
    }

    void Update()
    {
        vertical = Input.GetAxis("Vertical");
        rigid.AddForce(Vector3.forward * vertical * speed);
        //transform.Translate(Vector3.forward * vertical * speed);
    }
}
