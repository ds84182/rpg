var started = false;
var canvas = document.createElement("canvas");
var ctx = canvas.getContext("2d");
document.body.appendChild(canvas);

window.requestAnimFrame = ( function() {
    return window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    function( callback ) {
        window.setTimeout( callback, 1000 / 60 );
    };
})();

var lastTime;
function loop()
{
    var now = Date.now();
    var dt = (now - lastTime) / 1000.0;

    //Update
    world.update(dt);
    for(var i=0;i<entity.all.length;i+=1)
    {
        var ent = entity.all[i];
        ent.update(dt);
    }
    
    //Render
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    //Background
    ctx.fillStyle = "#000000";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    camera.applyTransform(); //Move everything relative to camera
    ctx.save();
    world.draw();
    ctx.restore();
    for(var i=0;i<entity.all.length;i+=1)
    {
        var ent = entity.all[i];
        ent.draw(dt);
        ctx.restore();
    }

    lastTime = now;
    requestAnimFrame(loop);
}

function start()
{
    if (!started)
    {
        started = true;

        //Add base entities
        world.clear(500, 500);
        world.generate();
        entity.create(48,48,"player");
        
        //Auto resizing
        //window.addEventListener('resize', resizeCanvas, false);
        resizeCanvas();
        
        //Begin loop
        lastTime = Date.now();
        loop();
    }
}

function resizeCanvas()
{
    canvas.width = 800;//window.innerWidth - 2;
    canvas.height = 600;//window.innerHeight - 2;
}

// Camera
var camera = {
    X: 0,
    Y: 0,
    Angle: 0,
    applyTransform: function()
    {
        //ctx.rotate((360-camera.Angle)*Math.PI/180);
        ctx.translate(-Math.round(camera.X - (canvas.width * 0.5)), -Math.round(camera.Y - (canvas.height * 0.5)));
    }
};

onload = function() { start(); }