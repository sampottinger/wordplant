/**
 * Main entry point for a sketch that builds a plant-like tree visualization 
 * by drawing a tree spanning a semantic network in a plant-like structure where
 * the spanning tree, though complete, is both constructed and drawn with
 * stochastic behavior.
 *
 * @author A Samuel Pottinger (gleap.org)
 * @license MIT
 */
import java.util.*;


/**
 * Draw the visualization and save to drawing.png.
 */
void setup() {
  size(800, 800);
  loadSemiconstants();
  
  Graph graph = loadData();
  TreeSpanner spanner = new TreeSpanner();
  TreeNode rootNode = spanner.buildTree(graph);
  
  background(#FFFFFF);
  
  TreeDrawer drawer = new TreeDrawer();
  drawer.draw(rootNode);
  
  save("drawing.png");
}


/**
 * Empty main drawing loop.
 */
void draw() {
  
}
