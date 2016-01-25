part of rpg_common;

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
}

class TestEntity extends Entity {
  TestEntity(Game game, double x, double y) : super(game, x, y, 32.0, 32.0);
}
