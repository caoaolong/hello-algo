box = { _type = "box", _x = 0, _y = 0 }
box.__index = box

function box:new(w, h, color, x, y)
    local dw, dh = love.graphics.getDimensions()
    w = w or dw
    h = h or dh
    x = x or self._x
    y = y or self._y
    x = x or 0
    y = y or x
    color = color or { .18, .18, .18 }
    local object = setmetatable({
        _w = w, _h = h, color = color, _x = x, _y = y
    }, box)
    return object
end

function box:draw(w, h)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    local rw, rh = w / self._w, h / self._h
    love.graphics.rectangle("fill", self._x, self._y, self._w * rw, self._h * rh)
    love.graphics.setColor(r, g, b, a)
end

function box:moved(x, y, dx, dy, istouch)
    return false
end

function box:released(x, y, button, istouch, presses)
end

function box:pressed(x, y, button, istouch, presses)
end

return box