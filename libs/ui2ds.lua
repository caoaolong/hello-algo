UI2D = require("ui2d")
ui2ds = {}

function ui2ds.init()
    UI2D.Init("love")
end

function ui2ds.ac()
    UI2D.Begin( "First Window", 50, 200 )
    if UI2D.Button( "first button" ) then
        print( "from 1st button" )
    end
    UI2D.End()
    UI2D.RenderFrame()
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

return ui2ds