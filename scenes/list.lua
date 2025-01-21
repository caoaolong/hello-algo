list_scene = { widgets = {} }
list_scene.__index = list_scene

function list_scene.init()
    local ls = require("libs.widgets.list")
    table.insert(list_scene.widgets, ls:new())
end
-- 数据结构
function list_scene.draw()
    local w, h = love.graphics.getDimensions()
    for index, value in ipairs(list_scene.widgets) do
        value:draw(w, h)
    end
    UI2D.Begin( "Toolbar", 0, 0 )
    if UI2D.Button( "  Reset  " ) then
    end
    UI2D.SameLine()
    if UI2D.Button( "  Append  " ) then
    end
    UI2D.End()
    UI2D.RenderFrame()
end

function list_scene.mousemoved(x, y, dx, dy, istouch)
    for index, value in ipairs(list_scene.widgets) do
        value:mousemoved(x, y, dx, dy, istouch)
    end
end

function list_scene.mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(list_scene.widgets) do
        value:mousepressed(x, y, button, istouch, presses)
    end
end

function list_scene.mousereleased(x, y, button, istouch, presses)
    for index, value in ipairs(list_scene.widgets) do
        value:mousereleased(x, y, button, istouch, presses)
    end
end

return list_scene