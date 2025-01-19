UI2D = require("ui2d")
scenes = require("scenes")
ui2ds = {
    sc = nil
}

function ui2ds.init()
    UI2D.Init("love")
end

function ui2ds.draw(name)
    ui2ds.sc = scenes[name]
    ui2ds.sc.draw()
end

function ui2ds.keypressed( key, scancode, isrepeat )
    UI2D.KeyPressed( key, isrepeat )
end

function ui2ds.textinput( text )
	UI2D.TextInput( text )
end

function ui2ds.keyreleased( key, scancode )
	UI2D.KeyReleased()
end

function ui2ds.wheelmoved( x, y )
	UI2D.WheelMoved( x, y )
end

function ui2ds.mousemoved(x, y, dx, dy, istouch)
    if ui2ds.sc ~= nil then
        ui2ds.sc.mousemoved(x, y, dx, dy, istouch)
    end
end

return ui2ds