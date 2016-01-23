var world = {
    grid: [],
    clear: function(width, height)
    {
        world.grid = [];
        for (var xx = 0; xx < width; xx += 1)
        {
            world.grid[xx] = [];
            for (var yy = 0; yy < height; yy += 1)
            {
                world.grid[xx].push("");
            }
        }
    },
    generate: function()
    {
        var width = world.grid.length;
        var height = world.grid[0].length;
        
        //Make structures
        console.log("Making noise structures");
        for (var ii = 0; ii < 10; ii += 1)
        {
            //Generate noise
            for (var xx = 0; xx < width; xx += 1)
            {
                for (var yy = 0; yy < height; yy += 1)
                {
                    if (Math.random() < 0.25) world.set(xx,yy, "stone");
                }
            }
            
            //Smooth noise
            for (var iii = 0; iii < 200; iii += 1)
            {
                var changed = false;
                for (var xx = 0; xx < width; xx += 1)
                {
                    for (var yy = 0; yy < height; yy += 1)
                    {
                        if (world.get(xx,yy) == "stone")
                        {
                            var n = 0;
                            if (world.get(xx+1,yy) == "stone") n += 1;
                            if (world.get(xx-1,yy) == "stone") n += 1;
                            if (world.get(xx,yy+1) == "stone") n += 1;
                            if (world.get(xx,yy-1) == "stone") n += 1;
                            if (n <= 1)
                            {
                                world.set(xx, yy, "");
                                changed = true;
                            }
                        }
                    }
                }
                if (!changed) break;
            }
        }
        
        //Clear spawn area
        console.log("Clearing spawn area");
        for (var x = 0; x < 12; x += 1) for (var y = 0; y < 12; y += 1) world.set(x, y, "");
        
        
        //Fill inaccessable spaces
        console.log("Filling inaccessable spaces");
        var accessGrid = [];
        for (var xx = 0; xx < width; xx += 1)
        {
            accessGrid[xx] = [];
            for (var yy = 0; yy < height; yy += 1)
            {
                accessGrid[xx].push(false);
            }
        }
        //Mark spawn point as accessable
        accessGrid[1][1] = true;
        
        //Flood fill
        var ffi = 0;
        var space = 0;
        while (true)
        {
            var changed = false;
            for (var xx = 1; xx < width-1; xx += 1)
            {
                for (var yy = 1; yy < height-1; yy += 1)
                {
                    if (world.grid[xx][yy] == "")
                    {
                        if (accessGrid[xx][yy])
                        {
                            if (world.grid[xx-1][yy] == "") if (!accessGrid[xx-1][yy]) {accessGrid[xx-1][yy] = true;changed=true}
                            if (world.grid[xx+1][yy] == "") if (!accessGrid[xx+1][yy]) {accessGrid[xx+1][yy] = true;changed=true}
                            if (world.grid[xx][yy-1] == "") if (!accessGrid[xx][yy-1]) {accessGrid[xx][yy-1] = true;changed=true}
                            if (world.grid[xx][yy+1] == "") if (!accessGrid[xx][yy+1]) {accessGrid[xx][yy+1] = true;changed=true}
                        }
                    } else accessGrid[xx][yy] = false;
                }
            }
            ffi += 1;
            if (!changed) break;
        }
        console.log("Completed in "+ffi+" cycles");
        for (var xx = 1; xx < width-1; xx += 1)
        {
            for (var yy = 1; yy < height-1; yy += 1)
            {
                var aa = accessGrid[xx][yy];
                if (world.grid[xx][yy] == "")
                {
                    if (aa)
                        space += 1;
                    else
                        world.set(xx,yy,"stone");
                }
            }
        }
        console.log("Free space: "+space+" blocks");
    },
    get: function(x,y)
    {
        if (x >= 0 && x < world.grid.length && y >= 0)
        {
            var c = world.grid[x];
            if (y < c.length) return c[y];
        }
        return "";
    },
    set: function(x,y, block)
    {
        if (block == undefined) block = "";
        world.grid[x][y] = block;
    },
    update: function(dt)
    {
    },
    draw: function()
    {
        var startX = (camera.X - (canvas.width / 2)) / 32;
        var endX = (camera.X + (canvas.width / 2)) / 32;
        var startY = (camera.Y - (canvas.height / 2)) / 32;
        var endY = (camera.Y + (canvas.height / 2)) / 32;
        for (var xx = Math.floor(Math.max(startX, 0)); xx < Math.min(Math.ceil(endX), world.grid.length); xx += 1)
        {
            var column = world.grid[xx];
            if (column != undefined)
            {
                ctx.save();
                ctx.translate(xx * 32, Math.max(Math.floor(startY), 0) * 32);
                for (var yy = Math.max(Math.floor(startY), 0); yy < Math.min(Math.ceil(endY), column.length); yy += 1)
                {
                    var tile = column[yy];
                    if (tile != undefined)
                    {
                        var file = tile;
                        if (tile == "") file = "grass";
                        if (tile == "stone")
                        {
                            // the order of each character must be "nsew"
                            file = "outlines/stone_";
                            if (yy > 0 && world.grid[xx][yy-1] != "stone") file += "n";
                            if (yy < column.length - 1 && world.grid[xx][yy+1] != "stone") file += "s";
                            if (xx < world.grid.length - 1 && world.grid[xx+1][yy] != "stone") file += "e";
                            if (xx > 0 && world.grid[xx-1][yy] != "stone") file += "w";
                            if (file == "outlines/stone_") file = "stone";
                        }
                        var spr = resources.get("tile/"+file+".png");
                        if (spr)
                        {
                            ctx.drawImage(spr, 0, 0);
                        }
                    }
                    ctx.translate(0, 32);
                }
                ctx.restore();
            }
        }
    }
};