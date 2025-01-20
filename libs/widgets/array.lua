array = { 
    _type = "array", _cell = 50, _space = 2,
    _default_color = {0, .4, .4}, 
    _active_color = {.06, .66, .7},
    _drag_color = {0, .6, .3},
    _drop_color = {1, .2, .2},
    _right_color = {.6, .6, 0},
    drag = nil, drop = nil, draging = {}
}
array.__index = array

function array:new(...)
    local w, h = love.graphics.getDimensions()
    local f = love.graphics.getFont()
    local values = {...}
    local object = setmetatable({
        tooltip = nil, nodes = {}, logs = {}
    }, array)
    for index, value in ipairs(values) do
        local tw, th = f:getWidth(value), f:getHeight(value)
        local text = value
        if tw > self._cell then
            text = "..."
        end
        table.insert(object.nodes, {
            x = 0, y = 0, tx = 0, ty = 0,
            text = text, value = value, state = "d", right = false
        })
    end
    return object
end

function array:dodraw(color, value)
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("fill", value.x, value.y, self._cell, self._cell)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(value.text, value.tx, value.ty)
end

function array:draw(w, h)
    local r, g, b, a = love.graphics.getColor()
    local f = love.graphics.getFont()
    local tw, th = #self.nodes * (self._cell + self._space) - self._space, self._cell + self._space
    local cw, ch = (w - tw) / 2, (h - th) * 0.2
    -- 显示数组元素
    for index, value in ipairs(self.nodes) do
        if value == self.drag then
            goto continue
        end
        if index > 1 then
            local last = self.nodes[index - 1]
            last.right = last.value > value.value
            value.right = last.right
        end
        local color = nil
        value.x, value.y = cw + (index - 1) * (self._cell + self._space), ch
        value.tx, value.ty = (self._cell - f:getWidth(value.text)) / 2 + value.x, (self._cell - f:getHeight(value.text)) / 2 + value.y
        if value.state == "s" then
            color = self._drag_color
        elseif value.state == "a" then
            color = self._active_color
        elseif value.state == "p" then
            color = self._drop_color
        else
            color = self._default_color
        end
        if value.right then
            color = self._right_color
        end
        self:dodraw(color, value)
        ::continue::
    end
    -- 显示选择的节点
    if self.drag ~= nil then
        local value = self.drag
        value.tx, value.ty = (self._cell - f:getWidth(value.text)) / 2 + value.x, (self._cell - f:getHeight(value.text)) / 2 + value.y
        color = self._drag_color
        self:dodraw(color, value)
    end
    -- 显示提示信息
    if self.tooltip ~= nil then
        love.graphics.setColor(1, 1, 1)
        local tw, th = f:getWidth(self.tooltip), f:getHeight(self.tooltip)
        love.graphics.print(self.tooltip, w - tw - 10, h - th - 10)
    end
    -- 显示日志
    
    for index, value in ipairs(self.logs) do
        
        local lw, lh = f:getWidth(value), f:getHeight(value)
        local ly = (h - lh) * 0.4
        if index == 1 then
            love.graphics.print("+------+--------------------+--------------------+", (w - lw) / 2, ly + (index - 3) * lh)
            love.graphics.print("| Opt  |       From         |         To         |", (w - lw) / 2, ly + (index - 2) * lh)
            love.graphics.print("+------+--------------------+--------------------+", (w - lw) / 2, ly + (index - 1) * lh)
        end
        love.graphics.print(value, (w - lw) / 2, ly + (index * 2 - 1) * lh)
        love.graphics.print("+------+--------------------+--------------------+", (w - lw) / 2, ly + index * 2 * lh)
    end
    love.graphics.setColor(r, g, b, a)
end

function array:mousemoved(x, y, dx, dy, istouch)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1)
    self.tooltip = nil
    for index, value in ipairs(self.nodes) do
        if x >= value.x and x <= value.x + self._cell and y >= value.y and y <= value.y + self._cell then
            if self.drag ~= nil and value ~= self.drag then
                value.state = "p"
                self.drop = value
            elseif value.state == "d" then
                value.state = "a"
            end
            self.tooltip = string.format("Index=%d,Value=%d", index - 1, value.value)
        elseif value.state ~= "r" then
            value.state = "d"
        end
    end
    if self.drag ~= nil then
        local value = self.drag
        value.x = value.x + dx
        value.y = value.y + dy
    end
    love.graphics.setColor(r, g, b, a)
end

function array:mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(self.nodes) do
        if x >= value.x and x <= value.x + self._cell and y >= value.y and y <= value.y + self._cell then
            value.state = "s"
            self.drag = value
        end
    end
end

function array:swap()
    local dragIndex, dropIndex = 0, 0
    for index, value in ipairs(self.nodes) do
        if value == self.drag then
            print(index)
            dragIndex = index
        end
        if value == self.drop then
            print(index)
            dropIndex = index
        end
    end
    local lsz = #self.logs
    table.insert(self.logs, string.format("| Swap | %10d → [%3d] | %10d → [%3d] |", 
        self.nodes[dragIndex].value, dragIndex - 1, self.nodes[dropIndex].value, dropIndex - 1))
    if #self.logs > 15 then
        table.remove(self.logs, 2)
    end
    self.nodes[dragIndex], self.nodes[dropIndex] = self.nodes[dropIndex], self.nodes[dragIndex]
end

function array:mousereleased(x, y, button, istouch, presses)
    if self.drag ~= nil and self.drop ~= nil then
        self:swap()
        self.drag.state = "d"
        self.drag = nil
        self.drop.state = "d"
        self.drop = nil
    elseif self.drag ~= nil and self.drop == nil then
        self.drag.state = "d"
        self.drag = nil
    end
end

return array