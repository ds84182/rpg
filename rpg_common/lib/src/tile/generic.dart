part of rpg_common;

// base class for all tile capabilities
class TileCapability extends Capability {
  const TileCapability();
}

// tile collision capability
class TileCollisionCapability extends TileCapability {
  const TileCollisionCapability();
}

class StoneTile extends Tile {
  StoneTile() : super("stone") {
    addCapability(const TileCollisionCapability());
  }
}

class GrassTile extends Tile {
  GrassTile() : super("grass");
}
