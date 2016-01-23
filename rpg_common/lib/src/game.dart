part of rpg_common;

class Entity {}

abstract class Game {
  bool started = false;
  num lastTime = 0;

  World world;
  List<Entity> entities = <Entity>[];

  void start() async {
    if (!started) {
      started = true;

      // Add base entities
      world = new World(this, 500, 500);
      await world.generate();
      //addEntity(new EntityPlayer(this, 48, 48));

      render();
    }
  }

  void render();

  void loop(num renderingTime) {
    var dt = (renderingTime - lastTime) / 1000.0;
    lastTime = renderingTime;

    // Update
    //world.update(dt);
    for (var entity in entities) {
      //entity.update(dt);
    }

    render();
  }
}
