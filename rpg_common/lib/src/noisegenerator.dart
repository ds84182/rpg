part of rpg_common;

class NoiseGenerator {
  double scale;
  int seedX;
  int seedY;

  Matrix2 matrix;
  Vector2 translation;

  NoiseGenerator(this.scale, this.seedX, this.seedY) {
    matrix = new Matrix2
        .rotation((seedX.toDouble()/2)*seedY.toDouble())
        .scale(scale);
    translation = new Vector2(seedX.toDouble()*scale, seedY.toDouble()*scale);
  }

  double get(double x, double y) {
    Vector2 vec = matrix.transform(new Vector2(x, y));
    vec += translation;

    return simplex2(vec.x, vec.y);
  }
}
