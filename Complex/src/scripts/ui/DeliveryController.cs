using UnityEngine;
using System.Collections.Generic;

// Main controller for the delivery system. Handles user input for setting
// start/pickup/end points, blocking roads, and calculating delivery routes.
public class DeliveryController : MonoBehaviour {
    [Header("Core References")]
    // take a reference to the system that runs a* pathfinding algorithm
    public PathfindingManager pathfindingManager;

    public DeliveryVehicle deliveryVehicle;
    public PathVisualizer pathVisualizer;
    public Camera mainCamera;
    
    [Header("Marker Prefabs (Optional)")]
    public GameObject startMarkerPrefab;
    public GameObject pickupMarkerPrefab;
    public GameObject endMarkerPrefab;
    public GameObject blockerPrefab;
    
    [Header("Settings")]
    public float raycastDistance = 1000f;
    public LayerMask roadLayer = -1;
    public float markerHeightOffset = 1f;
    public bool returnToStart = true;
    
    // Current mode
    public enum ClickMode {
        SetStart,
        SetPickup,
        SetEnd,
        ToggleBlock
    }

    public ClickMode currentMode = ClickMode.SetStart;
    
    // Marker instances
    private GameObject startMarker;
    private GameObject pickupMarker;
    private GameObject endMarker;
    private List<GameObject> blockMarkers = new List<GameObject>();
    
    // Nullable grid positions 
    private Vector2Int? startGridPos = null;
    private Vector2Int? pickupGridPos = null;
    private Vector2Int? endGridPos = null;
    
    void Start() {}
    
    // check for user input
    void Update() {
        HandleModeSwitch();
        HandleMouseInput();
        HandleKeyboardShortcuts();
    }
    
    // Handle mode switching with number keys.
    private void HandleModeSwitch() {
        // if presses 1
        if (Input.GetKeyDown(KeyCode.Alpha1)){
            currentMode = ClickMode.SetStart;
            Debug.Log("Mode: SET START");
        }
        // if presses 2
        else if (Input.GetKeyDown(KeyCode.Alpha2)) {
            currentMode = ClickMode.SetPickup;
            Debug.Log("Mode: SET PICKUP");
        }
        // if presses 3
        else if (Input.GetKeyDown(KeyCode.Alpha3)) {
            currentMode = ClickMode.SetEnd;
            Debug.Log("Mode: SET END");
        }
        // if presses 4
        else if (Input.GetKeyDown(KeyCode.Alpha4)) {
            currentMode = ClickMode.ToggleBlock;
            Debug.Log("Mode: TOGGLE BLOCK");
        }
    }
    
    // Process the left mouse click
    private void HandleMouseInput() {
        // Left click
        if (Input.GetMouseButtonDown(0)) {

            // cast a ray
            Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);
            
            // check if the casted ray hits an object in the roadLayer
            if (Physics.Raycast(ray, out RaycastHit hit, raycastDistance, roadLayer)) {

                // if a hit does occur, get the `GridTile` component from the object hit, which holds the `gridPos` ; basically just `GridTile.cs`
                GridTile tile = hit.collider.GetComponent<GridTile>();
                // safety check just to make sure that the tile does have a `GridTile` component
                if (tile != null) {
                    // get it's gridPos
                    Vector2Int gridPos = tile.gridPosition;

                    // get it's world Position using the transform on it's box collider
                    Vector3 worldPos = hit.collider.transform.position;
                    switch (currentMode) {
                        case ClickMode.SetStart:
                            SetStart(gridPos, worldPos);
                            break;
                        case ClickMode.SetPickup:
                            SetPickup(gridPos, worldPos);
                            break;
                        case ClickMode.SetEnd:
                            SetEnd(gridPos, worldPos);
                            break;
                        case ClickMode.ToggleBlock:
                            ToggleBlock(gridPos, worldPos);
                            break;
                    }
                }
            }
        }
    }
    
    // Handle keyboard shortcuts, checks for Space, R and C key
    private void HandleKeyboardShortcuts() {
        // Check if space, if so start the process
        if (Input.GetKeyDown(KeyCode.Space)) {
            CalculateAndStartDelivery();
        }
        
        // If instead its R, reset everything
        if (Input.GetKeyDown(KeyCode.R)) {
            ResetAll();
        }

        // if instead it's c just clear out them blockers
        if (Input.GetKeyDown(KeyCode.C)) {
            ClearAllBlockers();
        }
    }
    
    // Sets the start position and moves the vehicle there.
    private void SetStart(Vector2Int gridPos, Vector3 worldPos) {
        startGridPos = gridPos;
        
        // Create/update start marker
        if (startMarker != null) Destroy(startMarker);

        startMarker = CreateMarker(startMarkerPrefab, worldPos, Color.green, "StartMarker");
        
        // move the vehicle to wherever the start was placed, 
        if (deliveryVehicle != null) {
            Vector3 vehiclePos = worldPos + new Vector3(0, deliveryVehicle.heightAboveGround, 0);
            deliveryVehicle.transform.position = vehiclePos;
            // Quaternion.identity just resets the rotation of the vehicle to it's defaul
            deliveryVehicle.transform.rotation = Quaternion.identity;
        }
        
        Debug.Log($"Start set at {gridPos}");
    }
    
    // Sets the pickup position (where the package is).
    private void SetPickup(Vector2Int gridPos, Vector3 worldPos) {
        pickupGridPos = gridPos;
        
        if (pickupMarker != null) Destroy(pickupMarker);
        pickupMarker = CreateMarker(pickupMarkerPrefab, worldPos, Color.yellow, "PickupMarker");
        
        Debug.Log($"Pickup set at {gridPos}");
    }
    
    // Sets the end/delivery position.
    private void SetEnd(Vector2Int gridPos, Vector3 worldPos) {
        endGridPos = gridPos;
        
        if (endMarker != null) Destroy(endMarker);
        endMarker = CreateMarker(endMarkerPrefab, worldPos, Color.red, "EndMarker");
        
        Debug.Log($"End set at {gridPos}");
    }
    
    // Toggles a road blocker at the clicked position.
    private void ToggleBlock(Vector2Int gridPos, Vector3 worldPos) {
        if (pathfindingManager.blockedRoads.Contains(gridPos)) {
            // Unblock
            pathfindingManager.UnblockRoad(gridPos);
            
            // Remove marker by checking if the position of the marker, `m.transform.position` is very close `<1` to the target world position `worldPos` + an height offset as the marker is placed above ground
            GameObject markerToRemove = blockMarkers.Find(m => Vector3.Distance(m.transform.position, worldPos + Vector3.up * markerHeightOffset) < 1f);
            
            if (markerToRemove != null) {
                blockMarkers.Remove(markerToRemove);
                Destroy(markerToRemove);
            }
        }
        else {
            // Block
            pathfindingManager.BlockRoad(gridPos);
            GameObject marker = CreateMarker(blockerPrefab, worldPos, Color.yellow, $"Blocker_{gridPos.x}_{gridPos.y}", true);
            blockMarkers.Add(marker);
        }
    }
    
    // Helper to create marker objects.
    private GameObject CreateMarker(GameObject prefab, Vector3 worldPos, Color defaultColor, string name, bool useCube = false) {
        GameObject marker;
        
        // if prefab has been assigned, use it
        if (prefab != null) {
            marker = Instantiate(prefab, worldPos + Vector3.up * markerHeightOffset, Quaternion.identity);
        } else {
            // if no prefab, Create default primitive
            marker = GameObject.CreatePrimitive(useCube ? PrimitiveType.Cube : PrimitiveType.Sphere);
            marker.transform.position = worldPos + Vector3.up * markerHeightOffset;
            marker.transform.localScale = Vector3.one * (useCube ? 2f : 3f);
            marker.GetComponent<Renderer>().material.color = defaultColor;
            Destroy(marker.GetComponent<Collider>());
        }
        
        marker.name = name;
        return marker;
    }
    
    // Calculates the full delivery route and starts the vehicle.
    private void CalculateAndStartDelivery() {

        // check start /  end and vehicle reference
        if (!startGridPos.HasValue || !endGridPos.HasValue) {
            Debug.LogError("Please set both start and end points!");
            return;
        }
        
        if (deliveryVehicle == null){
            Debug.LogError("Please assign a delivery vehicle");
            return;
        }
        
        // final concatenated sequence of grid coordinates that the vehicle must follow
        List<Vector2Int> fullPath = new List<Vector2Int>();


        // these store index within fullPath where the vehicle needs to perform pickup / dropoff action
        int pickupWaypointIndex = -1;
        int dropoffWaypointIndex = -1;
        
        
        if (pickupGridPos.HasValue) {
            // Route: Start -> Pickup -> End -> (optionally) Start
            List<Vector2Int> pathToPickup = pathfindingManager.CalculatePath(startGridPos.Value, pickupGridPos.Value);
            List<Vector2Int> pathToEnd = pathfindingManager.CalculatePath(pickupGridPos.Value, endGridPos.Value);
            
            // path avaibalility checks
            if (pathToPickup == null || pathToEnd == null) {
                Debug.LogError("Could not find path through pickup point!");
                return;
            }
            

            fullPath.AddRange(pathToPickup);
            // The pickup index is set as the last element of the `pathToPickup` as pathToPickup is just a path from starting to the pickup point
            pickupWaypointIndex = pathToPickup.Count - 1;
            
            // add the second path, but it skips the first element (notice i = 1), this is because the firstElement of pathToEnd is the pickuppoint, which we have already added
            for (int i = 1; i < pathToEnd.Count; i++) fullPath.Add(pathToEnd[i]);
            
            // set the dropoff point to the last element of the now full path 
            dropoffWaypointIndex = fullPath.Count - 1;
            
            // optional, if it is set just use a* to calculate the most optimal path from end to start pos
            if (returnToStart) {
                List<Vector2Int> pathBackToStart = pathfindingManager.CalculatePath(endGridPos.Value, startGridPos.Value);
                // if a pathBackToStart was found, which i mean i think it will always do, but still
                // if the path was found it's a path from end->start, so i=1 skips the end as we are already at end
                if (pathBackToStart != null) { for (int i = 1; i < pathBackToStart.Count; i++) fullPath.Add(pathBackToStart[i]); }
            }
            
            Debug.Log($" Route: Start -> Pickup({pickupWaypointIndex}) -> End({dropoffWaypointIndex}) -> Start. Total: {fullPath.Count} waypoints");
        }
        else
        {
            // Route: Start → End → (optionally) Start
            List<Vector2Int> pathToEnd = pathfindingManager.CalculatePath(startGridPos.Value, endGridPos.Value);
            
            if (pathToEnd == null) {
                Debug.LogError("Could not find path to end!");
                return;
            }
            
            fullPath.AddRange(pathToEnd);
            
            if (returnToStart)
            {
                List<Vector2Int> pathBackToStart = pathfindingManager.CalculatePath(endGridPos.Value, startGridPos.Value);
                if (pathBackToStart != null)
                {
                    for (int i = 1; i < pathBackToStart.Count; i++) fullPath.Add(pathBackToStart[i]);
                }
            }
            
            Debug.Log($"Route: Start -> End->Start. Total: {fullPath.Count} waypoints");
        }
        
        // Update visualizer and start vehicle
        pathfindingManager.SetCurrentPath(fullPath);
        pathVisualizer?.OnPathCalculated();
        
        deliveryVehicle.SetDeliveryInfo(pickupMarker, pickupWaypointIndex, dropoffWaypointIndex);
        deliveryVehicle.StartFollowingPath(fullPath);
        
        AudioManager.PlayVehicleSound();
    }
    
    // Resets everything to initial state.
    private void ResetAll() {
        startGridPos = null;
        pickupGridPos = null;
        endGridPos = null;
        
        if (startMarker != null) { Destroy(startMarker); startMarker = null; }
        if (pickupMarker != null) { Destroy(pickupMarker); pickupMarker = null; }
        if (endMarker != null) { Destroy(endMarker); endMarker = null; }
        
        ClearAllBlockers();
        
        deliveryVehicle?.StopFollowing();
        pathVisualizer?.ClearPath();
        
        AudioManager.StopVehicleSound();
        
        Debug.Log("Reset complete");
    }
    
    // Clears all road blockers.
    private void ClearAllBlockers() {
        pathfindingManager.blockedRoads.Clear();
        
        foreach (GameObject marker in blockMarkers)
            Destroy(marker);
        
        blockMarkers.Clear();
    }
    
    // On-screen UI displaying controls and status.
    void OnGUI() {
        GUI.Box(new Rect(10, 10, 360, 360), "--Controls--");
        
        int y = 35;
        GUI.Label(new Rect(20, y, 340, 20), $"MODE: {currentMode}"); y += 25;
        
        GUI.Label(new Rect(20, y, 340, 20), "1 - Set Start"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), "2 - Set Pickup (Optional)"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), "3 - Set End"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), "4 - Toggle Block Road"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), "SPACE - Start Delivery"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), "R - Reset All"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), "C - Clear Blockers"); y += 30;
        
        GUI.Label(new Rect(20, y, 340, 20), $"Return to Start: {returnToStart}"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), $"Start: {(startGridPos.HasValue ? startGridPos.Value.ToString() : "Not Set")}"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), $"Pickup: {(pickupGridPos.HasValue ? pickupGridPos.Value.ToString() : "Not Set")}"); y += 20;
        GUI.Label(new Rect(20, y, 340, 20), $"End: {(endGridPos.HasValue ? endGridPos.Value.ToString() : "Not Set")}");
    }
}
