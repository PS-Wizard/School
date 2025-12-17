using UnityEngine;
using System.Collections.Generic;
using System.Linq;

// Main script that manages path finding using a*
public class PathfindingManager : MonoBehaviour {
    [Header("Grid Settings")]
    [Tooltip("Size of each grid cell in world units")]
    public float gridSize = 20f;

    [Header("Blocked Roads")]
    [Tooltip("List of grid positions that are blocked for pathfinding")]
    public List<Vector2Int> blockedRoads = new List<Vector2Int>();

    // Dictionary for each road and it's position
    private Dictionary<Vector2Int, GameObject> roadTiles = new Dictionary<Vector2Int, GameObject>();
    private List<Vector2Int> currentPath = new List<Vector2Int>();

    void Start() {
        RebuildRoadDictionary();
    }

    // Rebuilds the dictionary of all the road tiles and it's position
    public void RebuildRoadDictionary() {
        roadTiles.Clear();

        // get the parent object
        GameObject roadGrid = GameObject.Find("RoadGrid");
        if (roadGrid == null)
        {
            Debug.LogError("RoadGrid parent object not found in scene!");
            return;
        }

        // get all of it's children
        GridTile[] tiles = roadGrid.GetComponentsInChildren<GridTile>();

        foreach (GridTile tile in tiles)
        {
            if (tile != null)
            {
                // extract the `gridPosition`  from each road component, 
                // this comes from the gridTile.cs script that is attached to each individual road tiles.
                roadTiles[tile.gridPosition] = tile.gameObject;
            }
        }

        Debug.Log($"Rebuilt dictionary for {roadTiles.Count} road tiles");
    }

    // Validates if the start & goal point set is actually in one of the roadTiles, if so, only then does it calculate the path
    public List<Vector2Int> CalculatePath(Vector2Int start, Vector2Int goal) {
        if (!roadTiles.ContainsKey(start)) {
            Debug.LogError($"Start position {start} is not on a road!");
            return null;
        }

        if (!roadTiles.ContainsKey(goal)) {
            Debug.LogError($"Goal position {goal} is not on a road!");
            return null;
        }

        currentPath = AStar(start, goal);
        return currentPath;
    }

    // Core A* 
    private List<Vector2Int> AStar(Vector2Int start, Vector2Int goal) {
        // every node we have ever touched
        Dictionary<Vector2Int, AStarNode> allNodes = new Dictionary<Vector2Int, AStarNode>();
        // nodes currently being considered for exploration, i.e they are open to having their neighbors checked
        List<AStarNode> openSet = new List<AStarNode>();
        // nodes that have already been explored and evaluated we dont need to check these again
        HashSet<Vector2Int> closedSet = new HashSet<Vector2Int>();

        // create starting node
        AStarNode startNode = new AStarNode
        {
            position = start, 
            g = 0, // cost from start
            h = ManhattanDistance(start, goal), // the heuristic 
            parent = null // to reconstruct the path after goal is found, which for starting node is none
        };

        startNode.f = startNode.g + startNode.h; // cost estimate f = g + h

        // add the initialized startingNode to the allNodes dictionary
        allNodes[start] = startNode;

        // mark the startingNode as the node to be explored
        openSet.Add(startNode);

        // main search loop, keep processing as long as there are nodes in `openSet` to explore
        while (openSet.Count > 0) {

            // Find the lowest F score, the most promising option
            AStarNode current = openSet.OrderBy(n => n.f).First();

            // check if this is the goal, if so bada bing bada boom
            if (current.position == goal)
            {
                return ReconstructPath(current);
            }

            // sad not end goal :<, 
            // the current node is chosen now and is about to be explored so remove from openSet
            openSet.Remove(current);

            // add the current node's position to the `closedSet` so that it wont be processed again
            closedSet.Add(current.position);

            // define the current node's neighbours
            Vector2Int[] neighbors = new Vector2Int[]
            {
                current.position + Vector2Int.up,
                current.position + Vector2Int.right,
                current.position + Vector2Int.down,
                current.position + Vector2Int.left
            };

            foreach (Vector2Int neighborPos in neighbors) {
                // Skip if not a road, blocked, or already processed
                if (!roadTiles.ContainsKey(neighborPos)) continue;
                if (blockedRoads.Contains(neighborPos)) continue;
                if (closedSet.Contains(neighborPos)) continue;

                // calculate the potential new G score for this neighbor, as it's in a grid the movement from one tile to the next costs 1.
                int tentativeG = current.g + 1;

                // if the neighbor has never been seen before, create a new `AStarNode` for it
                if (!allNodes.ContainsKey(neighborPos)) {
                    allNodes[neighborPos] = new AStarNode {
                        position = neighborPos,
                        // we assign a big value here, because this is a trick,
                        // to make the code branch that handles path improvement,
                        // also handle the initial discovery. Because, if we say had done:
                        // if the never has never been seen before -> this is the first time it's being explored -> so it is definitely a better path (the first path) -> update its F, G, -> add to open set 
                        // else -> the neighbor already exists -> check if this path is better -> update G,F -> add to openset if needed 
                        // Instead if we assign g to a very big value, the conditional check in line 149, will act as both the improvement handling and initial discovery handling
                        g = int.MaxValue,
                        h = ManhattanDistance(neighborPos, goal),
                        parent = null
                    };
                }

                // retreive the `AStarNode` object, either one that was just created or already existing one
                AStarNode neighbor = allNodes[neighborPos];

                // If the path through the current node to the neighbour has a lower score than any previous path, update the path
                if (tentativeG < neighbor.g) {
                    neighbor.parent = current;
                    neighbor.g = tentativeG;
                    neighbor.f = neighbor.g + neighbor.h;

                    // add the neighbor to `openSet` if it hasnt been already, since it's path has been improved and we need to consider this for the next round of exploration
                    if (!openSet.Contains(neighbor)) {
                        openSet.Add(neighbor);
                    }
                }
            }
        }

        // if the while loop finishes, `openSet.Count == 0`, without finding the goal, no path exists.
        Debug.LogWarning(" No path found!");
        return null;
    }

    private int ManhattanDistance(Vector2Int a, Vector2Int b) {
        return Mathf.Abs(a.x - b.x) + Mathf.Abs(a.y - b.y);
    }

    // Given an `AStarNode` object, follow the `AStarNode.parent` all the way back to the StartNode (AStarNode.parent == null),
    // collecting the position for each
    private List<Vector2Int> ReconstructPath(AStarNode goalNode) {
        List<Vector2Int> path = new List<Vector2Int>();
        AStarNode current = goalNode;

        while (current != null) {
            path.Add(current.position);
            current = current.parent;
        }

        path.Reverse();
        return path;
    }

    // Block a road at the specified grid position.
    public void BlockRoad(Vector2Int position) {
        if (!blockedRoads.Contains(position)) {
            blockedRoads.Add(position);
        }
    }

    // Unblock a road at the specified grid position.
    public void UnblockRoad(Vector2Int position) {
        blockedRoads.Remove(position);
    }

    // Convert a grid position to world position.
    public Vector3 GridToWorld(Vector2Int gridPos) {
        if (roadTiles.ContainsKey(gridPos)) {
            return roadTiles[gridPos].transform.position;
        }

        return new Vector3(gridPos.x * gridSize, 0, gridPos.y * gridSize);
    }

    // Converts a world position to grid position.
    public Vector2Int WorldToGrid(Vector3 worldPos) {
        return new Vector2Int(
                Mathf.RoundToInt(worldPos.x / gridSize),
                Mathf.RoundToInt(worldPos.z / gridSize)
                );
    }

    // Gets the currently calculated path.
    public List<Vector2Int> GetCurrentPath() {
        return currentPath;
    }

    // Manually sets the current path.
    public void SetCurrentPath(List<Vector2Int> path) {
        currentPath = path;
    }

    // Checks if a grid position contains a road.
    public bool IsRoad(Vector2Int gridPos) {
        return roadTiles.ContainsKey(gridPos);
    }

    private class AStarNode {
        public Vector2Int position;
        public int g; // Cost from start
        public int h; // Heuristic cost to goal
        public int f; // Total cost (g + h)
        public AStarNode parent;
    }
}
