// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of rpg_common;

abstract class Tile {
  const Tile();
}

class StoneTile extends Tile {
  const StoneTile();
}

class GrassTile extends Tile {
  const GrassTile();
}

class World {
  Game game;
  int width, height;
  Map2D<Tile> grid;

  World(this.game, this.width, this.height) {
    grid = new Map2D(width, height);
  }

  void generate() async {
    //We use Futures in this code to give dart some breathing room
    print("Making noise structures");
    Map2D<bool> noiseStructure = new Map2D(width, height);
    //Random random = new Random();
    /*for (var iter = 0; iter < 10; iter++) {
      await new Future(() {
        //Generate noise
        noiseStructure.forEach((x, y, val) {
          if (random.nextDouble() < 0.25)
            noiseStructure.set(x, y, true);
        });

        //Smooth noise
      });
    }*/
    //TODO: Noise wrapper with seeds and stuff
    grid.mapInto((x, y) => simplex2(x.toDouble()/8.0, y.toDouble()/8.0) < 0 ? const StoneTile() : const GrassTile());
    print("Done!");
  }
}
