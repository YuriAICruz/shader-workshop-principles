using System;
using UnityEngine;

namespace Vertex.Scripts
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(MeshFilter))]
    public class CustomVertexData : MonoBehaviour
    {
        [SerializeField] int _definition = 50;
        [SerializeField] [Range(0, 1)] float _hardValue = 0;

        private MeshFilter _filter;
        private Mesh _mesh;

        private Vector3[] _data1;
        private Vector3[] _data2;

        private void OnEnable()
        {
            if (!_filter)
            {
                _filter = GetComponent<MeshFilter>();
            }

            if (!_mesh)
            {
                _mesh = _filter.sharedMesh;
            }

            UpdateDataArray();

            UpdateMeshData();
        }

        private void OnValidate()
        {
            if (!_filter || !_mesh)
            {
                return;
            }

            UpdateMeshData();
        }

        private void UpdateMeshData()
        {
            for (int i = 0, n = _data1.Length; i < n; i++)
            {
                _data1[i] = new Vector3((i % _definition) / (float)_definition, i / (float)n, i%2);
                _data2[i] = new Vector3(_hardValue, 1-(i / (float)n), 1-_hardValue);
            }

            _mesh.SetUVs(1,_data1);
            _mesh.SetUVs(2,_data2);
        }

        private void UpdateDataArray()
        {
            if (_data1 == null || _data1.Length != _mesh.vertices.Length)
            {
                _data1 = new Vector3[_mesh.vertices.Length];
            }

            if (_data2 == null || _data2.Length != _mesh.vertices.Length)
            {
                _data2 = new Vector3[_mesh.vertices.Length];
            }
        }
    }
}