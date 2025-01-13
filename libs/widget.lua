widget = {}

-- state: d: default; a: active; t: touch
function widget.button(x, y, label, action, arg, value)
    local button = require("libs.widgets.button")
    local object = button:new(label, x, y, {
        action = action, arg = arg, value = value
    })
    return object
end

function widget.box(color, x, y, w, h, r)
    if x == nil or y == nil then
        x, y = 0, 0
    end
    if w == nil or h == nil then
        w, h = love.graphics.getDimensions()
    end
    if r == nil then
        r = 8
    end
    local box = {
        _type = "box",
        _x = x, _y = y, _w = w, _h = h, _r = r, _c = color
    }
    return box
end

function widget.table(padding, cs, rs, fs)
    local table = require("libs.widgets.table")
    local w, h = love.graphics.getDimensions()
    local object = table:new(padding, cs, rs, fs)
    return object
end

function widget.draw(widgets)
    local w, h = love.graphics.getDimensions()
    local font = love.graphics.getFont()
    for index, value in ipairs(widgets) do
        value:draw()
    end
end

return widget