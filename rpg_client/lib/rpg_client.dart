library rpg_client;

import 'dart:async';
import 'dart:html';

import 'package:rpg_common/rpg_common.dart';
import 'package:vector_math/vector_math.dart';

part 'render.dart';

part 'render/tile/generic.dart';
part 'render/world.dart';

part 'resource.dart';

class BrowserGame extends Game {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  bool focus = true;

  Camera camera = new Camera();

  TestEntity testEnt1;
  TestEntity testEnt2;

  BrowserGame(this.canvas) {
    context = canvas.context2D;

    start().then((_) {
      addEntity(testEnt1 = new TestEntity(this, 64.0, 64.0)..anchored=true);
      addEntity(testEnt2 = new TestEntity(this, 80.0, 80.0));
    });

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

    canvas.onMouseUp.listen((mev) {
      print(mev.offset);

      // transform by camera matrix
      var canvasPoint = camera.transformPoint(canvas, mev.offset);
      print(canvasPoint);

      addEntity(new TestEntity(this, canvasPoint.x.toDouble(), canvasPoint.y.toDouble()));
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
