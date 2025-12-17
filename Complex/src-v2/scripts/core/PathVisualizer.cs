using UnityEngine;
using System.Collections.Generic;

public class PathVisualizer : MonoBehaviour {
    [Header("References")]
    public PathfindingManager pathfinder;
    
    [Header("Visual Settings")]
    public float lineWidth = 1f;
    public float lineHeight = 3f; 
    public float rainbowSpeed = 2f;
    
    [Header("Animation")]
    public bool animateColors = true;
    public float animationSpeed = 1f;
    
    [Header("Color Offset")]
    public float colorHueOffset = 0f; 
    
    private float colorOffset = 0f;
    private LineRenderer lineRenderer;
    private List<Vector2Int> currentPath;
    
    void Start() {
        lineRenderer = gameObject.AddComponent<LineRenderer>();
        
        lineRenderer.startWidth = lineWidth;
        lineRenderer.endWidth = lineWidth;
        lineRenderer.material = new Material(Shader.Find("Sprites/Default"));
        lineRenderer.sortingOrder = 100;
        lineRenderer.numCapVertices = 5;
        lineRenderer.numCornerVertices = 5;
        
        colorHueOffset = Random.Range(0f, 1f);
        
        lineRenderer.positionCount = 0;
    }
    
    void Update() {
        if (animateColors) {
            colorOffset += Time.deltaTime * animationSpeed;
            UpdatePathVisualization();
        }
    }
    
    public void UpdatePathVisualization() {
        if (currentPath == null || currentPath.Count == 0) {
            lineRenderer.positionCount = 0;
            return;
        }
        
        lineRenderer.positionCount = currentPath.Count;
        
        for (int i = 0; i < currentPath.Count; i++) {
            Vector3 worldPos = pathfinder.GridToWorld(currentPath[i]);
            worldPos.y += lineHeight;
            lineRenderer.SetPosition(i, worldPos);
        }
        
        Gradient gradient = new Gradient();
        GradientColorKey[] colorKeys = new GradientColorKey[7];
        GradientAlphaKey[] alphaKeys = new GradientAlphaKey[2];
        
        for (int i = 0; i < 7; i++) {
            float t = (i / 6f + colorOffset + colorHueOffset) % 1f;
            colorKeys[i] = new GradientColorKey(GetRainbowColor(t * rainbowSpeed), i / 6f);
        }
        
        alphaKeys[0] = new GradientAlphaKey(1f, 0f);
        alphaKeys[1] = new GradientAlphaKey(1f, 1f);
        
        gradient.SetKeys(colorKeys, alphaKeys);
        lineRenderer.colorGradient = gradient;
    }
    
    Color GetRainbowColor(float t) {
        t = t % 1f;
        return Color.HSVToRGB(t, 1f, 1f);
    }
    
    public void SetPath(List<Vector2Int> path) {
        currentPath = path;
        UpdatePathVisualization();
    }
    
    public void ClearPath() {
        currentPath = null;
        lineRenderer.positionCount = 0;
    }
    
    public void OnPathCalculated() {
        currentPath = pathfinder.GetCurrentPath();
        UpdatePathVisualization();
    }
}
