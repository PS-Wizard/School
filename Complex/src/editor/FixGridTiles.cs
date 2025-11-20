using UnityEngine;
using UnityEditor;

public class FixGridTiles : EditorWindow
{
    [MenuItem("Tools/Fix Missing GridTile Components")]
    public static void ShowWindow()
    {
        if (EditorUtility.DisplayDialog("Fix GridTile Components",
            "This will remove broken GridTile components and add new ones. Continue?",
            "Yes", "Cancel"))
        {
            FixAllGridTiles();
        }
    }
    
    static void FixAllGridTiles() {
        GameObject roadGrid = GameObject.Find("RoadGrid");
        if (roadGrid == null)
        {
            Debug.LogError("RoadGrid not found!");
            return;
        }

        int fixedCount = 0;
        Transform[] children = roadGrid.GetComponentsInChildren<Transform>();

        foreach (Transform child in children)
        {
            if (child == roadGrid.transform) continue;

            // Remove missing scripts
            GameObjectUtility.RemoveMonoBehavioursWithMissingScript(child.gameObject);

            // Remove old GridTile completely
            GridTile oldTile = child.GetComponent<GridTile>();
            if (oldTile != null)
            {
                DestroyImmediate(oldTile, true);
            }

            // Add fresh GridTile with correct position
            GridTile tile = child.gameObject.AddComponent<GridTile>();

            float gridSize = 20f;
            Vector3 pos = child.position;
            tile.gridPosition = new Vector2Int(
                    Mathf.RoundToInt(pos.x / gridSize),
                    Mathf.RoundToInt(pos.z / gridSize)
                    );

            fixedCount++;
        }

        Debug.Log($"Fixed {fixedCount} road tiles!");
        EditorUtility.SetDirty(roadGrid);
    }
}
