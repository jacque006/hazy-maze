pragma circom 2.1.4;

/**
 * Component which verifies that a path through a through a maze
 * from a start point to an end point is valid. The path is private.
 */
template MazeVerifier(width, height) {
    // public
    /**
     * 2d boolean array of maze tiles, with:
     * - true indicating the tile is passable
     * - false indicating the tile is not passable (wall)
     *
     * Example maze with the center blocked off:
     * [
     *   [true, true, true],
     *   [true, false, true],
     *   [true, true, true]
     * ]
     *
     */
    signal input tiles[width][height];
    /**
     * The start point ([x, y]) in the maze. It must be passable (true)
     */
    signal input start[2];
    /**
     * The end point ([x, y]) in the maze. It must be passable (true)
     */
    signal input end[2];

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
    signal output pathLen;

    // Ensure start is passable
    assert(tiles[start[0]][start[1]]);

    // TODO Ensure first path point is at start

    // Ensure end is passable
    assert(tiles[end[0]][end[1]]);

    // Check the path through the maze
    var curPathLen = 0;
    for (var i = 0; i < width * height; i++) {
        // Check that the point is passable
        assert(tiles[path[i][0]][path[i][1]]);
        // TODO ensure current path point is connected to prevous path point
        // TODO check if we've reached the end and terminate the loop (break?)
        curPathLen = i + 1;
    }

    // output the length of the path taken
    pathLen <== curPathLen;
}

component main { public [tiles, start, end] } = MazeVerifier(3, 3);
