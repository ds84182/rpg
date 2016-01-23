(function() {
    var resourceCache = {};
    var callbacks = [];
    var defaultImg = load("default.png");

    function load(url)
    {
        url = "spr/" + url;
        if(resourceCache[url] != undefined)
        {
            return resourceCache[url];
        }
        else
        {
            if (!isReady())
            {
                return false;
            }
            else
            {
                resourceCache[url] = false;
                console.log("Loading image: "+url);
                var img = new Image();
                img.onload = function()
                {
                    resourceCache[url] = img;
                    callbacks.forEach(function(func) { func(); });
                };
                img.onerror = function()
                {
                    resourceCache[url] = get("default.png");
                    console.warn("Error loading image: "+url);
                };
                img.src = url;
                return false;
            }
        }
        return false;
    }

    function get(url)
    {
        return load(url);
    }

    function isReady()
    {
        for(var k in resourceCache)
        {
            if(resourceCache.hasOwnProperty(k) && !resourceCache[k])
            {
                return false;
            }
        }
        return true;
    }

    function onReady(func)
    {
        callbacks.push(func);
    }
    
    //volume ranges from 0% to 100%
    function playSound(file,volume)
    {
        if (volume == undefined) volume = 100;
        
        file = "snd/" + file;
        var x = resourceCache[file];
        if (resourceCache[file])
        {
        }
        else
        {
            resourceCache[file] = false;
            console.log("Loading sound: "+file);
            x = document.createElement("audio");
            x.type = "audio/wav";
            x.src = file;
            x.onerror = function() { console.warn("Error loading sound"); }
            resourceCache[file] = x;
        }
        if (!x.paused) x.load();
        x.volume = volume * 0.01;
        x.play();
    }

    window.resources = { 
        load: load,
        get: get,
        onReady: onReady,
        isReady: isReady,
        resourceCache: resourceCache,
        playSound: playSound
    };
})();