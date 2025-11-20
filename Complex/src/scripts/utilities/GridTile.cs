using UnityEngine;
// This is the glue between all the components, each road prefab has this attached, 
// the `gridPosition` field, holds each respective road's current (x,y) position.
public class GridTile : MonoBehaviour
{
    public Vector2Int gridPosition;
    public bool isWalkable = true;
    
    private void OnDrawGizmosSelected()
    {
        Gizmos.color = isWalkable ? Color.green : Color.red;
        Gizmos.DrawWireCube(transform.position, Vector3.one * 0.8f);
    }
}
