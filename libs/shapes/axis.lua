axis = { _type = "shape", _shape = "axis", _padding = 20 }
axis.__index = axis

function axis:new()
    local object = setmetatable({}, axis)
    return object
end

function axis:draw(w, h)
    local cw, ch = w / 2, h / 2;
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(.9, .9, .9)
    local yex, yey = cw, self._padding
    local xex, xey = w - self._padding, ch
    love.graphics.line(yex, yey, cw, h - self._padding)
    love.graphics.line(self._padding, ch, xex, xey)
    love.graphics.polygon("fill", yex - 8, yey + 10, yex + 8, yey + 10, yex, yey - 10)
    love.graphics.polygon("fill", xex - 10, xey - 8, xex - 10, xey + 8, xex + 10, xey)
    love.graphics.setColor(r, g, b, a)
end

function axis:moved(x, y, dx, dy, istouch)
    return false
end

function axis:released(x, y, button, istouch, presses)
end

function axis:pressed(x, y, button, istouch, presses)
end

return axis