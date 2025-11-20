using UnityEngine;
using System.Collections.Generic;

public class PathVisualizer : MonoBehaviour {
    [Header("References")]
    public PathfindingManager pathfinder;
    
    [Header("Visual Settings")]
    private float lineWidth = 1f;
    private float lineHeight = 3f; 
    private float rainbowSpeed = 2f;
    
    [Header("Animation")]
    public bool animateColors = true;
    public float animationSpeed = 1f;
    
    private float colorOffset = 0f;
    private LineRenderer lineRenderer;
    
    void Start() {

        lineRenderer = gameObject.AddComponent<LineRenderer>();
        
        // Setup LineRenderer
        lineRenderer.startWidth = lineWidth;
        lineRenderer.endWidth = lineWidth;
        lineRenderer.material = new Material(Shader.Find("Sprites/Default"));

        // make sure it is drawn on top of all other geometry like the roads, basically z index equivalent
        lineRenderer.sortingOrder = 100;
        lineRenderer.numCapVertices = 5;
        lineRenderer.numCornerVertices = 5;
        
        // Initially hide it
        lineRenderer.positionCount = 0;
    }
    
    void Update() {
        colorOffset += Time.deltaTime * animationSpeed;
        UpdatePathVisualization();
    }
    
    public void UpdatePathVisualization() {
        List<Vector2Int> path = pathfinder.GetCurrentPath();

        // get the list of paths from a*
        if (path == null || path.Count == 0) {
            lineRenderer.positionCount = 0;
            return;
        }

        // make the line renderer's position count match the number of waypoints
        // add lineheight to make the rainbow above road surface, set that position accorind got the worldPos
        lineRenderer.positionCount = path.Count;
        for (int i = 0; i < path.Count; i++) {
            Vector3 worldPos = pathfinder.GridToWorld(path[i]);
            worldPos.y += lineHeight;
            lineRenderer.SetPosition(i, worldPos);
        }

        // Set colors
        Gradient gradient = new Gradient();
        GradientColorKey[] colorKeys = new GradientColorKey[7];
        GradientAlphaKey[] alphaKeys = new GradientAlphaKey[2];

        // Rainbow colors
        for (int i = 0; i < 7; i++) {
            float t = (i / 6f + colorOffset) % 1f;
            colorKeys[i] = new GradientColorKey(GetRainbowColor(t * rainbowSpeed), i / 6f);
        }

        alphaKeys[0] = new GradientAlphaKey(1f, 0f);
        alphaKeys[1] = new GradientAlphaKey(1f, 1f);

        gradient.SetKeys(colorKeys, alphaKeys);
        lineRenderer.colorGradient = gradient;
    }
    
    Color GetRainbowColor(float t) {
        // HSV to RGB for smooth rainbow
        t = t % 1f;
        return Color.HSVToRGB(t, 1f, 1f);
    }
    
    public void ClearPath() {
        lineRenderer.positionCount = 0;
    }
    
    // Call this when path changes
    public void OnPathCalculated() {
        UpdatePathVisualization();
    }
}
