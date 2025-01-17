-- centr: cc: 中心; lb: 左下
axis = { 
    _type = "shape", 
    _shape = "axis", 
    _padding = 20; _center = "cc",
    _rw = 1, _rh = 1
}
axis.__index = axis

function axis:new(center)
    local object = setmetatable({
        _center = center or "cc"
    }, axis)
    return object
end

function axis:draw(w, h)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(.9, .9, .9)
    local yex, yey, xex, xey = 0, 0, 0, 0
    if self._center == "cc" then
        local cw, ch = w / 2, h / 2;
        yex, yey, xex, xey = cw, self._padding, w - self._padding, ch
        love.graphics.line(yex, yey, cw, h - self._padding)
        love.graphics.line(self._padding, ch, xex, xey)
    elseif self._center == "lb" then
        yex, yey, xex, xey = self._padding, self._padding, w - self._padding, h - self._padding
        love.graphics.line(self._padding, h - self._padding, yex, yey)
        love.graphics.line(self._padding, h - self._padding, xex, xey)
    end
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