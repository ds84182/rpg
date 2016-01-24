// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library rpg_common.test;

import 'package:rpg_common/rpg_common.dart';
import 'package:test/test.dart';

void main() {
  group('Map2D Test', () {
    Map2D<int> map;
    const int MAP_SIZE = 32;

    setUp(() {
      map = new Map2D<int>(MAP_SIZE, MAP_SIZE);
    });

    test('Fill', () {
      map.fill(5);
      expect(map.get(0, 0), same(5));
    });

    test('Clear', () {
      map.clear();
      expect(map.get(0, 0), isNull);
    });

    test('MapInto', () {
      map.mapInto((x, y) => x);
      expect(map.get(MAP_SIZE-1, 0), same(MAP_SIZE-1));
    });

    test('ForEach', () {
      int i = 0;
      map.forEach((x, y, val) => i++);
      expect(i, same(MAP_SIZE*MAP_SIZE));
    });
  });
}
