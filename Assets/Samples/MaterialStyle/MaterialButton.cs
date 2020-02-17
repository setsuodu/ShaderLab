using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class MaterialButton : MonoBehaviour,
    IPointerDownHandler,
    IPointerUpHandler,
    IPointerExitHandler
{
    private Vector2 point;
    private Material mat;
    private float radius = 0;
    private bool isUp;

    void Awake()
    {
        mat = new Material(Shader.Find("Custom/MaterialStyle"));
        GetComponent<Image>().material = mat;
    }

    IEnumerator normal()
    {
        while (true)
        {
            if (isUp) break;

            //size expand in normal speed
            radius *= 1.05f;
            mat.SetFloat("_Radius", radius);

            //pass vector4 of mousePosition to shader
            Vector4 v4 = new Vector4(point.x, point.y, 0, 0);
            mat.SetVector("_Point1", v4);

            if (radius == 0) break;

            yield return null;
        }
    }

    IEnumerator fast()
    {
        float timer = 0; 
        //enlarge wave for 1 sec
        while (timer < 1)
        {
            timer += Time.deltaTime;

            //size expand faster than normal speed
            radius *= 1.5f;
            mat.SetFloat("_Radius", radius);

            //color fade
            Vector4 col = new Vector4(1, timer, timer, 1);
            mat.SetVector("_Color", col);

            yield return null;
        }
        //reset
        isUp = false;
        radius = 0;
        mat.SetFloat("_Radius", radius);
    }

    #region Interface

    void IPointerDownHandler.OnPointerDown(PointerEventData data)
    {
        //when new wave begin, avoid confict with the old one
        StopAllCoroutines();

        isUp = false;

        //size and position of the new wave
        radius = 500;
        point = new Vector2(Input.mousePosition.x, Screen.height - Input.mousePosition.y);

        //color
        Vector4 col = new Vector4(1, 0, 0, 1);
        mat.SetVector("_Color", col);

        StartCoroutine(normal());
    }

    void IPointerUpHandler.OnPointerUp(PointerEventData data)
    {
        isUp = true; //to break normal coroutine
        StartCoroutine(fast());
    }

    void IPointerExitHandler.OnPointerExit(PointerEventData data)
    {
        StartCoroutine(fast());
    }

#endregion 

}
