widget = {}

-- state: d: default; a: active; t: touch
function widget.button(x, y, label, action, arg, value)
    local button = require("libs.widgets.button")
    local object = button:new(label, x, y, {
        action = action, arg = arg, value = value
    })
    return object
end

function widget.box(w, h, color, x, y)
    local box = require("libs.widgets.box")
    local object = box:new(w, h, color, x, y)
    return object
end

function widget.table(padding, cs, rs, fs)
    local table = require("libs.widgets.table")
    local w, h = love.graphics.getDimensions()
    local object = table:new(padding, cs, rs, fs)
    return object
end

function widget.draw(widgets, w, h)
    local font = love.graphics.getFont()
    for index, value in ipairs(widgets) do
        value:draw(w, h)
    end
end

return widget