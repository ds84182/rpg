part of rpg_client;

typedef void RenderFunc(BrowserGame game, object);

Map<Type, RenderFunc> renderers = {
  World: RenderWorld,

  TestEntity: (BrowserGame game, TestEntity entity) {
    game.context.fillStyle = "red";
    var hwidth = entity.width/2;
    var hheight = entity.height/2;
    game.context.fillRect(entity.x-hwidth, entity.y-hheight, entity.width, entity.height);
  },
};

void doRender(BrowserGame game, object) {
  var renderer = renderers[object.runtimeType];

  if (renderer != null) {
    renderer(game, object);
  }
}

class Camera {
  num x = 0, y = 0, angle = 0;

  applyTransform(CanvasElement canvas, CanvasRenderingContext2D ctx) {
    ctx.translate(-(x - (canvas.width * 0.5)).round(), -(y - (canvas.height * 0.5)).round());
  }
}
