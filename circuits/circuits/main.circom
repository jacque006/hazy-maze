pragma circom 2.1.4;
include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/gates.circom";

// From https://github.com/privacy-scaling-explorations/maci/blob/v1/circuits/circom/trees/calculateTotal.circom
// This circuit returns the sum of the inputs.
// n must be greater than 0.
template CalculateTotal(n) {
    signal input nums[n];
    signal output sum;

    signal sums[n];
    sums[0] <== nums[0];

    for (var i=1; i < n; i++) {
        sums[i] <== sums[i - 1] + nums[i];
    }

    sum <== sums[n - 1];
}

// Modified from https://github.com/privacy-scaling-explorations/maci/blob/v1/circuits/circom/trees/incrementalQuinTree.circom#L25-L57
/*
 * Given a list of items and an index, output the item at the position denoted
 * by the index. The number of items must be less than 2^252, and the index must
 * be less than the number of items.
 */
template ArraySelector(arrLen) {
    signal input in[arrLen];
    signal input idx;
    signal output out;

    // Ensure that index < choices
    // TODO We can make the number of bits based on width * height
    signal indexInRange <== LessThan(252)([idx, arrLen]);
    indexInRange === 1;

    component calcTotal = CalculateTotal(arrLen);
    signal eqs[arrLen];

    // For each item, check whether its index equals the input index.
    for (var i = 0; i < arrLen; i ++) {
        eqs[i] <== IsEqual()([i, idx]);

        // eqs[i].out is 1 if the index matches. As such, at most one input to
        // calcTotal is not 0.
        calcTotal.nums[i] <== eqs[i] * in[i];
    }

    // Returns 0 + 0 + ... + item
    out <== calcTotal.sum;
}

/**
 * Component which verifies that a path through a through a maze
 * from a start point to an end point is valid. The path is private.
 */
template Maze(width, height) {
    // constants
    /**
     * Tile values
     */
    var PASSABLE_TILE = 0;
    var WALL_TILE = 1;
    var START_TILE = 2;
    var END_TILE = 3;

    // public
    /**
     * array of maze tiles, with:
     * - 0 indicating the tile is passable
     * - 1 indicating the tile is not passable (wall)
     * - 2 indicating the start of the maze
     * - 3 indicating the end of the maze
     *
     * Example 3x3 maze with the center blocked off:
     * [2, 0, 0
     *  0, 1, 0,
     *  0, 0, 3]
     *
     */
    signal input tiles[width * height];

    // private
    /**
     * The path through the maze as an array of tile indexes
     * The mazimum possible path through any maze with be width * height
     */
    signal input path[width * height];

    // output
    /**
     * The length of the path taken through the maze
     */
    // TODO implement
    // signal output pathLen;

    component arrSelectors[width * height];
    signal canMoveToTile[width * height];
    component orGates[width * height];
    component mazeCompleted = CalculateTotal(width * height);

    // Check the path through the maze
    for (var i = 0; i < width * height; i++) {
        // Setup array selector which will return
        // the tile value for a given path index
        arrSelectors[i] = ArraySelector(width * height);
        for (var j = 0; j < width * height; j++) {
            arrSelectors[i].in[j] <== tiles[j];
        }
        arrSelectors[i].idx <== path[i];

        // Check if we've reached the end
        mazeCompleted.nums[i] <== IsEqual()([arrSelectors[i].out, END_TILE]);

        // Setup OR gates so we can allow the end tile to be passable
        // TODO There is likely a better way to do this.
        orGates[i] = OR();

        if (i == 0) {
            // Check first path point is at start
            canMoveToTile[i] <== IsEqual()([arrSelectors[i].out, START_TILE]);
            orGates[i].a <== canMoveToTile[i];
            // Only need to check for start tile
            orGates[i].b <== 0;
            orGates[i].out === 1;
        } else {
            // Check that tile is passable
            canMoveToTile[i] <== IsEqual()([arrSelectors[i].out, PASSABLE_TILE]);
            orGates[i].a <== canMoveToTile[i];
            orGates[i].b <== mazeCompleted.nums[i];
            orGates[i].out === 1;

            // TODO ensure current path point is connected to prevous path point
        }
    }

    // Check that we reached the end of the maze
    mazeCompleted.sum === 1;
}

component main { public [tiles] } = Maze(3, 3);
