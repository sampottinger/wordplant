/**
 * Structures for building and working with a spanning tree within a semantic
 * word network.
 * 
 * @author A Samuel Pottinger (gleap.org)
 * @license MIT
 */


/**
 * Node within a spanning tree.
 */
class TreeNode {
  
  private final String name;
  private final List<TreeNode> children;
  
  /**
   * Create a new tree node.
   *
   * @param newName The name of the node (word within the node).
   * @param newChildren The nodes that are immediate children of this node.
   */
  public TreeNode(String newName, List<TreeNode> newChildren) {
    name = newName;
    children = newChildren;
  }
  
  /**
   * Get the name of (word in) this node.
   *
   * @returns The word represented by this node.
   */
  public String getName() {
    return name;
  }
  
  /**
   * Get the immediate children of this node.
   *
   * @returns The immediate children of this node.
   */
  public List<TreeNode> getChildren() {
    return children;
  }
  
  /**
   * Determine if this node is a stub or not.
   *
   * @returns True if this is a terminal node (no children) and false if this
   *   node has children.
   */
  public boolean hasChildren() {
    return children.size() > 0;
  }
  
}


/**
 * Utility to find a spanning tree within a semantic word network.
 *
 * <p>
 * Utility which builds a spanning tree for a semantic word network but with
 * stochastic elements. Specifically the max children per node is randomly
 * chosen per node within acceptable ranges and if a specific node is
 * made a child of another node is subject to a probability. However, the
 * returned tree is guaranteed to include all nodes of the input graph.
 * </p>
 */
class TreeSpanner {


  /**
   * Build a spanning tree for a semantic word graph.
   *
   * @param graph The graph from which to build a spanning tree. Note that the
   *   marking state of this graph may be modified.
   * @returns A semi-stochastically built spanning tree for the input graph.
   */
  public TreeNode buildTree(Graph graph) {
    graph.clearMarking();
    graph.mark(ROOT_NODE);
    TreeNode root = buildTree(graph, ROOT_NODE, 0);
    graph.clearMarking();
    
    return root;
  }
  
  
  /**
   * Build a tree from a semantic network, ignoring marked words.
   *
   * @param graph The graph from which to build a tree. Note that the
   *   marking state of this graph may be modified.
   * @param word The root of the tree.
   * @param depth The current depth of tree. If 0, this is the start of the tree
   *   and more than 0 if some of the tree has already been built.
   * @returns Spanning tree of the semantic networks' previously non-marked
   *   words.
   */
  private TreeNode buildTree(Graph graph, String word, int depth) {
    List<GraphEdge> edges = graph.getEdges(word, true);
    List<TreeNode> children = new ArrayList<>();
    
    float maxChildren;
    if (depth < 2) {
      maxChildren = random(3, 7);
    } else {
      maxChildren = random(2, 5);
    }
    
    edges.sort((a, b) -> {
      Float aScore = a.getWeight();
      Float bScore = b.getWeight();
      return bScore.compareTo(aScore);
    });
    
    List<String> childrenPending = new ArrayList<>();
    for (GraphEdge edge : edges) {
      String otherWord = edge.getOtherWord();
      boolean isMarked = graph.getIsMarked(otherWord);
      boolean belowMaxChildren = childrenPending.size() < maxChildren;
      boolean includeSelected = belowMaxChildren && random(0, 1) < 0.5;
      boolean includeLastChance = graph.getEdges(otherWord, true).size() == 0;
      boolean include = includeSelected || includeLastChance;
      if (!isMarked && include) {
        graph.mark(otherWord);
        childrenPending.add(otherWord);
      }
    }
    
    for (String otherWord : childrenPending) {
      children.add(buildTree(graph, otherWord, depth + 1));
    }
    
    return new TreeNode(word, children);
  }

}
