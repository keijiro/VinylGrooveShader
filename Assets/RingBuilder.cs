using UnityEngine;
using System.Collections;

public class RingBuilder : MonoBehaviour
{
    public int division = 128;
    public float innterRadius = 0.5f;
    public float outerRadius = 1.0f;
    public bool polarUV = true;

    Mesh mesh;

    void Awake()
    {
        var va = new Vector3[division * 2];
        var na = new Vector3[division * 2];
        var ta = new Vector4[division * 2];
        var uv = new Vector2[division * 2];

        var vi = 0;

        for (var i = 0; i < division; i++)
        {
            var u = 1.0f * i / (division - 1);
            var a = Mathf.PI * 2 * u;
            var p = new Vector3(Mathf.Cos(a), Mathf.Sin(a), 0);
            var t = new Vector4(-Mathf.Sin(a), Mathf.Cos(a), 0, 1);

            va[vi] = p * innterRadius;
            if (polarUV)
                uv[vi] = new Vector2(u * 0.8f + 0.1f, innterRadius);
            else
                uv[vi] = va[vi];
            na[vi] = -Vector3.forward;
            ta[vi] = t;
            vi++;

            va[vi] = p * outerRadius;
            if (polarUV)
                uv[vi] = new Vector3(u * 0.8f + 0.1f, outerRadius);
            else
                uv[vi] = va[vi];
            na[vi] = -Vector3.forward;
            ta[vi] = t;
            vi++;
        }

        var ia = new int[(division - 1) * 6];

        var ii = 0;
        vi = 0;

        for (var i = 0; i < division - 1; i++)
        {
            ia[ii++] = vi;
            ia[ii++] = vi + 2;
            ia[ii++] = vi + 1;

            ia[ii++] = vi + 1;
            ia[ii++] = vi + 2;
            ia[ii++] = vi + 3;

            vi += 2;
        }

        mesh = new Mesh();
        mesh.vertices = va;
        mesh.normals = na;
        mesh.tangents = ta;
        mesh.uv = uv;
        mesh.SetIndices(ia, MeshTopology.Triangles, 0);

        GetComponent<MeshFilter>().mesh = mesh;
    }
}
