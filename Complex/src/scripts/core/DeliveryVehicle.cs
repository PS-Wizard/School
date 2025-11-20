using UnityEngine;
using System.Collections.Generic;

// Main driver for the vehicle 
// make that whatever it attaches to has rigidbody 
[RequireComponent(typeof(Rigidbody))]
public class DeliveryVehicle : MonoBehaviour {
    [Header("References")]
    public PathfindingManager pathfindingManager;
    public Transform carryPoint;
    
    [Header("Movement Settings")]
    public float moveSpeed = 30f;
    public float rotationSpeed = 690f;
    
    public float waypointReachDistance = 2f;
    
    public float heightAboveGround = 2f;
    
    public float carryingSpeedPenalty = 10f;
    
    [SerializeField] private bool isMoving = false;
    [SerializeField] private bool isCarrying = false;

    // the index of the current target waypoint currently being chased in the `path` list
    [SerializeField] private int currentWaypointIndex = 0;
    

    private List<Vector2Int> path;

    // current waypoint converted into world's position, cause of the gridPosition script `GridTile.cs`
    private Vector3 currentTargetWorld;
    private Transform carriedPackage;

    // index in `path` where the vehicle executes the pickup /dropoff action
    private int pickupWaypointIndex = -1;
    private int dropoffWaypointIndex = -1;
    
    // runs everyframe, check if the vehicle is in motion, if so call the main movement logic
    void Update() {
        if (isMoving && path != null && path.Count > 0) {
            FollowPath();
        }
    }
    
    /// <summary>
    /// Configures pickup and dropoff waypoints for the current path.
    /// </summary>
    public void SetDeliveryInfo(GameObject packageObject, int pickupIndex, int dropoffIndex)
    {
        carriedPackage = packageObject != null ? packageObject.transform : null;
        pickupWaypointIndex = pickupIndex;
        dropoffWaypointIndex = dropoffIndex;
        isCarrying = false;
        
        if (carriedPackage != null && carryPoint != null)
        {
            // Initially hide the package at pickup location
            carriedPackage.SetParent(null);
        }
    }
    
    /// <summary>
    /// Starts following a new path.
    /// </summary>
    public void StartFollowingPath(List<Vector2Int> newPath)
    {
        if (newPath == null || newPath.Count == 0)
        {
            Debug.LogWarning("[DeliveryVehicle] Cannot follow empty path!");
            return;
        }
        
        path = newPath;
        currentWaypointIndex = 0;
        currentTargetWorld = pathfindingManager.GridToWorld(path[currentWaypointIndex]);
        isMoving = true;
        
        // Start vehicle sound
        AudioManager.PlayVehicleSound();
        
        Debug.Log($"[DeliveryVehicle] Started delivery route with {path.Count} waypoints");
    }
    
    /// <summary>
    /// Stops following the current path.
    /// </summary>
    public void StopFollowing()
    {
        isMoving = false;
        isCarrying = false;
        
        AudioManager.StopVehicleSound();
        
        Debug.Log("[DeliveryVehicle] Stopped");
    }
    
    /// Main path-following logic called every frame.
    private void FollowPath() {

        // Check if reached end of path
        if (currentWaypointIndex >= path.Count) {
            isMoving = false;
            AudioManager.StopVehicleSound();
            Debug.Log("Delivery complete!");
            return;
        }
        
        // Get current waypoint world position
        currentTargetWorld = pathfindingManager.GridToWorld(path[currentWaypointIndex]);
        
        // Calculate direction to target (ignore Y axis)
        Vector3 directionToTarget = (currentTargetWorld - transform.position).normalized;
        directionToTarget.y = 0;
        
        // Rotate towards target
        if (directionToTarget != Vector3.zero) {
            Quaternion targetRotation = Quaternion.LookRotation(directionToTarget);
            transform.rotation = Quaternion.RotateTowards(
                transform.rotation,
                targetRotation,
                rotationSpeed * Time.deltaTime
            );
        }
        
        // Calculate effective speed 
        float effectiveSpeed = isCarrying ? moveSpeed - carryingSpeedPenalty : moveSpeed;
        
        // Move the vehicle forward and maintain fixed height
        Vector3 newPos = transform.position + transform.forward * effectiveSpeed * Time.deltaTime;
        newPos.y = heightAboveGround;
        transform.position = newPos;
        
        // Check if reached current waypoint
        float distanceToWaypoint = Vector3.Distance(
            new Vector3(transform.position.x, currentTargetWorld.y, transform.position.z),
            currentTargetWorld
        );
        
        if (distanceToWaypoint < waypointReachDistance) {

            // Handle pickup
            if (currentWaypointIndex == pickupWaypointIndex && !isCarrying) {
                PickupPackage();
            }
            
            // Handle dropoff
            if (currentWaypointIndex == dropoffWaypointIndex && isCarrying) {
                DropoffPackage();
            }
            
            // Move to next waypoint
            currentWaypointIndex++;
        }
    }
    
    // Picks up the package and attaches it to the carry point.
    private void PickupPackage() {
        if (carriedPackage == null || carryPoint == null) return;
        
        isCarrying = true;
        
        // Attach package to carry point
        carriedPackage.SetParent(carryPoint);
        carriedPackage.localPosition = Vector3.zero;
        carriedPackage.localRotation = Quaternion.identity;
        
        Debug.Log("Package picked up!");
    }
    
    // Drops off the package at the current location.
    private void DropoffPackage() {
        if (!isCarrying || carriedPackage == null) return;
        
        isCarrying = false;
        
        // Detach and place package
        carriedPackage.SetParent(null);
        carriedPackage.position = transform.position + Vector3.up * 2f;
        
        Debug.Log("Package delivered!");
    }
}
