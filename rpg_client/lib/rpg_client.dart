library rpg_client;

import 'dart:async';
import 'dart:html';

import 'package:rpg_common/rpg_common.dart';

part 'render.dart';

part 'render/tile/generic.dart';
part 'render/world.dart';

part 'resource.dart';

class BrowserGame extends Game {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  bool focus = true;

  Camera camera = new Camera();

  BrowserGame(this.canvas) {
    context = canvas.context2D;

    start();

    window.onFocus.listen((ev) {
      if (!focus) {
        focus = true;
        window.requestAnimationFrame(loop);
      }
    });

    window.onBlur.listen((ev) => focus = false);

    window.onKeyDown.listen((kbev) {
      print(kbev);
      if (kbev.keyCode == KeyCode.UP) {
        camera.y -= 8;
      } else if (kbev.keyCode == KeyCode.DOWN) {
        camera.y += 8;
      }

      if (kbev.keyCode == KeyCode.LEFT) {
        camera.x -= 8;
      } else if (kbev.keyCode == KeyCode.RIGHT) {
        camera.x += 8;
      }
    });
  }

  void render() {
    // Render
    context.setTransform(1, 0, 0, 1, 0, 0);

    // Background
    context.fillStyle = "#000000";
    context.fillRect(0, 0, canvas.width, canvas.height);

    camera.applyTransform(canvas, context); // Move everything relative to the camera
    context.save();

    doRender(this, world);
    context.restore();

    for (var entity in entities) {
      doRender(this, entity);
      context.restore();
    }

    if (focus)
      window.requestAnimationFrame(loop);
  }
}
