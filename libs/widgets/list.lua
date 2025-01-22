list = {
    _type = "list", _radius = 28,
    _default_color = {0, .4, .4}, 
    _active_color = {.06, .66, .7},
    _select_color = {0, .6, .3},
    _drag_color = {1, .2, .2}
}
list.__index = list

function list:new()
    local object = setmetatable({
        nodes = {}
    }, list)
    object:reset()
    return object
end

function list:append(v)

end

function list:reset()
    table.insert(self.nodes, {
        text = "Null", value = nil,
        x = 0, y = 0, _x = 0, _y = 0,
        tx = 0, ty = 0, _tx = 0, _ty = 0,
        active = false, select = true, draging = false
    })
    local w, h = love.graphics.getDimensions()
    local cw, ch = w / 2, h / 2
    for index, value in ipairs(self.nodes) do 
        value._x, value._y = cw, ch
    end
end

function list:draw(w, h)
    local r, g, b, a = love.graphics.getColor()
    local f = love.graphics.getFont()
    for index, value in ipairs(self.nodes) do
        if not value.draging then
            value.x, value.y = value._x, value._y
        end
        local color = self._default_color
        if value.select then
            color = self._select_color
        end
        if value.active then
            color = self._active_color
        end
        if value.draging then
            color = self._drag_color
        end
        love.graphics.setColor(color[1], color[2], color[3])
        love.graphics.circle("fill", value.x, value.y, self._radius, 100)
        love.graphics.setColor(1, 1, 1)
        local tw, th = f:getWidth(value.text), f:getHeight(value.text)
        value.tx, value.ty = value.x - tw / 2, value.y - th / 2
        value._tx, value._ty = value.tx, value.ty
        love.graphics.print(value.text, value.tx, value.ty)
    end
    love.graphics.setColor(r, g, b, a)
end

function list:mousereleased(x, y, button, istouch, presses)
    for index, value in ipairs(self.nodes) do
        value.draging = false
        value._x, value._y = value.x, value.y
    end
end

function list:mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(self.nodes) do
        local d = math.sqrt((x - value.x)^2 + (y - value.y)^2)
        if value.active then
            value.draging = d <= self._radius
        end
    end
end

function list:mousemoved(x, y, dx, dy, istouch)
    for index, value in ipairs(self.nodes) do
        local d = math.sqrt((x - value.x)^2 + (y - value.y)^2)
        value.active = d <= self._radius
        if value.draging then
            value.x = value.x + dx
            value.y = value.y + dy
        end
    end
end

return list