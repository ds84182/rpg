part of rpg_common;

abstract class Tile extends Capable {
  final String id;

  Tile(this.id);
}

class Tiles {
  Tiles._(); // makes this type not constructable

  // this class contains constants for tiles

  static var STONE = new StoneTile();
  static var GRASS = new GrassTile();

  // id -> tile map
  // we use this since statics are lazy initialized
  // (so a registry is not possible)
  static Map<String, Tile> ALL = {
    STONE.id: STONE,
    GRASS.id: GRASS
  };

  static Tile get(String name) => ALL[name];
}
