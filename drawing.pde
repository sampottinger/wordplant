/**
 * Logic to draw the tree visualization.
 *
 * @author A Samuel Pottinger (gleap.org)
 * @license MIT
 */


/**
 * Utility to draw a semantic tree.
 *
 * <p>
 * Utility to draw a semantic tree in a semi-stochastic fashion where the angle
 * between those branches are determined randomly within allowable ranges.
 * </p>
 */
class TreeDrawer {
  
  /**
   * Draw the tree.
   *
   * @param rootNode The root of the tree to be drawn.
   */
  public void draw(TreeNode rootNode) {
    pushMatrix();
    pushStyle();
    
    textFont(BODY_FONT);
    textAlign(LEFT, CENTER);
    fill(#A0333333);
    stroke(#A0333333);
    
    translate(START_X, START_Y);
    rotate(START_ROTATION);
    drawTree(rootNode);
    
    popStyle();
    popMatrix();
  }
  
  /**
   * Get the total number of nodes in a branch of a tree.
   *
   * @param target The root of the branch to count.
   * @returns Number of nodes in the branch including the root.
   */
  private int getTotalCount(TreeNode target) {
    int totalDescendants = 0;
    for (TreeNode child : target.getChildren()) {
      totalDescendants += getTotalCount(child);
    }
    return totalDescendants + 1;
  }
  
  /**
   * Draw a tree or sub-tree.
   *
   * @param node The node to draw.
   */
  private void drawTree(TreeNode node) {
    pushMatrix();
    pushStyle();
    
    String name = node.getName();
    text(name, 0, 0);
    
    float printedWidth = textWidth(name);
    translate(printedWidth, 0);
    
    int numChildren = node.getChildren().size();
    float spread;
    if (numChildren == 1) {
      spread = 0;
    } else {
      spread = random(MIN_BRANCH_SPREAD, MAX_BRANCH_SPREAD);
    }
    
    float remainingWidth = BRANCH_WIDTH + (numChildren * 5) - printedWidth;
    
    rotate(-spread/2);
    float spreadIncrement = spread / node.getChildren().size();
    
    List<TreeNode> children = node.getChildren();
    children.sort((a, b) -> {
      Integer aNumChildren = getTotalCount(a);
      Integer bNumChildren = getTotalCount(b);
      return bNumChildren.compareTo(aNumChildren);
    });
    
    List<TreeNode> sortedChildren = new ArrayList<>();
    int index = 0;
    for (TreeNode child : children) {
      if (index % 2 == 0) {
        sortedChildren.add(child);
      } else {
        sortedChildren.add(0, child);
      }
      index++;
    }
    
    index = 0;
    for (TreeNode child : sortedChildren) {
      pushMatrix();
      rotate(spreadIncrement * index);
      line(1, 0, remainingWidth - 1, 0);
      translate(remainingWidth, 0);
      drawTree(child);
      popMatrix();
      
      index++;
    }
    
    
    popStyle();
    popMatrix();
  }

}
