part of rpg_client;

void RenderWorld(BrowserGame game, World world) {
  var context = game.context;

  context.fillStyle = "red";

  //get start of onscreen tiles
  int startX = ((game.camera.x-(game.canvas.width/2))/8).floor(); //TODO: Method in the camera to do this
  int startY = ((game.camera.y-(game.canvas.height/2))/8).floor();

  int endX = (startX+(game.canvas.width/8)).floor();
  int endY = (startY+(game.canvas.height/8)).floor();

  //TODO: Map2D.forEachInRegion
  for (int x=startX; x<=endX; x++) {
    for (int y=startY; y<=endY; y++) {
      if (world.grid.isInside(x, y) && world.grid.get(x, y) != null) {
        context.fillRect(x*8, y*8, 8, 8);
      }
    }
  }
}
