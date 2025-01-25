tb = require("utils.table")
node = require("libs.widgets.node")

array = { 
    _type = "array", _cell = 50, _space = 2,
    _default_color = {0, .4, .4}, 
    _active_color = {.06, .66, .7},
    _drag_color = {0, .6, .3},
    _drop_color = {1, .2, .2},
    _right_color = {.6, .6, 0},
    drag = nil, drop = nil, draging = {},
    moving = false, timer = 0, _timer = 0, mns = {}, as = 1, size = 5,
    _order = "lt"
}
array.__index = array

function array:new(...)
    local w, h = love.graphics.getDimensions()
    local f = love.graphics.getFont()
    local object = setmetatable({
        tooltip = nil, nodes = {}, logs = {}, defaults = {...}
    }, array)
    object:reset()
    return object
end

function array:drawarray(cw, ch, f)
    for index, value in ipairs(self.nodes) do
        if value == self.drag or tb.contains(self.mns, value) then
            goto continue
        end
        if index > 1 then
            local last = self.nodes[index - 1]
            local r = self:compare(last, value)
            if r and last._right then
                value:correct()
            else
                value:wrong()
            end
        else
            value:correct()
        end
        value.x, value.y = cw + (index - 1) * (self._cell + self._space), ch
        value:draw(f)
        ::continue::
    end
end

function array:drawdrag(f)
    if self.drag ~= nil then
        local value = self.drag
        value:draw(f)
    end
end

function array:drawtooltip(w, h, f)
    if self.tooltip ~= nil then
        love.graphics.setColor(1, 1, 1)
        local tw, th = f:getWidth(self.tooltip), f:getHeight(self.tooltip)
        love.graphics.print(self.tooltip, w - tw - 10, h - th - 10)
    end
end

function array:drawlogs(w, h, f)
    for index, value in ipairs(self.logs) do
        local lw, lh = f:getWidth(value), f:getHeight(value)
        local ly = (h - lh) * 0.35
        if index == 1 then
            love.graphics.print("┌──────┬────────────────────┬────────────────────┐", (w - lw) / 2, ly + (index - 3) * lh)
            love.graphics.print("│ Opt  │       From         │         To         │", (w - lw) / 2, ly + (index - 2) * lh)
            love.graphics.print("├──────┼────────────────────┼────────────────────┤", (w - lw) / 2, ly + (index - 1) * lh)
        end
        love.graphics.print(value, (w - lw) / 2, ly + (index * 2 - 1) * lh)
        if index == #self.logs then
            love.graphics.print("└──────┴────────────────────┴────────────────────┘", (w - lw) / 2, ly + index * 2 * lh)
        else
            love.graphics.print("├──────┴────────────────────┴────────────────────┤", (w - lw) / 2, ly + index * 2 * lh)
        end
    end
end

function array:draw(w, h)
    local r, g, b, a = love.graphics.getColor()
    local f = love.graphics.getFont()
    local tw, th = #self.nodes * (self._cell + self._space) - self._space, self._cell + self._space
    local cw, ch = (w - tw) / 2, (h - th) * 0.2

    -- 显示数组元素
    self:drawarray(cw, ch, f)
    -- 显示选择的节点
    self:drawdrag(f)
    -- 显示提示信息
    self:drawtooltip(w, h, f)
    -- 显示日志
    self:drawlogs(w, h, f)

    love.graphics.setColor(r, g, b, a)
end

function array:reset()
    self:clear()
    local f = love.graphics.getFont()
    for index, value in ipairs(self.defaults) do
        local tw, th = f:getWidth(value), f:getHeight(value)
        local text = value
        if tw > self._cell then
            text = "..."
        end
        table.insert(self.nodes, node:new("rect", self._cell, self._cell, value, text))
    end
end

function array:clear()
    self.nodes = {}
    self.logs = {}
end

function array:order(type)
    if type == "lt" or type == "gt" then
        self._order = type
    end
end

function array:compare(v1, v2)
    if self._order == "lt" then
        return v1.value < v2.value
    end

    if self._order == "gt" then
        return v1.value > v2.value
    end
end

function array:resize(size)
    self.size = size
end

function array:create()
    self:clear()
    math.randomseed(os.time())
    local f = love.graphics.getFont()
    local values = {}
    for i = 1, self.size do
        local value = math.random(1, 100)
        local text = value
        if f:getWidth(text) > self._cell then
            text = "..."
        end
        table.insert(values, value)
        table.insert(self.nodes, node:new("rect", self._cell, self._cell, value, text))
    end
    self.defaults = values
end

function array:mousemoved(x, y, dx, dy, istouch)
    self.tooltip = nil
    for index, value in ipairs(self.nodes) do
        if value:mousemoved(self, index, x, y, dx, dy) then
            self.tooltip = string.format("Index=%d,Value=%d", index - 1, value.value)
        end
    end
end

function array:mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(self.nodes) do
        self.drag = self.drag or value:mousepressed(x, y)
    end
end

function array:swap()
    local dragIndex, dropIndex = 0, 0
    for index, value in ipairs(self.nodes) do
        if value == self.drag then
            dragIndex = index
        end
        if value == self.drop then
            dropIndex = index
        end
    end
    if dragIndex > 0 and dropIndex > 0 then
        local lsz = #self.logs
        table.insert(self.logs, string.format("| Swap | %10d → [%3d] | %10d → [%3d] |", 
            self.nodes[dragIndex].value, dragIndex - 1, self.nodes[dropIndex].value, dropIndex - 1))
        if #self.logs > 12 then
            table.remove(self.logs, 2)
        end
        self.nodes[dragIndex], self.nodes[dropIndex] = self.nodes[dropIndex], self.nodes[dragIndex]
        self.drag:default()
        self.drag = nil
        self.drop:default()
        self.drop = nil
    end
end

function array:mousereleased(x, y, button, istouch, presses)
    for index, value in ipairs(self.nodes) do
        value:mousereleased(self, x, y)
    end
    if self.drag ~= nil and self.drop ~= nil then
        self:swap()
    elseif self.drag ~= nil and self.drop == nil then
        self.drag = nil
    end
end

return array