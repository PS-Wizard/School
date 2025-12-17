using UnityEngine;
using System.Collections;

public class CollisionDetector : MonoBehaviour {
    [Header("Detection Settings")]
    public float forwardDetectionDistance = 25f;

    [Header("Jump Settings")]
    public float jumpHeight = 20f;
    public float jumpForwardDistance = 20f;
    public float jumpDuration = 1f;
    public float jumpCooldown = 2f;

    [Header("Pause Settings")]
    public float pauseDuration = 2f;

    private bool isJumping = false;
    private bool isPaused = false;
    private float lastJumpTime = -999f;
    private float lastCollisionCheckTime = 0f;
    private float collisionCheckCooldown = 0.5f; // Don't check collisions too frequently
    private DeliveryVehicle vehicle;
    private Vector3 originalPosition;
    private bool nearStart = false;

    void Start() {
        vehicle = GetComponent<DeliveryVehicle>();
        originalPosition = transform.position;
    }

    void Update() {
        if (vehicle == null || !vehicle.IsMoving() || isJumping || isPaused) return;

        // Check if near start position
        nearStart = Vector3.Distance(new Vector3(transform.position.x, 0, transform.position.z), 
                new Vector3(originalPosition.x, 0, originalPosition.z)) < 10f;

        if (Time.time - lastJumpTime < jumpCooldown) return;

        // Don't check collisions too frequently
        if (Time.time - lastCollisionCheckTime < collisionCheckCooldown) return;

        if (CheckForward(out GameObject forwardLlama)) {
            lastCollisionCheckTime = Time.time;
            HandleCollision(forwardLlama);
        }
    }

    private bool CheckForward(out GameObject forwardLlama) {
        forwardLlama = null;

        RaycastHit[] hits = Physics.RaycastAll(transform.position, transform.forward, forwardDetectionDistance);

        GameObject closestLlama = null;
        float closestDistance = float.MaxValue;

        foreach (RaycastHit hit in hits) {
            if (hit.collider.gameObject != gameObject && hit.collider.CompareTag("Llama")) {
                float distance = hit.distance;
                if (distance < closestDistance) {
                    closestDistance = distance;
                    closestLlama = hit.collider.gameObject;
                }
            }
        }

        if (closestLlama != null) {
            forwardLlama = closestLlama;
            return true;
        }

        return false;
    }

    private void HandleCollision(GameObject otherLlama) {
        if (otherLlama == null) return;

        CollisionDetector otherDetector = otherLlama.GetComponent<CollisionDetector>();
        DeliveryVehicle otherVehicle = otherLlama.GetComponent<DeliveryVehicle>();

        if (otherDetector != null && (otherDetector.isJumping || otherDetector.isPaused)) {
            return;
        }

        bool otherIsComplete = otherVehicle != null && otherVehicle.HasCompletedDelivery();
        bool iAmComplete = vehicle != null && vehicle.HasCompletedDelivery();

        // If other llama is done, I always jump
        if (otherIsComplete && !iAmComplete) {
            StartCoroutine(PerformSuperJump());
            if (otherDetector != null) {
                otherDetector.StartCoroutine(otherDetector.Pause());
            }
            return;
        }

        // If I'm done, other llama always jumps
        if (iAmComplete && !otherIsComplete) {
            StartCoroutine(Pause());
            if (otherDetector != null) {
                otherDetector.StartCoroutine(otherDetector.PerformSuperJump());
            }
            return;
        }

        // Decide who jumps based on instance ID
        bool shouldJump = GetInstanceID() > otherLlama.GetInstanceID();

        // Special case: if near start, don't jump
        if (nearStart) {
            shouldJump = false;
        }

        if (shouldJump) {
            // I jump, other pauses
            StartCoroutine(PerformSuperJump());
            if (otherDetector != null) {
                otherDetector.StartCoroutine(otherDetector.Pause());
            }
        } else {
            // I pause, other jumps
            StartCoroutine(Pause());
            if (otherDetector != null) {
                otherDetector.StartCoroutine(otherDetector.PerformSuperJump());
            }
        }
    }

    public IEnumerator Pause() {
        if (isPaused) yield break;

        isPaused = true;
        vehicle.SetPaused(true);

        yield return new WaitForSeconds(pauseDuration);

        isPaused = false;
        vehicle.SetPaused(false);
    }

    public IEnumerator PerformSuperJump() {
        if (isJumping) yield break;

        isJumping = true;
        lastJumpTime = Time.time;

        Vector3 startPos = transform.position;
        Vector3 forwardTarget = startPos + transform.forward * jumpForwardDistance;

        // Reduce jump distance if near start
        if (nearStart) {
            float distanceFromStart = Vector3.Distance(new Vector3(forwardTarget.x, 0, forwardTarget.z), 
                    new Vector3(originalPosition.x, 0, originalPosition.z));
            if (distanceFromStart > 15f) {
                forwardTarget = startPos + transform.forward * (jumpForwardDistance * 0.5f);
            }
        }

        float elapsed = 0f;

        while (elapsed < jumpDuration) {
            elapsed += Time.deltaTime;
            float t = elapsed / jumpDuration;

            float heightCurve = Mathf.Sin(t * Mathf.PI);

            Vector3 newPos = Vector3.Lerp(startPos, forwardTarget, t);
            newPos.y = vehicle.heightAboveGround + (jumpHeight * heightCurve);

            transform.position = newPos;

            yield return null;
        }

        Vector3 finalPos = transform.position;
        finalPos.y = vehicle.heightAboveGround;
        transform.position = finalPos;

        isJumping = false;
    }

    void OnDrawGizmosSelected() {
        if (!Application.isPlaying) return;

        Gizmos.color = Color.yellow;
        Gizmos.DrawRay(transform.position, transform.forward * forwardDetectionDistance);
    }

    public bool IsJumping() {
        return isJumping;
    }

    public bool IsPaused() {
        return isPaused;
    }
}
