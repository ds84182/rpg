part of rpg_client;

class GenericTileRenderer extends TileRenderer {
  String imageName;
  ImageElement image;

  GenericTileRenderer(String name) :
    imageName = "resource/tile/$name.png";

  void render(BrowserGame game, World world, Tile tile, int x, int y) {
    if (image == null) {
      image = Resource.get(imageName);
    }

    if (image != null) {
      game.context.drawImage(image, x, y);
    }
  }
}

void StoneTileRenderer(BrowserGame game, World world, Tile tile, int x, int y) {

}
