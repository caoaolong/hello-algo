array_scene = { widgets = {}, order = "lt" }
array_scene.__index = array_scene

function array_scene.init()
    local ar = require("libs.widgets.array")
    table.insert(array_scene.widgets, ar:new(1, 2, 3, 4, 1212331))
end
-- 数据结构
function array_scene.draw()
    local w, h = love.graphics.getDimensions()
    for index, value in ipairs(array_scene.widgets) do
        value:draw(w, h)
    end
    UI2D.Begin( "Toolbar", 0, 0 )
    if UI2D.RadioButton("ASC ", array_scene.order == "lt", "Ascending") then
        array_scene.order = "lt"
    end
    UI2D.SameLine()
    if UI2D.RadioButton("DESC", array_scene.order == "gt", "Descending") then
        array_scene.order = "gt"
    end
    array_scene.widgets[1]:order(array_scene.order)
    if UI2D.Button( "  Clear  " ) then
        array_scene.widgets[1]:clear()
    end
    UI2D.SameLine()
    if UI2D.Button( "  Create  " ) then
        array_scene.widgets[1]:create()
    end
    UI2D.End()
    UI2D.RenderFrame()
end

function array_scene.mousemoved(x, y, dx, dy, istouch)
    for index, value in ipairs(array_scene.widgets) do
        value:mousemoved(x, y, dx, dy, istouch)
    end
end

function array_scene.mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(array_scene.widgets) do
        value:mousepressed(x, y, button, istouch, presses)
    end
end

function array_scene.mousereleased(x, y, button, istouch, presses)
    for index, value in ipairs(array_scene.widgets) do
        value:mousereleased(x, y, button, istouch, presses)
    end
end

return array_scene