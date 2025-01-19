-- d: 默认; s: swap动画; c:compare动画
array = { 
    _type = "array", _cell = 50, _space = 2, _state = "d",
    _default_color = {.03, .33, .35}, 
    _active_color = {.06, .66, .7},
    timelines = {}, timer = 200, ctimer = 0
}
array.__index = array

function array:new(...)
    local w, h = love.graphics.getDimensions()
    local f = love.graphics.getFont()
    local values = {...}
    local object = setmetatable({
        tooltip = nil, nodes = {}
    }, array)
    for index, value in ipairs(values) do
        local tw, th = f:getWidth(value), f:getHeight(value)
        local text = value
        if tw > self._cell then
            text = "..."
        end
        table.insert(object.nodes, {
            color = object._default_color,
            x = 0, y = 0, tx = 0, ty = 0,
            text = text, value = value
        })
    end
    return object
end

function array:compare(idx1, idx2)
    if idx1 < 0 or idx2 < 0 then
        return
    end
    self._state = "c"
end

function array:swap(idx1, idx2)
    if idx1 < 0 or idx2 < 0 then
        return
    end
    self._state = "s"
end

function array:draw(w, h)
    local r, g, b, a = love.graphics.getColor()
    local f = love.graphics.getFont()
    local tw, th = #self.nodes * (self._cell + self._space) - self._space, self._cell + self._space
    local cw, ch = (w - tw) / 2, (h - th) / 2
    if self._state == "s" or self._state == "c" then
        self.ctimer = self.ctimer + 1
        if self.ctimer >= self.timer then
            self.ctimer = 0
            self._state = "d"
        end
        print(self.ctimer .. "," .. self._state)
    end
    -- 显示数组元素
    for index, value in ipairs(self.nodes) do
        value.x, value.y = cw + (index - 1) * (self._cell + self._space), ch
        value.tx, value.ty = (self._cell - f:getWidth(value.text)) / 2 + value.x, (self._cell - f:getHeight(value.text)) / 2 + value.y
        love.graphics.setColor(value.color[1], value.color[2], value.color[3])
        love.graphics.rectangle("fill", value.x, value.y, self._cell, self._cell)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(value.text, value.tx, value.ty)
    end
    -- 显示提示信息
    if self.tooltip ~= nil then
        love.graphics.setColor(1, 1, 1)
        local tw, th = f:getWidth(self.tooltip), f:getHeight(self.tooltip)
        love.graphics.print(self.tooltip, w - tw - 10, h - th - 10)
    end
    love.graphics.setColor(r, g, b, a)
end

function array:mousemoved(x, y, dx, dy, istouch)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1)
    self.tooltip = nil
    if self._state == "d" then
        for index, value in ipairs(self.nodes) do
            value.color = self._default_color
            if x >= value.x and x <= value.x + self._cell and y >= value.y and y <= value.y + self._cell then
                value.color = self._active_color
                self.tooltip = string.format("Index=%d,Value=%d", index - 1, value.value)
            end
        end
    end
    love.graphics.setColor(r, g, b, a)
end

return array