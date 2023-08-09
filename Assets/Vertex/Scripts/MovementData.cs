using System;
using UnityEngine;

namespace Vertex.Scripts
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(MeshFilter))]
    public class MovementData : MonoBehaviour
    {
        public enum EaseType
        {
            OutCubic,
            OutElastic,
            OutExpo,
            OutBounce
        }
        [SerializeField] private string _velocityParameterName = "_Velocity";
        [SerializeField] private float _cadenceSpeed = 1;
        [SerializeField] private float _displacementSpeed = 1;
        [SerializeField] private float _deadZoneSize = 1;
        [SerializeField] private EaseType _ease;

        private MeshRenderer _renderer;
        private Vector3 _lastPosition;
        private Vector3 _velocity;
        private Vector3 _lastVelocity;
        private float _t;

        private void OnEnable()
        {
            if (!_renderer)
            {
                _renderer = GetComponent<MeshRenderer>();
            }

            _lastPosition = transform.position;
            _velocity = Vector3.zero;

            UpdateMeshData();
        }

        private void OnValidate()
        {
            if (!_renderer)
            {
                return;
            }

            UpdateMeshData();
        }

        private void UpdateMeshData()
        {
            if (Application.isPlaying)
            {
                _renderer.material.SetVector(_velocityParameterName, _velocity);
            }
            else
            {
                _renderer.sharedMaterial.SetVector(_velocityParameterName, _velocity);
            }
        }

        private void Update()
        {
            if (!_renderer)
            {
                return;
            }

            Vector3 newVelocity = transform.position - _lastPosition;

            float dif = (newVelocity - _velocity).magnitude;
            if (dif > _deadZoneSize &&
                (Vector3.zero - newVelocity).magnitude > _deadZoneSize)
            {
                _velocity = Vector3.Lerp(_velocity, newVelocity, Time.deltaTime * _displacementSpeed);
                _lastVelocity = _velocity;
                _t = 0f;//InverseLerp(_lastVelocity, Vector3.zero, _velocity) + Time.deltaTime * _cadenceSpeed;
            }

            UpdateMeshData();
            _t = Mathf.Clamp01(_t + Time.deltaTime * _cadenceSpeed);

            switch (_ease)
            {
                case EaseType.OutCubic:
                    _velocity = Vector3.Lerp(_lastVelocity, Vector3.zero, OutCubic(_t));
                    break;
                case EaseType.OutElastic:
                    _velocity = Vector3.Lerp(_lastVelocity, Vector3.zero, OutElastic(_t));
                    break;
                case EaseType.OutBounce:
                    _velocity = Vector3.Lerp(_lastVelocity, Vector3.zero, OutBounce(_t));
                    break;
                case EaseType.OutExpo:
                    _velocity = Vector3.Lerp(_lastVelocity, Vector3.zero, OutExpo(_t));
                    break;
                default:
                    _velocity = Vector3.Lerp(_lastVelocity, Vector3.zero, _t);
                    break;
            }

            _lastPosition = transform.position;
        }

        // study reference https://easings.net/
        // source https://gist.github.com/Kryzarel/bba64622057f21a1d6d44879f9cd7bd4
        private float InCubic(float t) => t * t * t;

        private float OutCubic(float t) => 1 - InCubic(1 - t);
        
        private float InExpo(float t) => (float)Math.Pow(2, 10 * (t - 1));
        private float OutExpo(float t) => 1 - InExpo(1 - t);

        private float OutElastic(float t)
        {
            float p = 0.3f;
            return (float)Math.Pow(2, -10 * t) * (float)Math.Sin((t - p / 4) * (2 * Math.PI) / p) + 1;
        }

        private float OutBounce(float t)
        {
            float div = 2.75f;
            float mult = 7.5625f;

            if (t < 1 / div)
            {
                return mult * t * t;
            }
            else if (t < 2 / div)
            {
                t -= 1.5f / div;
                return mult * t * t + 0.75f;
            }
            else if (t < 2.5 / div)
            {
                t -= 2.25f / div;
                return mult * t * t + 0.9375f;
            }
            else
            {
                t -= 2.625f / div;
                return mult * t * t + 0.984375f;
            }
        }
    }
}