ac = { widgets = {} }
ac.__index = ac

function ac.init()
    local array = require("libs.widgets.array")
    table.insert(ac.widgets, array:new(1, 2, 3, 4, 1212331))
end
-- 数据结构
function ac.draw()
    local w, h = love.graphics.getDimensions()
    for index, value in ipairs(ac.widgets) do
        value:draw(w, h)
    end
    UI2D.Begin( "Toolbar", 0, 0 )
    if UI2D.Button( "Next Step" ) then
        ac.widgets[1]:swap(1, 2)
    end
    if UI2D.Button( "Auto Play" ) then
        print( "from 1st button" )
    end
    UI2D.End()
    UI2D.RenderFrame()
end

function ac.mousemoved(x, y, dx, dy, istouch)
    for index, value in ipairs(ac.widgets) do
        value:mousemoved(x, y, dx, dy, istouch)
    end
end

return ac