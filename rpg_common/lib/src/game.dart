part of rpg_common;

abstract class Game {
  bool started = false;
  num lastTime = 0;

  World world;
  CollisionManager collisionManager = new CollisionManager(64);
  List<Entity> entities = [];

  Future start() async {
    if (!started) {
      started = true;

      // Add base entities
      world = new World(this, 500, 500);
      await world.generate();
      //addEntity(new EntityPlayer(this, 48, 48));

      render();
    }
  }

  void addEntity(Entity e) {
    entities.add(e);
    collisionManager.add(e);
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
