using UnityEngine;

// UI display for individual llama showing speed, package count, elapsed time, and collision status
// Automatically positions in a grid layout to avoid overlapping
public class LlamaUI : MonoBehaviour {
    [Header("UI Settings")]
    public Color backgroundColor = Color.yellow;
    public Color textColor = Color.black;
    public int fontSize = 16;
    public float boxWidth = 200f;
    public float boxHeight = 25f;
    public float boxSpacing = 5f;
    
    [Header("Grid Layout")]
    public float gridSpacingX = 220f; // Horizontal spacing between llama UIs
    public float gridSpacingY = 100f; // Vertical spacing between llama UIs
    public Vector2 baseOffset = new Vector2(10f, 10f); // Offset from bottom-right corner
    
    private DeliveryVehicle vehicle;
    private CollisionDetector collisionDetector;
    private int llamaIndex = 0;
    private Rect speedBoxRect;
    private Rect packageBoxRect;
    private Rect timeBoxRect;
    private Rect collisionBoxRect;
    private GUIStyle boxStyle;
    private GUIStyle textStyle;
    private bool stylesInitialized = false;
    
    void Start() {
        vehicle = GetComponent<DeliveryVehicle>();
        if (vehicle == null) {
            Debug.LogError($"LlamaUI on {gameObject.name} requires a DeliveryVehicle component!");
            enabled = false;
            return;
        }
        
        collisionDetector = GetComponent<CollisionDetector>();
        if (collisionDetector == null) {
            Debug.LogError($"LlamaUI on {gameObject.name} requires a CollisionDetector component!");
            enabled = false;
            return;
        }
        
        // Extract llama index from game object name (e.g., "Llama_0", "Llama_1", etc.)
        string objName = gameObject.name;
        if (objName.Contains("_")) {
            string[] parts = objName.Split('_');
            if (parts.Length > 1 && int.TryParse(parts[1], out int index)) {
                llamaIndex = index;
            }
        }
        
        CalculateBoxPositions();
    }
    
    void CalculateBoxPositions() {
        // Calculate grid position for this llama
        // Llama 0: bottom-right
        // Llama 1: to the left of Llama 0
        // Llama 2: to the left of Llama 1
        
        float rightEdge = Screen.width - baseOffset.x;
        float bottomEdge = Screen.height - baseOffset.y;
        
        float xOffset = llamaIndex * gridSpacingX;
        
        // Bottom box (speed)
        speedBoxRect = new Rect(
            rightEdge - boxWidth - xOffset,
            bottomEdge - boxHeight,
            boxWidth,
            boxHeight
        );
        
        // Middle box (packages)
        packageBoxRect = new Rect(
            rightEdge - boxWidth - xOffset,
            bottomEdge - (boxHeight * 2 + boxSpacing),
            boxWidth,
            boxHeight
        );
        
        // Top box (time)
        timeBoxRect = new Rect(
            rightEdge - boxWidth - xOffset,
            bottomEdge - (boxHeight * 3 + boxSpacing * 2),
            boxWidth,
            boxHeight
        );
        
        // Collision status box (above time)
        collisionBoxRect = new Rect(
            rightEdge - boxWidth - xOffset,
            bottomEdge - (boxHeight * 4 + boxSpacing * 3),
            boxWidth,
            boxHeight
        );
    }
    
    void InitializeStyles() {
        if (stylesInitialized) return;
        
        Color[] llamaColors = new Color[] {
            new Color(1f, 1f, 0.3f), // Yellow for Llama 0
            new Color(0.3f, 1f, 0.3f), // Green for Llama 1
            new Color(0.3f, 0.8f, 1f)  // Blue for Llama 2
        };
        
        Color selectedColor = llamaIndex < llamaColors.Length ? llamaColors[llamaIndex] : backgroundColor;
        
        boxStyle = new GUIStyle(GUI.skin.box);
        Texture2D bgTexture = new Texture2D(1, 1);
        bgTexture.SetPixel(0, 0, selectedColor);
        bgTexture.Apply();
        boxStyle.normal.background = bgTexture;
        boxStyle.alignment = TextAnchor.MiddleCenter;
        
        textStyle = new GUIStyle(GUI.skin.label);
        textStyle.normal.textColor = textColor;
        textStyle.fontSize = fontSize;
        textStyle.fontStyle = FontStyle.Bold;
        textStyle.alignment = TextAnchor.MiddleCenter;
        
        stylesInitialized = true;
    }
    
    void OnGUI() {
        if (vehicle == null) return;
        
        InitializeStyles();
        
        Rect titleRect = new Rect(
            speedBoxRect.x,
            speedBoxRect.y - 25f,
            boxWidth,
            20f
        );
        
        GUIStyle titleStyle = new GUIStyle(textStyle);
        titleStyle.fontSize = 14;
        titleStyle.fontStyle = FontStyle.Bold;
        GUI.Label(titleRect, $"LLAMA {llamaIndex}", titleStyle);
        
        GUI.Box(speedBoxRect, "", boxStyle);
        GUI.Label(speedBoxRect, $"Speed: {vehicle.GetCurrentSpeed():F1} u/s", textStyle);
        
        GUI.Box(packageBoxRect, "", boxStyle);
        GUI.Label(packageBoxRect, $"Packages: {vehicle.GetCarriedPackageCount()}", textStyle);
        
        GUI.Box(timeBoxRect, "", boxStyle);
        string timeText = vehicle.HasCompletedDelivery() 
            ? $"Time: {vehicle.GetElapsedTime():F2}s DONE"
            : $"Time: {vehicle.GetElapsedTime():F2}s";
        GUI.Label(timeBoxRect, timeText, textStyle);
        
        string collisionStatus = "No Collision";
        Color statusColor = Color.green;
        
        if (collisionDetector.IsJumping()) {
            collisionStatus = "JUMPING";
            statusColor = Color.cyan;
        } else if (collisionDetector.IsPaused()) {
            collisionStatus = "PAUSED";
            statusColor = Color.red;
        }
        
        GUIStyle collisionBoxStyle = new GUIStyle(boxStyle);
        Texture2D collisionBgTexture = new Texture2D(1, 1);
        collisionBgTexture.SetPixel(0, 0, statusColor);
        collisionBgTexture.Apply();
        collisionBoxStyle.normal.background = collisionBgTexture;
        
        GUI.Box(collisionBoxRect, "", collisionBoxStyle);
        GUI.Label(collisionBoxRect, collisionStatus, textStyle);
    }
}
