part of rpg_common;

class EntityCapability extends Capability {
  const EntityCapability();
}

abstract class Entity extends CollisionObject with Capable {
  Game game;
  double _x, _y, _width, _height;
  double vx, vy;

  Entity(this.game, this._x, this._y, this._width, this._height) {
    updateAABB();
  }

  void updateAABB() {
    aabb.setCenterAndHalfExtents(new Vector2(_x, _y), new Vector2(_width/2.0, _height/2.0));
    updateCollision();
  }

  double get x => _x;
  double get y => _y;
  double get width => _width;
  double get height => _height;

  void set x(double val) {
    _x = val;
    updateAABB();
  }

  void set y(double val) {
    _y = val;
    updateAABB();
  }

  void set width(double val) {
    _width = val;
    updateAABB();
  }

  void set height(double val) {
    _height = val;
    updateAABB();
  }

  void moveBy(double x, double y) {
    _x += x;
    _y += y;
    updateAABB();
  }

  bool handleCollision(CollisionObject other, CollisionResponse response) {
    // Move AWAY from the collision, not torwards it
    switch (response.direction) {
      case CollisionDirection.LEFT:
        x += response.amount;
        break;
      case CollisionDirection.RIGHT:
        x -= response.amount;
        break;
      case CollisionDirection.TOP:
        y += response.amount;
        break;
      case CollisionDirection.BOTTOM:
        y -= response.amount;
        break;
    }

    return true;
  }
}

class TestEntity extends Entity {
  static int nextID = 0;
  int id = nextID++;
  TestEntity(Game game, double x, double y) : super(game, x, y, 32.0, 32.0);

  @override
  String toString() => "TestEntity: $id";
}
