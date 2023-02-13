/**
 * Values that do not change during the execution of the sketch.
 *
 * @author A Samuel Pottinger (gleap.org)
 * @license MIT
 */

// Font to use when drawing the visualization
PFont BODY_FONT;

// Location where the data for the visualization can be found
final String GRAPH_FILE = "postcard.csv";

// Root of the plant / tree to be drawn
final String ROOT_NODE = "Thoughtful";

// Where drawing the plant should start
final float START_X = 400;
final float START_Y = 790;

// The orientation at which the plant should start to be drawn
final float START_ROTATION = -PI/2;

// How long each branch should be (a line is drawn past the text on a branch to
// this width.
final float BRANCH_WIDTH = 70;

// Parameters for how much spread there are between branches in the
// visualization
final float MIN_BRANCH_SPREAD = PI * 3/8;
final float MAX_BRANCH_SPREAD = PI;


/**
 * Load values that do not change during the course of the sketch but need to
 * be loaded after initialization.
 */
void loadSemiconstants() {
  BODY_FONT = loadFont("GoudyBookletter1911-14.vlw");
}
