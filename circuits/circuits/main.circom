pragma circom 2.1.4;
include "../../node_modules/circomlib/circuits/comparators.circom";

/**
 * Component which verifies that a path through a through a maze
 * from a start point to an end point is valid. The path is private.
 */
template Maze(width, height) {
    // public
    /**
     * 2d bit array of maze tiles, with:
     * - 0 indicating the tile is passable
     * - 1 indicating the tile is not passable (wall)
     * - 2 indicating the start of the maze
     * - 3 indicating the end of the maze
     *
     * Example 3x3 maze with the center blocked off:
     * [
     *   [2, 0, 0],
     *   [0, 1, 0],
     *   [0, 0, 3]
     * ]
     *
     */
    signal input tiles[width][height];

    // private
    /**
     * The path through the maze as an array of points ([[x0, y0], [x1, y1], ..., [xn, yn]])
     * The mazimum possible path through any maze with be width * height
     */
    signal input path[width * height][2];

    // output
    /**
     * The length of the path taken through the maze
     */
    // TODO implement
    // signal output pathLen;

    var PASSABLE_TILE = 0;
    var WALL_TILE = 1;
    var START_TILE = 2;
    var END_TILE = 3;

    signal pathSignals[width * height];

    // Ensure start is in range of the maze
    // signal isStartXInRange <== LessEqThan(252)([start[0], width]);
    // isStartXInRange === 1;

    // Ensure start is passable
    // signal isStartPassable <== IsZero()(tiles[startX][0]);
    // isStartPassable === 1;

    // Check the path through the maze
    for (var i = 0; i < width * height; i++) {
        // TODO How can we extract the path point and use as an index on the tiles?
        pathSignals[i] <== IsEqual()([tiles[0][0], PASSABLE_TILE]);
        pathSignals[i] === 1;
        // TODO Check that the point is passable
        // TODO ensure current path point is connected to prevous path point
        // TODO check if we've reached the end and terminate the loop (break?)
    }
}

component main { public [tiles] } = Maze(3, 3);
