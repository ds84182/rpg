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

    //fix collisions
    //TODO: Only invalidate getPotential if we move into new cells
    var visited = new Set<CollisionObject>();
    for (var entity in entities) {
      visited.clear();
      while (true) {
        //if we are anchored, filter out collisions with other anchored entities
        var collisions = collisionManager.getCollisions(entity,
            (other) {
              if (visited.contains(other)) return false;
              return entity.anchored ? (!other.anchored) : true;
            })
            .iterator;

        if (collisions.moveNext()) {
          var pair = collisions.current;
          visited.add(pair.other);
          //print("Handling collision with ${entity} -> ${pair.other} ${pair.response.direction} ${pair.response.amount}");

          if (entity.anchored) {
            //just move the other one, if it isn't anchored either
            pair.other.handleCollision(entity, pair.response.opposite);
          } else {
            if (pair.other.anchored) {
              //if the other one is anchored, we move
              entity.handleCollision(pair.other, pair.response);
            } else {
              //print("${entity.y} ${pair.other.y}");
              //move half and half
              pair.response.amount /= 2;
              pair.response.opposite.amount = pair.response.amount;
              //print("Opposite ${pair.response.opposite.direction} ${pair.response.opposite.amount}");
              entity.handleCollision(pair.other, pair.response);
              pair.other.handleCollision(entity, pair.response.opposite);

              //print("${entity.y} ${pair.other.y}");
            }

            // We only use the first collision from the collision iterable because we may or may not of
            // moved into new cells with new potential collisions, which would technically require a getPotentialCollisions
            // iterator invalidation, but since we can't restart a top level iterator because the data changed, we have to do this
          }
        } else {
          break;
        }
      }
    }

    render();
  }
}
