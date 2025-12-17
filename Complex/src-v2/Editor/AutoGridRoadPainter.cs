using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class GridRoadPainter : EditorWindow
{
    // All the different prefabs
    private GameObject streetStraight;
    private GameObject streetCurve;
    private GameObject streetTWay;
    private GameObject streetFourWay;
    private GameObject streetDeadend;
    
    // Grid settings
    private float gridSize = 20f;
    private bool showGrid = true;
    private LayerMask terrainLayer = -1;
    
    private Dictionary<Vector2Int, GameObject> placedTiles = new Dictionary<Vector2Int, GameObject>();
    private GameObject parentObject;
    private bool isPainting = false;
    private Vector2Int lastPaintedCell = new Vector2Int(int.MaxValue, int.MaxValue);
    
    // set what it shows up as in the editor settings
    [MenuItem("Tools/Grid Road Painter")]
    public static void ShowWindow()
    {
        GetWindow<GridRoadPainter>("Road Painter");
    }
    
    private void OnEnable()
    {
        SceneView.duringSceneGui += OnSceneGUI;
        
        // Find or create parent object
        parentObject = GameObject.Find("RoadGrid");
        if (parentObject == null)
        {
            parentObject = new GameObject("RoadGrid");
        }
        
        // Rebuild tile dictionary from scene
        RebuildTileDictionary();
    }
    
    private void OnDisable()
    {
        SceneView.duringSceneGui -= OnSceneGUI;
    }
    
    private void OnGUI()
    {
        GUILayout.Label("Grid Settings", EditorStyles.boldLabel);
        gridSize = EditorGUILayout.FloatField("Grid Size", gridSize);
        showGrid = EditorGUILayout.Toggle("Show Grid", showGrid);
        terrainLayer = LayerMaskField("Terrain Layer", terrainLayer);
        
        EditorGUILayout.Space();
        GUILayout.Label("Road Prefabs", EditorStyles.boldLabel);
        
        streetStraight = (GameObject)EditorGUILayout.ObjectField("Street Straight", streetStraight, typeof(GameObject), false);
        streetCurve = (GameObject)EditorGUILayout.ObjectField("Street Curve", streetCurve, typeof(GameObject), false);
        streetTWay = (GameObject)EditorGUILayout.ObjectField("Street 3-Way", streetTWay, typeof(GameObject), false);
        streetFourWay = (GameObject)EditorGUILayout.ObjectField("Street 4-Way", streetFourWay, typeof(GameObject), false);
        streetDeadend = (GameObject)EditorGUILayout.ObjectField("Street Deadend", streetDeadend, typeof(GameObject), false);
        
        EditorGUILayout.Space();
        if (GUILayout.Button("Rebuild Tile Dictionary"))
        {
            RebuildTileDictionary();
        }
        
        if (GUILayout.Button("Clear All Roads"))
        {
            if (EditorUtility.DisplayDialog("Clear All Roads", 
                "Are you sure you want to delete all roads?", "Yes", "Cancel"))
            {
                ClearAllRoads();
            }
        }
        
        EditorGUILayout.Space();
        EditorGUILayout.HelpBox(
            "LEFT CLICK + DRAG: Paint roads\n" +
            "SHIFT + LEFT CLICK: Erase roads\n" +
            "RIGHT CLICK + DRAG: Scene navigation (normal)\n" +
            "System auto-picks corners, intersections, etc.\n" +
            "Works on terrain height automatically", 
            MessageType.Info);
        
        if (!ValidatePrefabs())
        {
            EditorGUILayout.HelpBox("Please assign all road prefabs!", MessageType.Warning);
        }
    }
    
    private LayerMask LayerMaskField(string label, LayerMask layerMask)
    {
        List<string> layers = new List<string>();
        for (int i = 0; i < 32; i++)
        {
            string layerName = LayerMask.LayerToName(i);
            if (!string.IsNullOrEmpty(layerName))
            {
                layers.Add(layerName);
            }
        }
        
        int mask = 0;
        for (int i = 0; i < layers.Count; i++)
        {
            int layerIndex = LayerMask.NameToLayer(layers[i]);
            if (((1 << layerIndex) & layerMask.value) != 0)
            {
                mask |= (1 << i);
            }
        }
        
        mask = EditorGUILayout.MaskField(label, mask, layers.ToArray());
        
        int finalMask = 0;
        for (int i = 0; i < layers.Count; i++)
        {
            if ((mask & (1 << i)) != 0)
            {
                int layerIndex = LayerMask.NameToLayer(layers[i]);
                finalMask |= (1 << layerIndex);
            }
        }
        
        return finalMask;
    }
    
    private bool ValidatePrefabs()
    {
        return streetStraight != null && streetCurve != null && 
               streetTWay != null && streetFourWay != null && streetDeadend != null;
    }
    
    private void RebuildTileDictionary()
    {
        placedTiles.Clear();
        GridTile[] allTiles = FindObjectsOfType<GridTile>();
        foreach (GridTile tile in allTiles)
        {
            placedTiles[tile.gridPosition] = tile.gameObject;
        }
        Debug.Log($"Rebuilt tile dictionary: {placedTiles.Count} tiles found");
    }
    
    private void OnSceneGUI(SceneView sceneView)
    {
        if (!ValidatePrefabs()) return;
        
        Event e = Event.current;
        
        // Get mouse position via raycast
        Ray ray = HandleUtility.GUIPointToWorldRay(e.mousePosition);
        Vector3 hitPoint;
        
        // Try to hit terrain or any collider
        if (Physics.Raycast(ray, out RaycastHit hit, 5000f, terrainLayer))
        {
            hitPoint = hit.point;
        }
        else
        {
            // Fallback to horizontal plane at y=0
            Plane plane = new Plane(Vector3.up, Vector3.zero);
            if (!plane.Raycast(ray, out float distance))
                return;
            hitPoint = ray.GetPoint(distance);
        }
        
        // Snap to grid
        Vector2Int gridPos = new Vector2Int(
            Mathf.RoundToInt(hitPoint.x / gridSize),
            Mathf.RoundToInt(hitPoint.z / gridSize)
        );
        
        Vector3 snappedPos = new Vector3(
            gridPos.x * gridSize,
            hitPoint.y,
            gridPos.y * gridSize
        );
        
        // Draw preview
        bool tileExists = placedTiles.ContainsKey(gridPos);
        Handles.color = tileExists ? new Color(1, 0, 0, 0.3f) : new Color(0, 1, 0, 0.3f);
        Handles.DrawWireCube(snappedPos, new Vector3(gridSize * 0.9f, 0.5f, gridSize * 0.9f));
        
        // Draw grid
        if (showGrid)
        {
            DrawGrid(snappedPos);
        }
        
        // Handle painting
        if (e.type == EventType.MouseDown && e.button == 0 && !e.shift && !e.alt)
        {
            isPainting = true;
            lastPaintedCell = new Vector2Int(int.MaxValue, int.MaxValue);
            e.Use();
        }
        
        if (e.type == EventType.MouseUp && e.button == 0)
        {
            isPainting = false;
        }
        
        if (e.type == EventType.MouseDrag || (isPainting && e.type == EventType.MouseMove))
        {
            if (e.button == 0 && gridPos != lastPaintedCell && !e.shift && !e.alt)
            {
                // Left click - paint
                PaintRoadCell(gridPos, snappedPos.y);
                lastPaintedCell = gridPos;
                e.Use();
            }
        }
        
        // Handle erasing with SHIFT + Left Click
        if (e.type == EventType.MouseDown && e.button == 0 && e.shift)
        {
            EraseRoadCell(gridPos);
            isPainting = true;
            lastPaintedCell = gridPos;
            e.Use();
        }
        
        if ((e.type == EventType.MouseDrag || e.type == EventType.MouseMove) && e.button == 0 && e.shift)
        {
            if (gridPos != lastPaintedCell)
            {
                EraseRoadCell(gridPos);
                lastPaintedCell = gridPos;
                e.Use();
            }
        }
        
        sceneView.Repaint();
    }
    
    private void DrawGrid(Vector3 center)
    {
        Handles.color = new Color(0.5f, 0.5f, 0.5f, 0.2f);
        int gridCount = 15;
        
        float y = center.y;
        
        for (int x = -gridCount; x <= gridCount; x++)
        {
            Vector3 start = new Vector3((center.x / gridSize + x) * gridSize, y, (center.z / gridSize - gridCount) * gridSize);
            Vector3 end = new Vector3((center.x / gridSize + x) * gridSize, y, (center.z / gridSize + gridCount) * gridSize);
            Handles.DrawLine(start, end);
        }
        
        for (int z = -gridCount; z <= gridCount; z++)
        {
            Vector3 start = new Vector3((center.x / gridSize - gridCount) * gridSize, y, (center.z / gridSize + z) * gridSize);
            Vector3 end = new Vector3((center.x / gridSize + gridCount) * gridSize, y, (center.z / gridSize + z) * gridSize);
            Handles.DrawLine(start, end);
        }
    }
    
    private void PaintRoadCell(Vector2Int gridPos, float height)
    {
        // Add to dictionary if not exists
        if (!placedTiles.ContainsKey(gridPos))
        {
            placedTiles[gridPos] = null; // Mark as occupied, will be filled by UpdateTile
        }
        
        // Update this tile and all neighbors
        UpdateTile(gridPos, height);
        UpdateTile(gridPos + Vector2Int.up, height);
        UpdateTile(gridPos + Vector2Int.down, height);
        UpdateTile(gridPos + Vector2Int.left, height);
        UpdateTile(gridPos + Vector2Int.right, height);
    }
    
    private void EraseRoadCell(Vector2Int gridPos)
    {
        if (placedTiles.ContainsKey(gridPos))
        {
            GameObject tile = placedTiles[gridPos];
            if (tile != null)
            {
                Undo.DestroyObjectImmediate(tile);
            }
            placedTiles.Remove(gridPos);
            
            // Update neighbors
            float height = 0f; // Will be determined by raycast in UpdateTile
            UpdateTile(gridPos + Vector2Int.up, height);
            UpdateTile(gridPos + Vector2Int.down, height);
            UpdateTile(gridPos + Vector2Int.left, height);
            UpdateTile(gridPos + Vector2Int.right, height);
        }
    }
    
    private void UpdateTile(Vector2Int gridPos, float height)
    {
        if (!placedTiles.ContainsKey(gridPos)) return;
        
        // Count neighbors (N, E, S, W)
        bool n = placedTiles.ContainsKey(gridPos + Vector2Int.up);
        bool e = placedTiles.ContainsKey(gridPos + Vector2Int.right);
        bool s = placedTiles.ContainsKey(gridPos + Vector2Int.down);
        bool w = placedTiles.ContainsKey(gridPos + Vector2Int.left);
        
        int connectionCount = (n ? 1 : 0) + (e ? 1 : 0) + (s ? 1 : 0) + (w ? 1 : 0);
        
        // Determine tile type and rotation
        GameObject prefab = null;
        int rotation = 0;
        
        if (connectionCount == 0)
        {
            prefab = streetDeadend;
            rotation = 0;
        }
        else if (connectionCount == 1)
        {
            // Dead-end points toward the connection
            // Your dead-end points West at 0°, so:
            prefab = streetDeadend;
            if (w) rotation = 0;      // Connection is West, point West
            else if (n) rotation = 90;  // Connection is North, rotate 90°
            else if (e) rotation = 180; // Connection is East, rotate 180°
            else if (s) rotation = 270; // Connection is South, rotate 270°
        }
        else if (connectionCount == 2)
        {
            // Check if straight or corner
            if ((n && s) || (e && w))
            {
                // Straight - your straight goes East-West at 0°
                prefab = streetStraight;
                rotation = (e && w) ? 0 : 90; // E-W = 0°, N-S = 90°
            }
            else
            {
                // Corner - your curve connects West+North at 0°
                prefab = streetCurve;
                if (w && n) rotation = 0;   // West+North
                else if (n && e) rotation = 90;  // North+East
                else if (e && s) rotation = 180; // East+South
                else if (s && w) rotation = 270; // South+West
            }
        }
        else if (connectionCount == 3)
        {
            // T-way - your T-way at 0° opens to N,S,E (stem points West)
            // So if West is missing, use 0°. If North missing, rotate 90°, etc.
            prefab = streetTWay;
            if (!w) rotation = 0;   // Missing West, stem should point West
            else if (!n) rotation = 90;  // Missing North, stem should point North
            else if (!e) rotation = 180; // Missing East, stem should point East
            else if (!s) rotation = 270; // Missing South, stem should point South
        }
        else if (connectionCount == 4)
        {
            prefab = streetFourWay;
            rotation = 0;
        }
        
        // Get proper height via raycast
        Vector3 worldPos = new Vector3(gridPos.x * gridSize, height, gridPos.y * gridSize);
        Ray ray = new Ray(worldPos + Vector3.up * 1000f, Vector3.down);
        if (Physics.Raycast(ray, out RaycastHit hit, 2000f, terrainLayer))
        {
            worldPos.y = hit.point.y;
        }
        
        // Delete old tile if exists
        if (placedTiles[gridPos] != null)
        {
            Undo.DestroyObjectImmediate(placedTiles[gridPos]);
        }
        
        // Create new tile
        GameObject tile = (GameObject)PrefabUtility.InstantiatePrefab(prefab);
        tile.transform.position = worldPos;
        tile.transform.rotation = Quaternion.Euler(0, rotation, 0);
        tile.transform.SetParent(parentObject.transform);
        
        // Add GridTile component
        GridTile gridTile = tile.GetComponent<GridTile>();
        if (gridTile == null)
        {
            gridTile = tile.AddComponent<GridTile>();
        }
        gridTile.gridPosition = gridPos;
        
        placedTiles[gridPos] = tile;
        Undo.RegisterCreatedObjectUndo(tile, "Paint Road");
    }
    
    private void ClearAllRoads()
    {
        foreach (var kvp in placedTiles)
        {
            if (kvp.Value != null)
            {
                Undo.DestroyObjectImmediate(kvp.Value);
            }
        }
        placedTiles.Clear();
    }
}

