node = {
    _default_color = {0, .4, .4}, 
    _active_color = {.06, .66, .7},
    _drag_color = {0, .6, .3},
    _drop_color = {1, .2, .2},
    _right_color = {.6, .6, 0},
    x = 0, y = 0, tx = 0, ty = 0, _x = 0, _y = 0, _tx = 0, _ty = 0, _w = 0, _h = 0,
    _right = false, _active = false, _select = false, _drag = false, _drop = false,
    anims = {}
}
node.__index = node

function node:new(shape, w, h, value, text)
    text = text or value
    local object = setmetatable({
        shape = shape, _w = w, _h = h, text = text, value = value
    }, node)
    return object
end

function node:default()
    self._right = false
    self._active = false
    self._select = false
    self._drag = false
    self._drop = false
end

function node:active()
    self._active = true
end

function node:inactive()
    self._active = false
end

function node:select()
    self._select = true
end

function node:unselect()
    self._select = false
end

function node:drag()
    self._drag = true
    self._drop = false
end

function node:drop()
    self._drag = false
    self._drop = true
end

function node:correct()
    self._right = true
end

function node:wrong()
    self._right = false
end

function node:draw(f)
    local color = self._default_color
    if self._active then
        color = self._active_color
    end
    if self._select then
        color = self._select_color
    end
    if self._right then
        color = self._right_color
    end
    if self._drag then
        color = self._drag_color
    end
    if self._drop then
        color = self._drop_color
    end
    love.graphics.setColor(color[1], color[2], color[3])
    if self.shape == "rect" then
        self._x, self._y = self.x, self.y
        love.graphics.rectangle("fill", self.x, self.y, self._w, self._h)
        love.graphics.setColor(1, 1, 1)
        self.tx, self.ty = (self._w - f:getWidth(self.text)) / 2 + self.x, (self._h - f:getHeight(self.text)) / 2 + self.y
        self._tx, self._ty = self.tx, self.ty
        love.graphics.print(self.text, self.tx, self.ty)
    elseif self.shape == "circle" then
        love.graphics.circle("fill", self.x, self.y, self.w, 100)
        love.graphics.setColor(1, 1, 1)
        local tw, th = f:getWidth(self.text), f:getHeight(self.text)
        self.tx, self.ty = self.x - tw / 2, self.y - th / 2
        self._tx, self._ty = self.tx, self.ty
        love.graphics.print(self.text, self.tx, self.ty)
    end
end

function node:isTouch(x, y)
    return x >= self.x and x <= self.x + self._w and y >= self.y and y <= self.y + self._h
end

function node:mousepressed(x, y)
    if self:isTouch(x, y) then
        self:drag()
        return self
    end
    return nil
end

function node:mousemoved(parent, index, x, y, dx, dy)
    if self._drag then
        self.x = self.x + dx
        self.y = self.y + dy
    end

    if self:isTouch(x, y) and parent.drag ~= nil and self ~= parent.drag then
        self:drop()
        return true
    else
        self._drop = false
    end
    return false
end

function node:mousereleased(parent, x, y)
    self._drag = false
    self._drop = false
    if self:isTouch(x, y) and self ~= parent.drag then
        parent.drop = self
    end
end

function node:moveup(d)
    
end

return node