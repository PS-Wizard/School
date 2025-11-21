using UnityEngine;

// Make llama hop cause the animator for some reason dont work
//
public class LlamaHop : MonoBehaviour {
    public float hopHeight = 0.69f;
    public float hopDuration = 0.5f;
    public float pauseDuration = 0.1f;
    private float hopTimer = 0f;
    private Vector3 startPos;

    void Start() {
        startPos = transform.localPosition;
    }

    void Update() {
        hopTimer += Time.deltaTime;
        
        float cycleLength = hopDuration + pauseDuration;
        float loopedTimer = hopTimer % cycleLength;
        
        if (loopedTimer < hopDuration) {
            // Hopping
            float progress = loopedTimer / hopDuration;
            float hop = Mathf.Sin(progress * Mathf.PI) * hopHeight;
            transform.localPosition = startPos + Vector3.up * hop;
        } else {
            // Paused on ground
            transform.localPosition = startPos;
        }
    }
}
