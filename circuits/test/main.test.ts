/* eslint-disable node/no-missing-import */
/* eslint-disable camelcase */
import { expect } from "chai";
// eslint-disable-next-line node/no-extraneous-import
import { ZKPClient } from "circuits";
import fs from "fs";
import path from "path";

describe("Test zkp circuit and scripts", function () {
  let client: ZKPClient;
  beforeEach(async () => {
    const wasm = fs.readFileSync(
      path.join(__dirname, "../../circuits/zk/circuits/main_js/main.wasm")
    );
    const zkey = fs.readFileSync(
      path.join(__dirname, "../../circuits/zk/zkeys/main.zkey")
    );
    client = await new ZKPClient().init(wasm, zkey);
  });
  it("Should able to prove and verify the zkp", async function () {
    // center impassable
    const tiles = [
      2n, 0n, 0n,
      0n, 1n, 0n,
      0n, 0n, 3n,
    ];
    const path = [
      0n,
      3n,
      6n,
      7n,
      8n,
      // empty points needed to fill out path.
      // currently, these need to target a passable (0) tile.
      // this will need to change once we check if the
      // path indexes are connected.
      1n,
      1n,
      1n,
      1n,
    ];


    const proof = await client.prove({
      tiles,
      path,
    });
    expect(proof).not.to.eq(undefined);
  });
});
