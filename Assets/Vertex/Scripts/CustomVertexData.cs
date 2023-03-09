using System;
using UnityEngine;

namespace Vertex.Scripts
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(MeshFilter))]
    public class CustomVertexData : MonoBehaviour
    {
        [SerializeField] int _definition = 50;
        private MeshFilter _filter;
        private Mesh _mesh;

        private void OnEnable()
        {
            if(!_filter)
            {
                _filter = GetComponent<MeshFilter>();
            }

            if(!_mesh)
            {
                _mesh = _filter.sharedMesh;
            }

            UpdateMeshData();
        }

        private void OnValidate()
        {
            if(!_filter || !_mesh)
            {
                return;
            }

            UpdateMeshData();
        }

        private void UpdateMeshData()
        {
            for (int i = 0; i < 2; i++)
            {
                var data = new Vector2[_mesh.vertices.Length];

                for (int j = 0, n = data.Length; j < n; j++)
                {
                    data[j] = i % 2 == 0
                        ? new Vector2((j % _definition) / (float)_definition, i / (float)n)
                        : new Vector2((_definition - (j % _definition)) / (float)_definition, i / (float)n);
                }

                switch (i)
                {
                    case 0:
                        _mesh.uv2 = data;
                        break;
                    case 1:
                        _mesh.uv3 = data;
                        break;
                }
            }
        }
    }
}
