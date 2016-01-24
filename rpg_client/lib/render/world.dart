part of rpg_client;

const int WORLD_BLOCK_RENDER_SIZE = 32; //px

//typedef void TileRenderer(BrowserGame game, World world, Tile tile, int x, int y);

abstract class TileRenderer {
  void render(BrowserGame game, World world, Tile tile, int x, int y);
}

Map<Type, TileRenderer> tileRenderers = {
  StoneTile: new GenericTileRenderer("stone")
};
TileRenderer unknownTileRenderer = new GenericTileRenderer("debug");

void RenderWorld(BrowserGame game, World world) {
  var context = game.context;

  context.fillStyle = "red";

  //get start of onscreen tiles
  int startX = ((game.camera.x-(game.canvas.width/2))/WORLD_BLOCK_RENDER_SIZE).floor(); //TODO: Method in the camera to do this
  int startY = ((game.camera.y-(game.canvas.height/2))/WORLD_BLOCK_RENDER_SIZE).floor();

  int endX = (startX+(game.canvas.width/WORLD_BLOCK_RENDER_SIZE)).floor();
  int endY = (startY+(game.canvas.height/WORLD_BLOCK_RENDER_SIZE)).floor();

  //TODO: Map2D.forEachInRegion
  for (int x=startX; x<=endX; x++) {
    for (int y=startY; y<=endY; y++) {
      Tile tile;
      if (world.grid.isInside(x, y) && (tile = world.grid.get(x, y)) != null) {
        var renderer = tileRenderers[tile.runtimeType] ?? unknownTileRenderer;

        renderer.render(game, world, tile, x*WORLD_BLOCK_RENDER_SIZE, y*WORLD_BLOCK_RENDER_SIZE);
      }
    }
  }
}
