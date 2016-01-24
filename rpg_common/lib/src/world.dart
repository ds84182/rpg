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
    print("Making noise structures");
    var generator = new NoiseGenerator(1/8, 1337, 6969);
    grid.mapInto((x, y) => generator.get(x.toDouble(), y.toDouble()) < 0 ? const StoneTile() : const GrassTile());
    print("Done!");
  }
}
