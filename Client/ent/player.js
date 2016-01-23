//Player entity code
var player = {
    create: function(ent)
    {
        ent.isLocal = true;
        ent.Controls = {
            Left: false,
            Right: false,
            Up: false,
            Down: false
        }
        ent.Sprite = "down";
    },
    update: function(ent, dt)
    {
        if (ent.isLocal)
        {
            ent.Controls.Left = input.isDown('LEFT') || input.isDown('a');
            ent.Controls.Right = input.isDown('RIGHT') || input.isDown('d');
            ent.Controls.Up = input.isDown('UP') || input.isDown('w');
            ent.Controls.Down = input.isDown('DOWN') || input.isDown('s');
            camera.X = ent.X;
            camera.Y = ent.Y;
        }
        
        if (ent.Controls.Left != ent.Controls.Right)
        {
            if (ent.Controls.Right) ent.XSpeed += 400 * dt;
            if (ent.Controls.Left) ent.XSpeed -= 400 * dt;
        }
        if (ent.Controls.Up != ent.Controls.Down)
        {
            if (ent.Controls.Down) ent.YSpeed += 400 * dt;
            if (ent.Controls.Up) ent.YSpeed -= 400 * dt;
        }
        
        if (Math.abs(ent.XSpeed) > Math.abs(ent.YSpeed))
        { 
            if (ent.XSpeed > 0) ent.Sprite = "right"; else ent.Sprite = "left";
        }
        else
        {
            if (ent.YSpeed > 0) ent.Sprite = "down"; else ent.Sprite = "up";
        }
        
        var vel = Math.pow(0.0000001, dt);
        ent.XSpeed *= vel;
        ent.YSpeed *= vel;
    },
    draw: function(ent)
    {
        var spr = resources.get("char/"+ent.Sprite+".png");
        if (spr)
        {
            ctx.translate(ent.X, ent.Y);
            ctx.drawImage(spr, -spr.width * 0.5, -spr.height * 0.5);
        }
    }
}