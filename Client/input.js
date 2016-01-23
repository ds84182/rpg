(function() {
    var pressedKeys = {};
    var cursorX = 0;
    var cursorY = 0;
    var mouseDown = false;

    function setKey(event, status) {
        var code = event.keyCode;
        var key;

        switch(code) {
        case 32:
            key = 'SPACE'; break;
        case 37:
            key = 'LEFT'; break;
        case 38:
            key = 'UP'; break;
        case 39:
            key = 'RIGHT'; break;
        case 40:
            key = 'DOWN'; break;
        default:
            // Convert ASCII codes to letters
            key = String.fromCharCode(code);
        }

        pressedKeys[key] = status;
    }

    document.addEventListener('keydown', function(e) {
        setKey(e, true);
    });

    document.addEventListener('keyup', function(e) {
        setKey(e, false);
    });

    window.addEventListener('blur', function() {
        pressedKeys = {};
        window.input.mouseDown = false;
    });
    
    document.addEventListener('mousemove', function(e)
    {
        window.input.cursorX = e.pageX;
        window.input.cursorY = e.pageY;
    });
    document.oncontextmenu = function()
    {
        return false;
    }
    $(document).mousedown(function(event)
    { 
        if (event.which == 1) window.input.mouseLeft = true;
        if (event.which == 3) window.input.mouseRight = true;
    });
    $(document).mouseup(function(event)
    { 
        if (event.which == 1) window.input.mouseLeft = false;
        if (event.which == 3) window.input.mouseRight = false;
    });

    window.input = {
        isDown: function(key) {
            return pressedKeys[key.toUpperCase()];
        },
        clearKeys: function()
        {
            pressedKeys = {};
        },
        cursorX: 0,
        cursorY: 0,
        mouseLeft: false,
        mouseRight: false
    };
})();