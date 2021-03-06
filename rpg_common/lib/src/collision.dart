part of rpg_common;

enum CollisionDirection { LEFT, RIGHT, BOTTOM, TOP }

Map<CollisionDirection, CollisionDirection> directionOpposites = {
  CollisionDirection.LEFT: CollisionDirection.RIGHT,
  CollisionDirection.RIGHT: CollisionDirection.LEFT,

  CollisionDirection.BOTTOM: CollisionDirection.TOP,
  CollisionDirection.TOP: CollisionDirection.BOTTOM,
};

class CollisionResponse {
  CollisionDirection direction;
  double amount;
  CollisionResponse _opposite;

  CollisionResponse([this.direction, this.amount]);

  bool get isValid => direction != null;

  bool get isVertical => direction == CollisionDirection.BOTTOM ||
      direction == CollisionDirection.TOP;

  bool get isHorizontal => direction == CollisionDirection.LEFT ||
      direction == CollisionDirection.RIGHT;

  CollisionResponse get opposite => _opposite ??= new CollisionResponse(directionOpposites[direction], amount);
}

CollisionResponse getCollisionResponse(Aabb2 a, Aabb2 b,
    [CollisionResponse response]) {
  response ??= new CollisionResponse();

  final leftTop = b.max - a.min;
  final rightBottom = a.max - b.min;

  final left = leftTop.x;
  final right = rightBottom.x;
  final bottom = rightBottom.y;
  final top = leftTop.y;

  if (right < left && right < top && right < bottom) {
    response.direction = CollisionDirection.RIGHT;
    response.amount = right;
  } else if (left < top && left < bottom) {
    response.direction = CollisionDirection.LEFT;
    response.amount = left;
  } else if (top < bottom) {
    response.direction = CollisionDirection.TOP;
    response.amount = top;
  } else {
    response.direction = CollisionDirection.BOTTOM;
    response.amount = bottom;
  }

  return response;
}

class CollisionObject {
  Aabb2 aabb = new Aabb2();
  List<Point<int>> cells = [];
  bool anchored = false;
  CollisionManager manager;

  void moveBy(double x, double y) {
    var vec = new Vector2(x, y);
    aabb.min.add(vec);
    aabb.max.add(vec);
  }

  void updateCollision() => manager?.updateCells(this);

  bool handleCollision(CollisionObject other, CollisionResponse response) => false;
}

class CollisionPair {
  CollisionObject other;
  CollisionResponse response;

  CollisionPair(this.other, this.response);
}

class CollisionManager {
  int cellSize;
  double invCellSize;
  Map<Point<int>, List<CollisionObject>> cellMap = {};
  List<CollisionObject> managed = [];

  Vector2 _tempCell1 = new Vector2.zero();
  Vector2 _tempCell2 = new Vector2.zero();

  CollisionManager(this.cellSize) {
    invCellSize = 1 / cellSize;
  }

  void add(CollisionObject object) {
    managed.add(object);
    object.manager = this;
    updateCells(object);
  }

  void updateCells(CollisionObject object) {
    //find cells that would contain this object
    var minCell =
        object.aabb.min.copyInto(_tempCell1).scale(invCellSize).floor();
    var maxCell =
    object.aabb.max.copyInto(_tempCell2).scale(invCellSize).floor();

    object.cells.forEach((point) => cellMap[point]?.remove(object));
    object.cells.clear();

    if (minCell == maxCell) {
      //inside single cell
      var point = new Point<int>(minCell.x.toInt(), minCell.y.toInt());
      cellMap.putIfAbsent(point, () => []).add(object);
      object.cells.add(point);
    } else {
      //within multiple cells
      int minX = minCell.x.toInt();
      int maxX = maxCell.x.toInt();
      int minY = minCell.y.toInt();
      int maxY = maxCell.y.toInt();

      for (var x = minX; x <= maxX; x++) {
        for (var y = minY; y <= maxY; y++) {
          var point = new Point<int>(x, y);
          cellMap.putIfAbsent(point, () => []).add(object);
          object.cells.add(point);
        }
      }
    }
  }

  Iterable<CollisionObject> _filterDistinct(Iterable<CollisionObject> iter) {
    var set = new Set<CollisionObject>();
    return iter.where((obj) {
      if (!set.contains(obj)) {
        set.add(obj);
        return true;
      } else {
        return false;
      }
    });
  }

  Iterable<CollisionObject> getPotentialCollisions(CollisionObject object) =>
      _filterDistinct(object.cells
          .map((point) => cellMap[point])
          .where((cell) => cell != null)
          .expand((cell) => cell)
          .where((cellObject) => cellObject != object));

  Iterable<CollisionPair> getCollisions(CollisionObject object, [bool filter(CollisionObject obj)]) =>
      getPotentialCollisions(object)
          .where(filter ?? (_) => true)
          .map((other) {
            if (object.aabb.intersectsWithAabb2(other.aabb)) {
              var response = getCollisionResponse(object.aabb, other.aabb);

              if (response.amount < 1e-6) {
                return null; //too small of a collision
              }

              return new CollisionPair(other, response);
            }
            return null;
          })
          .where((pair) => pair != null);
}
