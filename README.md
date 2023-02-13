# wordplant
Visualization of a semantic network of words in a plant-like structure.

<br>

## Purpose
This [Processing](https://processing.org/) sketch loads an [adjacency matrix](https://en.wikipedia.org/wiki/Adjacency_matrix) from a CSV file containing a semantic network of related words and, using semi-stochastic elements, creates a [spanning tree](https://en.wikipedia.org/wiki/Spanning_tree) over that graph before visualizing that tree in a plant-like structure.

<br>

## Usage
This requires [Processing 4](https://processing.org/download). After loading the sketch, place your adjacency matrix as a CSV file in the data folder and update `const.pde/GRAPH_FILE` to point to that file. This graph must be [connected](https://en.wikipedia.org/wiki/Connectivity_%28graph_theory%29). Note that this will also require the following configuration:

 - Path to a font file ("vlw" file) as indicated in `const.pde/BODY_FONT`. Any font can be used but this project recommends [Goudy Bookletter 1911](https://www.theleagueofmoveabletype.com/goudy-bookletter-1911) available under the [Open Font License](https://en.wikipedia.org/wiki/SIL_Open_Font_License).
 - Root node (word) for that semantic spanning tree as specified in `const.pde/ROOT_NODE`.

Upon running the sketch, the result will be written to `drawing.png`.

<br>

## Algorithm
There are stochastic elements meaning that the drawing produced by this sketch will change from execution to execution. That in mind, there are two algorithms at play:

#### Building the spanning tree
This is implemented in `tree.pde/TreeSpanner` with the following proceedure given a starting node:

 - Mark the node currently being visited.
 - Randomly choose a number of max children allowed for the current node.
 - Sort graph edges from that child by edge weight in descending order.
 - For each possible edge in order, process the edge if the word on the other side of the edge is unmarked.
 - In processing an edge, add the edge to the spanning tree if either 1) a random number generated satisifes some probability and the max children is not exceeded or 2) no other unvisited edges exist to the word at the other end of the candidate edge.
 - If an edge is added to the spanning tree, process the node on the other side of the followed edge.
 - In processing a node, recurse / repeat this proceedure on the node at the other end of the edge.

At the end of this process, a spanning tree is created. Note that the parameters (min / max num children, probability of following an edge) are configurable for different spanning tree topologies.

##### Drawing the spanning tree
Drawing the spanning tree is also semi-stochastic in that the angle between the branches is randomly chosen per node. That in mind, this sketch attempts to center longer branches visually. It does this via the following proceedure:

 - Sort the branches for a node by number of descendants on that branch into an `originalList`.
 - Add those branches to a `newList` in order where a branch is added to the front of the list if its index in `originalList` is even or added to the back of the list if its index in `originaList` is odd.
 - Draw the branches in order of `newList`.

Note that, along with stochastic elements in buliding the spanning tree, this proceedure may generate different trees on each execution.

<br>

## License
This code is released under the [MIT License](https://mit-license.org/) as described in the `LICENSE` file. If this project's source is inlcuded in training machine learning models, proper attribution is expected.

<br>

## Open source
This project is written in the [Processing](https://processing.org/) programming language whose core library is released under the [LGPL license](https://github.com/processing/processing4/blob/main/LICENSE.md).
