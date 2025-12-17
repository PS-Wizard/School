using UnityEngine;
using System.Collections.Generic;

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
    public float carryingSpeedPenalty = 5f;
    
    [Header("Multi-Package Settings")]
    public float packageStackOffset = 1f;
    
    [SerializeField] private bool isMoving = false;
    [SerializeField] private bool isPaused = false;
    [SerializeField] private int currentWaypointIndex = 0;

    private List<Vector2Int> path;
    private Vector3 currentTargetWorld;
    
    private List<Transform> packagesToPick = new List<Transform>();
    private List<Transform> carriedPackages = new List<Transform>();
    private int pickupWaypointIndex = -1;
    private int dropoffWaypointIndex = -1;
    
    private float deliveryStartTime = 0f;
    private float totalDeliveryTime = 0f;
    private bool hasStartedDelivery = false;
    private bool hasCompletedDelivery = false;
    
    void Update() {
        if (isMoving && !isPaused && path != null && path.Count > 0) {
            FollowPath();
        }
    }
    
    public void SetDeliveryInfo(GameObject packageObject, int pickupIndex, int dropoffIndex) {
        if (packageObject != null) {
            Transform packageTransform = packageObject.transform;
            if (!packagesToPick.Contains(packageTransform)) {
                packagesToPick.Add(packageTransform);
            }
        }
        
        pickupWaypointIndex = pickupIndex;
        dropoffWaypointIndex = dropoffIndex;
    }
    
    public void StartFollowingPath(List<Vector2Int> newPath) {
        if (newPath == null || newPath.Count == 0) {
            Debug.LogWarning("[DeliveryVehicle] Cannot follow empty path!");
            return;
        }
        
        path = newPath;
        currentWaypointIndex = 0;
        currentTargetWorld = pathfindingManager.GridToWorld(path[currentWaypointIndex]);
        isMoving = true;
        
        if (!hasStartedDelivery) {
            deliveryStartTime = Time.time;
            hasStartedDelivery = true;
        }
        
        Debug.Log($"[DeliveryVehicle] Started delivery route with {path.Count} waypoints");
    }
    
    public void StopFollowing() {
        isMoving = false;
        carriedPackages.Clear();
        packagesToPick.Clear();
        
        Debug.Log("[DeliveryVehicle] Stopped");
    }
    
    private void FollowPath() {
        if (currentWaypointIndex >= path.Count) {
            isMoving = false;
            
            if (!hasCompletedDelivery) {
                totalDeliveryTime = Time.time - deliveryStartTime;
                hasCompletedDelivery = true;
                Debug.Log($"{gameObject.name} completed delivery in {totalDeliveryTime:F2} seconds!");
            }
            
            CheckAllDeliveriesComplete();
            Debug.Log("Delivery complete!");
            return;
        }
        
        currentTargetWorld = pathfindingManager.GridToWorld(path[currentWaypointIndex]);
        
        Vector3 directionToTarget = (currentTargetWorld - transform.position).normalized;
        directionToTarget.y = 0;
        
        if (directionToTarget != Vector3.zero) {
            Quaternion targetRotation = Quaternion.LookRotation(directionToTarget);
            transform.rotation = Quaternion.RotateTowards(
                transform.rotation,
                targetRotation,
                rotationSpeed * Time.deltaTime
            );
        }
        
        float speedPenalty = carriedPackages.Count * carryingSpeedPenalty;
        float effectiveSpeed = Mathf.Max(moveSpeed - speedPenalty, moveSpeed * 0.3f);
        
        Vector3 newPos = transform.position + transform.forward * effectiveSpeed * Time.deltaTime;
        newPos.y = heightAboveGround;
        transform.position = newPos;
        
        float distanceToWaypoint = Vector3.Distance(
            new Vector3(transform.position.x, currentTargetWorld.y, transform.position.z),
            currentTargetWorld
        );
        
        if (distanceToWaypoint < waypointReachDistance) {
            if (currentWaypointIndex == pickupWaypointIndex) {
                PickupPackage();
            }
            
            if (currentWaypointIndex == dropoffWaypointIndex) {
                DropoffPackages();
            }
            
            currentWaypointIndex++;
        }
    }
    
    private void PickupPackage() {
        if (packagesToPick.Count == 0 || carryPoint == null) return;
        
        for (int i = 0; i < packagesToPick.Count; i++) {
            Transform package = packagesToPick[i];
            if (package == null) continue;
            
            carriedPackages.Add(package);
            package.SetParent(carryPoint);
            package.localPosition = Vector3.up * (packageStackOffset * (carriedPackages.Count - 1));
            package.localRotation = Quaternion.identity;
        }
        
        Debug.Log($"Picked up {packagesToPick.Count} package(s)! Total carrying: {carriedPackages.Count}");
        packagesToPick.Clear();
    }
    
    private void DropoffPackages() {
        if (carriedPackages.Count == 0) return;
        
        for (int i = 0; i < carriedPackages.Count; i++) {
            Transform package = carriedPackages[i];
            if (package == null) continue;
            
            package.SetParent(null);
            package.position = transform.position + Vector3.up * (2f + i * packageStackOffset);
        }
        
        Debug.Log($"Delivered {carriedPackages.Count} package(s)!");
        carriedPackages.Clear();
    }
    
    private void CheckAllDeliveriesComplete() {
        DeliveryVehicle[] allVehicles = FindObjectsOfType<DeliveryVehicle>();
        bool allComplete = true;
        
        foreach (DeliveryVehicle vehicle in allVehicles) {
            if (vehicle.isMoving) {
                allComplete = false;
                break;
            }
        }
        
        if (allComplete) {
            AudioManager.StopVehicleSound();
            Debug.Log("All deliveries complete!");
        }
    }
    
    public bool IsMoving() {
        return isMoving;
    }
    
    public void SetPaused(bool paused) {
        isPaused = paused;
    }
    
    public bool IsPaused() {
        return isPaused;
    }
    
    public float GetCurrentSpeed() {
        if (!isMoving || isPaused) return 0f;
        
        float speedPenalty = carriedPackages.Count * carryingSpeedPenalty;
        return Mathf.Max(moveSpeed - speedPenalty, moveSpeed * 0.3f);
    }
    
    public int GetCarriedPackageCount() {
        return carriedPackages.Count;
    }
    
    public float GetElapsedTime() {
        if (!hasStartedDelivery) return 0f;
        if (hasCompletedDelivery) return totalDeliveryTime;
        return Time.time - deliveryStartTime;
    }
    
    public bool HasCompletedDelivery() {
        return hasCompletedDelivery;
    }
}
