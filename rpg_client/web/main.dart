// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:rpg_client/rpg_client.dart';

BrowserGame game;

void main() {
  game = new BrowserGame(querySelector("#canvas") as CanvasElement);
}
