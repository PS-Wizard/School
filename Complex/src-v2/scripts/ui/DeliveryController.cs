using UnityEngine;
using System.Collections.Generic;
using System.Linq;

// Main controller for multi-llama delivery system with round-robin assignment
public class DeliveryController : MonoBehaviour {
    [Header("Core References")]
    public PathfindingManager pathfindingManager;
    public Camera mainCamera;
    public GameObject llamaPrefab;
    
    [Header("Marker Prefabs (Optional)")]
    public GameObject pickupMarkerPrefab;
    public GameObject deliveryMarkerPrefab;
    public GameObject blockerPrefab;
    
    [Header("Settings")]
    public float raycastDistance = 1000f;
    public LayerMask roadLayer = -1;
    public float markerHeightOffset = 1f;
    public bool returnToStart = true;
    
    [Header("Multi-Llama Settings")]
    public int maxLlamas = 3;
    public int maxDeliveryPoints = 3;
    public float llamaHeightAboveGround = 2f;
    
    [Header("Llama POV Camera Settings")]
    public Vector3 cameraLocalPosition = new Vector3(0f, 3f, -5f);
    public Vector3 cameraLocalRotation = new Vector3(10f, 0f, 0f);
    public float cameraFOV = 60f;
    
    public enum ClickMode {
        SetLlamaStart,
        SetPickup,
        SetDelivery,
        ToggleBlock
    }

    public ClickMode currentMode = ClickMode.SetLlamaStart;
    
    private List<LlamaInfo> llamas = new List<LlamaInfo>();
    private List<GameObject> llamaStartMarkers = new List<GameObject>();
    
    private List<PickupPoint> pickupPoints = new List<PickupPoint>();
    private List<DeliveryPoint> deliveryPoints = new List<DeliveryPoint>();
    
    private List<GameObject> blockMarkers = new List<GameObject>();
    
    private class PickupPoint {
        public Vector2Int gridPos;
        public GameObject marker;
    }
    
    private class DeliveryPoint {
        public Vector2Int gridPos;
        public GameObject marker;
        public int assignedLlamaIndex;
    }
    
    private class LlamaInfo {
        public DeliveryVehicle vehicle;
        public Vector2Int startGridPos;
        public int llamaIndex;
        public PathVisualizer visualizer;
        public Camera povCamera;
    }
    
    void Start() {
        if (llamaPrefab == null) {
            Debug.LogError("Please assign Llama Prefab!");
        }
    }
    
    void Update() {
        HandleModeSwitch();
        HandleMouseInput();
        HandleKeyboardShortcuts();
    }
    
    private void HandleModeSwitch() {
        if (Input.GetKeyDown(KeyCode.Alpha1)) {
            currentMode = ClickMode.SetLlamaStart;
            Debug.Log("Mode: SET LLAMA START");
        }
        else if (Input.GetKeyDown(KeyCode.Alpha2)) {
            currentMode = ClickMode.SetPickup;
            Debug.Log("Mode: SET PICKUP");
        }
        else if (Input.GetKeyDown(KeyCode.Alpha3)) {
            currentMode = ClickMode.SetDelivery;
            Debug.Log("Mode: SET DELIVERY");
        }
        else if (Input.GetKeyDown(KeyCode.Alpha4)) {
            currentMode = ClickMode.ToggleBlock;
            Debug.Log("Mode: TOGGLE BLOCK");
        }
    }
    
    private void HandleMouseInput() {
        if (Input.GetMouseButtonDown(0)) {
            Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);
            
            if (Physics.Raycast(ray, out RaycastHit hit, raycastDistance, roadLayer)) {
                GridTile tile = hit.collider.GetComponent<GridTile>();
                if (tile != null) {
                    Vector2Int gridPos = tile.gridPosition;
                    Vector3 worldPos = hit.collider.transform.position;
                    
                    switch (currentMode) {
                        case ClickMode.SetLlamaStart:
                            SetLlamaStart(gridPos, worldPos);
                            break;
                        case ClickMode.SetPickup:
                            SetPickup(gridPos, worldPos);
                            break;
                        case ClickMode.SetDelivery:
                            SetDelivery(gridPos, worldPos);
                            break;
                        case ClickMode.ToggleBlock:
                            ToggleBlock(gridPos, worldPos);
                            break;
                    }
                }
            }
        }
    }
    
    private void HandleKeyboardShortcuts() {
        if (Input.GetKeyDown(KeyCode.Space)) {
            CalculateAndStartDeliveries();
        }
        
        if (Input.GetKeyDown(KeyCode.R)) {
            ResetAll();
        }

        if (Input.GetKeyDown(KeyCode.C)) {
            ClearAllBlockers();
        }
    }
    
    private void SetLlamaStart(Vector2Int gridPos, Vector3 worldPos) {
        if (llamas.Count >= maxLlamas) {
            Debug.LogWarning($"Maximum llamas ({maxLlamas}) already placed!");
            return;
        }

        // Get the actual center of the tile for precise placement
        Vector3 tileCenter = pathfindingManager.GridToWorld(gridPos);

        // Create start marker at tile center
        GameObject marker = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        marker.transform.position = tileCenter + Vector3.up * markerHeightOffset;
        marker.transform.localScale = Vector3.one * 3f;
        marker.GetComponent<Renderer>().material.color = Color.green;

        Collider markerCollider = marker.GetComponent<Collider>();
        if (markerCollider != null) Destroy(markerCollider);

        marker.name = $"LlamaStart_{llamas.Count}";
        llamaStartMarkers.Add(marker);

        // Spawn llama at tile center (not at raycast hit point)
        GameObject llamaObj = Instantiate(llamaPrefab, tileCenter + Vector3.up * llamaHeightAboveGround, Quaternion.identity);
        llamaObj.name = $"Llama_{llamas.Count}";
        llamaObj.tag = "Llama";

        DeliveryVehicle vehicle = llamaObj.GetComponent<DeliveryVehicle>();
        if (vehicle == null) {
            vehicle = llamaObj.AddComponent<DeliveryVehicle>();
        }

        vehicle.pathfindingManager = pathfindingManager;
        vehicle.heightAboveGround = llamaHeightAboveGround;

        // Add CollisionDetector
        CollisionDetector detector = llamaObj.GetComponent<CollisionDetector>();
        if (detector == null) {
            detector = llamaObj.AddComponent<CollisionDetector>();
        }

        // Add LlamaUI
        LlamaUI ui = llamaObj.AddComponent<LlamaUI>();

        // Add path visualizer
        GameObject visualizerObj = new GameObject($"PathVisualizer_Llama_{llamas.Count}");
        PathVisualizer visualizer = visualizerObj.AddComponent<PathVisualizer>();
        visualizer.pathfinder = pathfindingManager;

        LlamaInfo info = new LlamaInfo {
            vehicle = vehicle,
            startGridPos = gridPos,
            llamaIndex = llamas.Count,
            visualizer = visualizer,
            povCamera = null
        };

        llamas.Add(info);

        Debug.Log($"Llama {llamas.Count} placed at {gridPos} (center: {tileCenter})");
    }
    
    private void SetPickup(Vector2Int gridPos, Vector3 worldPos) {
        PickupPoint pickup = new PickupPoint {
            gridPos = gridPos,
            marker = CreateMarker(pickupMarkerPrefab, worldPos, Color.yellow, $"Pickup_{pickupPoints.Count}")
        };
        
        pickupPoints.Add(pickup);
        Debug.Log($"Pickup {pickupPoints.Count} set at {gridPos}");
    }
    
    private void SetDelivery(Vector2Int gridPos, Vector3 worldPos) {
        if (deliveryPoints.Count >= maxDeliveryPoints) {
            Debug.LogWarning($"Maximum delivery points ({maxDeliveryPoints}) already placed!");
            return;
        }
        
        DeliveryPoint delivery = new DeliveryPoint {
            gridPos = gridPos,
            marker = CreateMarker(deliveryMarkerPrefab, worldPos, Color.red, $"Delivery_{deliveryPoints.Count}"),
            assignedLlamaIndex = deliveryPoints.Count
        };
        
        deliveryPoints.Add(delivery);
        Debug.Log($"Delivery {deliveryPoints.Count} set at {gridPos} (assigned to Llama {delivery.assignedLlamaIndex})");
    }
    
    private void ToggleBlock(Vector2Int gridPos, Vector3 worldPos) {
        if (pathfindingManager.blockedRoads.Contains(gridPos)) {
            pathfindingManager.UnblockRoad(gridPos);
            
            GameObject markerToRemove = blockMarkers.Find(m => 
                Vector3.Distance(m.transform.position, worldPos + Vector3.up * markerHeightOffset) < 1f);
            
            if (markerToRemove != null) {
                blockMarkers.Remove(markerToRemove);
                Destroy(markerToRemove);
            }
        }
        else {
            pathfindingManager.BlockRoad(gridPos);
            GameObject marker = CreateMarker(blockerPrefab, worldPos, Color.yellow, $"Blocker_{gridPos.x}_{gridPos.y}", true);
            blockMarkers.Add(marker);
        }
    }
    
    private GameObject CreateMarker(GameObject prefab, Vector3 worldPos, Color defaultColor, string name, bool useCube = false) {
        GameObject marker;
        
        if (prefab != null) {
            marker = Instantiate(prefab, worldPos + Vector3.up * markerHeightOffset, Quaternion.identity);
        } else {
            marker = GameObject.CreatePrimitive(useCube ? PrimitiveType.Cube : PrimitiveType.Sphere);
            marker.transform.position = worldPos + Vector3.up * markerHeightOffset;
            marker.transform.localScale = Vector3.one * (useCube ? 2f : 3f);
            marker.GetComponent<Renderer>().material.color = defaultColor;
            Destroy(marker.GetComponent<Collider>());
        }
        
        marker.name = name;
        return marker;
    }
    
    private void CalculateAndStartDeliveries() {
        if (llamas.Count == 0) {
            Debug.LogError("Please place at least one llama!");
            return;
        }
        
        if (pickupPoints.Count == 0) {
            Debug.LogError("Please place at least one pickup point!");
            return;
        }
        
        if (deliveryPoints.Count == 0) {
            Debug.LogError("Please place at least one delivery point!");
            return;
        }
        
        AssignPickupsRoundRobin();
        
        AudioManager.PlayVehicleSound();
    }
    
    private void AssignPickupsRoundRobin() {
        int currentLlamaIndex = 0;
        
        foreach (PickupPoint pickup in pickupPoints) {
            LlamaInfo llama = llamas[currentLlamaIndex];
            DeliveryPoint delivery = deliveryPoints[llama.llamaIndex % deliveryPoints.Count];
            
            List<Vector2Int> pathToPickup = pathfindingManager.CalculatePath(llama.startGridPos, pickup.gridPos);
            List<Vector2Int> pathToDelivery = pathfindingManager.CalculatePath(pickup.gridPos, delivery.gridPos);
            
            if (pathToPickup == null || pathToDelivery == null) {
                Debug.LogWarning($"Could not find path for Llama {currentLlamaIndex}");
                currentLlamaIndex = (currentLlamaIndex + 1) % llamas.Count;
                continue;
            }
            
            List<Vector2Int> fullPath = new List<Vector2Int>();
            fullPath.AddRange(pathToPickup);
            
            int pickupIndex = pathToPickup.Count - 1;
            
            for (int i = 1; i < pathToDelivery.Count; i++) {
                fullPath.Add(pathToDelivery[i]);
            }
            
            int deliveryIndex = fullPath.Count - 1;
            
            if (returnToStart) {
                List<Vector2Int> pathBackToStart = pathfindingManager.CalculatePath(delivery.gridPos, llama.startGridPos);
                if (pathBackToStart != null) {
                    for (int i = 1; i < pathBackToStart.Count; i++) {
                        fullPath.Add(pathBackToStart[i]);
                    }
                }
            }
            
            llama.vehicle.SetDeliveryInfo(pickup.marker, pickupIndex, deliveryIndex);
            llama.vehicle.StartFollowingPath(fullPath);
            
            pathfindingManager.SetCurrentPath(fullPath);
            llama.visualizer.OnPathCalculated();
            
            Debug.Log($"Llama {currentLlamaIndex} assigned pickup at {pickup.gridPos}, delivery at {delivery.gridPos}");
            
            currentLlamaIndex = (currentLlamaIndex + 1) % llamas.Count;
        }
    }
    
    private void ResetAll() {
        // Destroy all llamas and their components
        foreach (LlamaInfo llama in llamas) {
            if (llama.vehicle != null) {
                Destroy(llama.vehicle.gameObject);
            }
            if (llama.visualizer != null) {
                Destroy(llama.visualizer.gameObject);
            }
        }
        llamas.Clear();

        // Destroy llama start markers
        foreach (GameObject marker in llamaStartMarkers) {
            if (marker != null) Destroy(marker);
        }
        llamaStartMarkers.Clear();

        // Destroy pickup markers
        foreach (PickupPoint pickup in pickupPoints) {
            if (pickup.marker != null) Destroy(pickup.marker);
        }
        pickupPoints.Clear();

        // Destroy delivery markers
        foreach (DeliveryPoint delivery in deliveryPoints) {
            if (delivery.marker != null) Destroy(delivery.marker);
        }
        deliveryPoints.Clear();

        // Clear all blockers
        ClearAllBlockers();

        // Find and destroy any remaining path visualizers
        PathVisualizer[] remainingVisualizers = FindObjectsOfType<PathVisualizer>();
        foreach (PathVisualizer viz in remainingVisualizers) {
            if (viz != null) Destroy(viz.gameObject);
        }

        // Find and destroy any remaining llama objects
        GameObject[] remainingLlamas = GameObject.FindGameObjectsWithTag("Llama");
        foreach (GameObject llama in remainingLlamas) {
            if (llama != null) Destroy(llama);
        }

        // Stop audio
        AudioManager.StopVehicleSound();

        Debug.Log("Reset complete - all llamas, markers, and paths removed");
    }
    
    private void ClearAllBlockers() {
        pathfindingManager.blockedRoads.Clear();
        
        foreach (GameObject marker in blockMarkers) {
            if (marker != null) Destroy(marker);
        }
        
        blockMarkers.Clear();
    }
    
    void OnGUI() {
        GUI.Box(new Rect(10, 10, 400, 440), "-- Multi-Llama Delivery Controls --");
        
        int y = 35;
        GUI.Label(new Rect(20, y, 380, 20), $"MODE: {currentMode}"); y += 25;
        
        GUI.Label(new Rect(20, y, 380, 20), $"1 - Set Llama Start ({llamas.Count}/{maxLlamas})"); y += 20;
        GUI.Label(new Rect(20, y, 380, 20), $"2 - Set Pickup ({pickupPoints.Count})"); y += 20;
        GUI.Label(new Rect(20, y, 380, 20), $"3 - Set Delivery ({deliveryPoints.Count}/{maxDeliveryPoints})"); y += 20;
        GUI.Label(new Rect(20, y, 380, 20), "4 - Toggle Block Road"); y += 20;
        GUI.Label(new Rect(20, y, 380, 20), "SPACE - Start Delivery"); y += 20;
        GUI.Label(new Rect(20, y, 380, 20), "R - Reset All"); y += 20;
        GUI.Label(new Rect(20, y, 380, 20), "C - Clear Blockers"); y += 30;
        
        GUI.Label(new Rect(20, y, 380, 20), $"Return to Start: {returnToStart}"); y += 25;
        
        GUI.Label(new Rect(20, y, 380, 20), "=== LLAMAS ==="); y += 20;
        for (int i = 0; i < llamas.Count; i++) {
            GUI.Label(new Rect(20, y, 380, 20), $"Llama {i}: {llamas[i].startGridPos}"); y += 20;
        }
        
        y += 5;
        GUI.Label(new Rect(20, y, 380, 20), "=== PICKUPS ==="); y += 20;
        for (int i = 0; i < Mathf.Min(pickupPoints.Count, 3); i++) {
            GUI.Label(new Rect(20, y, 380, 20), $"Pickup {i}: {pickupPoints[i].gridPos}"); y += 20;
        }
        if (pickupPoints.Count > 3) {
            GUI.Label(new Rect(20, y, 380, 20), $"... and {pickupPoints.Count - 3} more"); y += 20;
        }
        
        y += 5;
        GUI.Label(new Rect(20, y, 380, 20), "=== DELIVERIES ==="); y += 20;
        for (int i = 0; i < deliveryPoints.Count; i++) {
            GUI.Label(new Rect(20, y, 380, 20), $"Delivery {i}: {deliveryPoints[i].gridPos} (Llama {deliveryPoints[i].assignedLlamaIndex})"); y += 20;
        }
    }
}
