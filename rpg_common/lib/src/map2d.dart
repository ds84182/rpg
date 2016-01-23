part of rpg_common;

class Map2D<T> {
  int width, height;
  List<T> contents;

  Map2D(this.width, this.height) {
    contents = new List<T>(width*height);
  }

  bool isInside(int x, int y) =>
      x >= 0 && y >= 0 && x < width && y < height;

  T get(int x, int y) =>
      contents[(y*width)+x];

  void set(int x, int y, T value) =>
      contents[(y*width)+x] = value;

  void forEach(void callback(int x, int y, T val)) {
    //TODO: Maybe faster if single loop with i, x, and y
    for (int x=0; x<width; x++) {
      for (int y=0; y<height; y++) {
        callback(x, y, get(x, y));
      }
    }
  }

  void mapInto(T callback(int x, int y)) {
    //TODO: Maybe faster if single loop with i, x, and y
    for (int x=0; x<width; x++) {
      for (int y=0; y<height; y++) {
        set(x, y, callback(x, y));
      }
    }
  }
}
