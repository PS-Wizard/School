using UnityEngine;

// Manages all game audio including ambient music and vehicle sounds.
// Stops vehicle sound only when all llamas complete deliveries.
public class AudioManager : MonoBehaviour {
    [Header("Audio Clips")]
    public AudioClip ambientMusicClip;
    public AudioClip vehicleSoundClip;
    
    [Header("Volume Settings")]
    [Range(0f, 1f)]
    public float ambientVolume = 0.5f;
    [Range(0f, 1f)]
    public float vehicleVolume = 0.7f;
    
    private AudioSource ambientSource;
    private AudioSource vehicleSource;
    private static AudioManager instance;
    
    void Awake()
    {
        if (instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
            SetupAudioSources();
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    void Start()
    {
        if (ambientMusicClip != null)
            PlayAmbient();
    }
    
    private void SetupAudioSources()
    {
        GameObject ambientObj = new GameObject("AmbientAudioSource");
        ambientObj.transform.SetParent(transform);
        ambientSource = ambientObj.AddComponent<AudioSource>();
        ambientSource.loop = true;
        ambientSource.playOnAwake = false;
        ambientSource.volume = ambientVolume;
        ambientSource.clip = ambientMusicClip;
        
        GameObject vehicleObj = new GameObject("VehicleAudioSource");
        vehicleObj.transform.SetParent(transform);
        vehicleSource = vehicleObj.AddComponent<AudioSource>();
        vehicleSource.loop = true;
        vehicleSource.playOnAwake = false;
        vehicleSource.volume = vehicleVolume;
        vehicleSource.clip = vehicleSoundClip;
    }
    
    public void PlayAmbient() {
        if (ambientSource != null && ambientMusicClip != null && !ambientSource.isPlaying)
            ambientSource.Play();
    }
    
    public void StopAmbient() {
        if (ambientSource != null && ambientSource.isPlaying)
            ambientSource.Stop();
    }
    
    public void PlayVehicle() {
        if (vehicleSource != null && vehicleSoundClip != null && !vehicleSource.isPlaying)
            vehicleSource.Play();
    }
    
    public void StopVehicle() {
        if (vehicleSource != null && vehicleSource.isPlaying){
            if (CheckAllLlamasComplete())
            {
                vehicleSource.Stop();
                Debug.Log("All llamas complete - stopping vehicle sound");
            }
        }
    }

    private bool CheckAllLlamasComplete() {
        DeliveryVehicle[] allVehicles = FindObjectsOfType<DeliveryVehicle>();
        
        if (allVehicles.Length == 0)
            return true;
        
        foreach (DeliveryVehicle vehicle in allVehicles)
        {
            if (vehicle.IsMoving())
            {
                return false;
            }
        }
        
        return true;
    }
    
    public void SetAmbientVolume(float volume) {
        ambientVolume = Mathf.Clamp01(volume);
        if (ambientSource != null)
            ambientSource.volume = ambientVolume;
    }
    
    public void SetVehicleVolume(float volume) {
        vehicleVolume = Mathf.Clamp01(volume);
        if (vehicleSource != null)
            vehicleSource.volume = vehicleVolume;
    }
    
    // Static access
    public static void PlayAmbientMusic() => instance?.PlayAmbient();
    public static void StopAmbientMusic() => instance?.StopAmbient();
    public static void PlayVehicleSound() => instance?.PlayVehicle();
    public static void StopVehicleSound() => instance?.StopVehicle();
    public static AudioManager Instance => instance;
}
