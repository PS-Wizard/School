using UnityEngine;

public class CameraController : MonoBehaviour {
    [Header("Movement Settings")]
    public float moveSpeed = 20f;
    public float fastMoveMultiplier = 3f;
    public float rotationSpeed = 100f;
    
    [Header("Mouse Look (Optional)")]
    public bool useMouseLook = true;
    public float mouseSensitivity = 2f;
    
    private float pitch = 0f;
    private float yaw = 0f;
    
    void Start() {
        // this apparantly fixes the weird stretched view after building the game
        Screen.SetResolution ((int)Screen.width, (int)Screen.height, true);
        // Initialize rotation
        Vector3 rot = transform.eulerAngles;
        pitch = rot.x;
        yaw = rot.y;
    }
    
    void Update()
    {
        HandleMovement();
        HandleRotation();
    }
    
    void HandleMovement()
    {
        // Get input
        float horizontal = Input.GetAxis("Horizontal"); // A/D
        float vertical = Input.GetAxis("Vertical");     // W/S
        float upDown = 0f;
        
        // Q/E for up/down
        if (Input.GetKey(KeyCode.E))
            upDown = 1f;
        if (Input.GetKey(KeyCode.Q))
            upDown = -1f;
        
        // Calculate move direction (relative to camera)
        Vector3 move = transform.right * horizontal + transform.forward * vertical + Vector3.up * upDown;

        // Apply speed
        float currentSpeed = moveSpeed;

        // shift for bonus speed
        if (Input.GetKey(KeyCode.LeftShift)) currentSpeed *= fastMoveMultiplier;
        
        // Move
        transform.position += move * currentSpeed * Time.deltaTime;
    }
    
    void HandleRotation() {
        // Mouse look (right mouse button)
        if (useMouseLook && Input.GetMouseButton(1)) {
            float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity;
            float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;
            
            yaw += mouseX;
            pitch -= mouseY;
            pitch = Mathf.Clamp(pitch, -89f, 89f);
            
            transform.eulerAngles = new Vector3(pitch, yaw, 0f);
        }
    }
}
