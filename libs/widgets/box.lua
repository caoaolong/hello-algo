box = { _type = "box", _x = 0, _y = 0, _rw = 1, _rh = 1 }
box.__index = box

function box:new(w, h, color, x, y)
    local dw, dh = love.graphics.getDimensions()
    local object = setmetatable({
        _w = (w or 1) * dw, _h = (h or 1) * dh, 
        color = color or { .18, .18, .18 }, 
        _x = (x or 0) * dw, _y = (y or 0) * dh, 
        children = {}
    }, box)
    return object
end

function box:draw(w, h)
    self._w, self._h = w * self._rw, h * self._rh
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.rectangle("fill", self._x * self._rw, self._y * self._rh, self._w, self._h)
    love.graphics.setColor(r, g, b, a)
    for idx, value in ipairs(self.children) do
        value:draw(self._w, self._h)
    end
end

function box:add(widget)
    if widget._w == nil then
        widget._w = self._w
    end
    if widget._h == nil then
        widget._h = self._h
    end
    widget._rw = widget._w / self._w
    widget._rh = widget._h / self._h
    table.insert(self.children, widget)
end

function box:moved(x, y, dx, dy, istouch)
    return false
end

function box:released(x, y, button, istouch, presses)
end

function box:pressed(x, y, button, istouch, presses)
end

return box