//Object code
var entity = {
    all: [],
    create: function(x,y,type)
    {
        if (type == undefined) type = "undefined";
        var ent = {
            ID: "",
            X: x,
            Y: y,
            XSpeed: 0,
            YSpeed: 0,
            Type: type,
            update: function(dt)
            {
                switch (ent.Type)
                {
                  case "player": player.update(ent, dt); break;
                }
                for (var i = 0; i < 10; i += 1)
                {
                    var nextX = ent.X + (ent.XSpeed * dt);
                    if (world.get(Math.floor(nextX / 32), Math.floor(ent.Y / 32)) != "")
                    {
                        ent.XSpeed = 0;
                        break;
                    }
                    else
                    {
                        ent.X = nextX;
                    }
                }
                for (var i = 0; i < 10; i += 1)
                {
                    var nextY = ent.Y + (ent.YSpeed * dt);
                    if (world.get(Math.floor(ent.X / 32), Math.floor(nextY / 32)) != "")
                    {
                        ent.YSpeed = 0;
                        break;
                    }
                    else
                    {
                        ent.Y = nextY;
                    }
                }
            },
            draw: function()
            {
                switch (ent.Type)
                {
                  case "player": player.draw(ent); break;
                }
            },
            destroy: function()
            {
                entity.all.pop(ent);
            }
        };
        switch (type)
        {
          case "player": player.create(ent); break;
        }
        entity.all.push(ent);
        return ent;
    }
};