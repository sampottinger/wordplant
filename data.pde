/**
 * Structures for working with a semantic word network.
 *
 * @author A Samuel Pottinger
 * @license MIT
 */


/**
 * Structure describing a an edge in a semantic word graph.
 *
 * <p>
 * Note that this structure can be used in either directed or non-directed
 * graphs. In the non-directed case, the designation of source vs other 
 * is not guaranteed.
 * </p>
 */
class GraphEdge {
  
  private final String sourceWord;
  private final String otherWord;
  private final float weight;
  
  /**
   * Create a new record of a graph edge.
   *
   * @param newSource The word from which the edge originates.
   * @param newOther The word where the edge points to.
   * @param newWeight The weight of the edge.
   */
  public GraphEdge(String newSource, String newOther, float newWeight) {
    sourceWord = newSource;
    otherWord = newOther;
    weight = newWeight;
  }
  
  /**
   * Get the word from which the edge originates.
   *
   * @returns The word from which the edge originates.
   */
  public String getSourceWord() {
    return sourceWord;
  }
  
  /**
   * Get the word where the edge points to.
   *
   * @returns The word where the edge points to.
   */
  public String getOtherWord() {
    return otherWord;
  }
  
  /**
   * Get the weight of the edge.
   *
   * @returns The weight of the edge.
   */
  public float getWeight() {
    return weight;
  }

}


/**
 * A non-directed markable semantic word network.
 *
 * <p>
 * Graph of words with relationships that, while non-directed, is not guarateed
 * to be acyclic. In this graph, nodes can be "marked" to, for example, indicate
 * which words have been visited in some algorithm.
 * </p>
 */
class Graph {
  
  private final Map<String, Float> innerMap;
  private final Set<String> allWords;
  private final Set<String> markedWords;
  
  /**
   * Create an emtpy graph.
   */
  public Graph() {
    innerMap = new HashMap<>();
    allWords = new HashSet<>();
    markedWords = new HashSet<>();
  }
  
  /**
   * Add a non-directed edge involving two words.
   *
   * Add a non-directed edge involving two words, overwritting a prior edge
   * between the two words if that edge exists.
   *
   * @param word1 The first word in the edge.
   * @param word2 The second word in the edge.
   * @param value The weight of the edge.
   */
  public void add(String word1, String word2, float value) {
    String key = getKey(word1, word2);
    innerMap.put(key, value);
    allWords.add(word1);
    allWords.add(word2);
  }
  
  /**
   * Get the edges to or from a word.
   *
   * @param rootWord The word for which edges should be returned.
   * @param excludeMarked Flag indicating if "marked" words should be ignored.
   *   If true, will ignore edges to "other" words if they are marked. If false,
   *   will include all. Note that edges will be returned so long as the "other"
   *   word is not marked regardless of if the rootWord is marked.
   * @returns List of edges found for the word.
   */
  public List<GraphEdge> getEdges(String rootWord, boolean excludeMarked) {
    List<GraphEdge> edges = new ArrayList<>();
    
    for (String otherWord : allWords) {
      Optional<Float> edgeWeight = getEdge(rootWord, otherWord);
      boolean isPresent = edgeWeight.isPresent();
      boolean filtered = excludeMarked && getIsMarked(otherWord);
      if (isPresent && !filtered) {
        edges.add(new GraphEdge(rootWord, otherWord, edgeWeight.get()));
      }
    }
    
    return edges;
  }
  
  /**
   * Get the weight of the edge between two words.
   *
   * @param word1 The first word in the desired edge.
   * @param word2 The second word in the desired edge.
   * @returns Empty optional if no edge found. Otherwise, the weight of that
   *   edge.
   */
  public Optional<Float> getEdge(String word1, String word2) {
    String key = getKey(word1, word2);
    if (innerMap.containsKey(key)) {
      return Optional.of(innerMap.get(key));
    } else {
      return Optional.empty();
    }
  }
  
  /**
   * Determine if a word is currently marked.
   *
   * @param word The word to lookup.
   * @returns True if the word is marked and false otherwise.
   */
  public boolean getIsMarked(String word) {
    return markedWords.contains(word);
  }
  
  /**
   * Indicate a word as marked.
   *
   * @param word The word to mark regradless of its piror marked status.
   */
  public void mark(String word) {
    markedWords.add(word);
  }
  
  /**
   * Indicate a word as not marked.
   *
   * @param word The word to unmark regradless of its piror marked status.
   */
  public void unmark(String word) {
    markedWords.remove(word);
  }
  
  /**
   * Indicate all nodes in this graph are unmarked.
   */
  public void clearMarking() {
    markedWords.clear();
  }
  
  /**
   * Get an internal key for an edge regardless of word ordering.
   *
   * @param word1 The first word in the edge relationship.
   * @param word2 The second word in the edge relationship.
   * @returns String key describing the edge.
   */
  private String getKey(String word1, String word2) {
    if (word1.compareTo(word2) < 0) {
      return word1 + "\t" + word2;
    } else {
      return word2 + "\t" + word1;
    }
  }
  
}


/**
 * Load the graph for the visualization.
 *
 * @returns Loaded graph.
 */
Graph loadData() {
  Table rawInput = loadTable(GRAPH_FILE, "header");
  
  Set<String> allWords = new HashSet<>();
  for (TableRow row : rawInput.rows()) {
    String word = row.getString("Word");
    allWords.add(word);
  }
  
  Graph graph = new Graph();
  for (TableRow row : rawInput.rows()) {
    for (String otherWord : allWords) {
      String valueStr = row.getString(otherWord);
      if (!valueStr.equals("")) {
        float value = float(valueStr);
        if (value > 0) {
          graph.add(row.getString("Word"), otherWord, value);
        }
      }
    }
  }
  
  return graph;
}
