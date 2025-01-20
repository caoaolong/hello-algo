tb = require("utils.table")

array = { 
    _type = "array", _cell = 50, _space = 2,
    _default_color = {0, .4, .4}, 
    _active_color = {.06, .66, .7},
    _drag_color = {0, .6, .3},
    _drop_color = {1, .2, .2},
    _right_color = {.6, .6, 0},
    drag = nil, drop = nil, draging = {},
    moving = false, timer = 0, _timer = 0, mns = {}, as = 1,
    _order = "lt"
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
            x = 0, y = 0, tx = 0, ty = 0, _x = 0, _y = 0, _tx = 0, _ty = 0,
            text = text, value = value, state = "d", right = false
        })
    end
    return object
end

function array:drawarray(cw, ch, f)
    for index, value in ipairs(self.nodes) do
        if value == self.drag or value == self.drop or tb.contains(self.mns, value) then
            goto continue
        end
        if index > 1 then
            local last = self.nodes[index - 1]
            last.right = self:compare(last, value)
            value.right = last.right
        end
        value.x, value.y = cw + (index - 1) * (self._cell + self._space), ch
        value._x, value._y = value.x, value.y
        value.tx, value.ty = (self._cell - f:getWidth(value.text)) / 2 + value.x, (self._cell - f:getHeight(value.text)) / 2 + value.y
        value._tx, value._ty = value.tx, value.ty
        local color = nil
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
        self:drawcell(color, value)
        ::continue::
    end
end

function array:drawdrag(f)
    if self.drag ~= nil then
        local value = self.drag
        value.tx, value.ty = (self._cell - f:getWidth(value.text)) / 2 + value.x, (self._cell - f:getHeight(value.text)) / 2 + value.y
        self:drawcell(self._drag_color, value)
    end
end

function array:drawanim()
    if self.moving then
        -- 处理动画
        local src = self.mns[1]
        local dst = self.mns[2]
        local ts = self._timer - self.timer
        if self.as == 1 then
            src.x = src._x
            src.tx = src._tx
            src.y = src._y + (self._cell / self._timer * ts)
            src.ty = src._ty + (self._cell / self._timer * ts)
            dst.x = dst._x
            dst.tx = dst._tx
            dst.y = dst._y - (self._cell / self._timer * ts)
            dst.ty = dst._ty - (self._cell / self._timer * ts)
            if self.timer == 0 then
                src._y, dst._y = src.y, dst.y
                src._ty, dst._ty = src.ty, dst.ty
                self.as = 2
                self.timer = self._timer
            else
                self.timer = self.timer - 2
            end
        elseif self.as == 2 then
            src.x = src._x + ((dst._x - src._x) / self._timer * ts)
            src.tx = src._tx + ((dst._tx - src._tx) / self._timer * ts)
            dst.x = dst._x + ((src._x - dst._x) / self._timer * ts)
            dst.tx = dst._tx + ((src._tx - dst._tx) / self._timer * ts)
            if self.timer == 0 then
                dst._x, src._x = src._x, dst._x
                dst._tx, src._tx = src._tx, dst._tx
                self.as = 3
                self.timer = self._timer
            else
                self.timer = self.timer - 1
            end
        elseif self.as == 3 then
            src.x = src._x
            src.tx = src._tx
            src.y = src._y - (self._cell / self._timer * ts)
            src.ty = src._ty - (self._cell / self._timer * ts)
            dst.x = dst._x
            dst.tx = dst._tx
            dst.y = dst._y + (self._cell / self._timer * ts)
            dst.ty = dst._ty + (self._cell / self._timer * ts)
            if self.timer == 0 then
                self.as = 1
                self:doswap()
                self.moving = false
                self.timer = self._timer
                self.mns = {}
            else
                self.timer = self.timer - 2
            end
        end
        self:drawcell(self._active_color, src)
        self:drawcell(self._active_color, dst)
    end
end

function array:drawcell(color, value)
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("fill", value.x, value.y, self._cell, self._cell)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(value.text, value.tx, value.ty)
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
        local ly = (h - lh) * 0.4
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
    -- 显示移动中的节点
    self:drawanim()
    -- 显示选择的节点
    self:drawdrag(f)
    -- 显示提示信息
    self:drawtooltip(w, h, f)
    -- 显示日志
    self:drawlogs(w, h, f)

    love.graphics.setColor(r, g, b, a)
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

function array:create()
    self:clear()
    math.randomseed(os.time())
    local f = love.graphics.getFont()
    for i = 1, 10 do
        local value = math.random(1, 100)
        local text = value
        if f:getWidth(text) > self._cell then
            text = "..."
        end
        table.insert(self.nodes, {
            x = 0, y = 0, tx = 0, ty = 0,
            text = text, value = value, state = "d", right = false
        })
    end
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

function array:doswap()
    local dragIndex, dropIndex = 0, 0
    print(self.nodes)
    for index, value in ipairs(self.nodes) do
        if value == self.mns[1] then
            dragIndex = index
        end
        if value == self.mns[2] then
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

function array:swap()
    self.moving = true
    self._timer = math.abs(self.drag._x - self.drop._x) / 2
    self.timer = self._timer
end

function array:mousereleased(x, y, button, istouch, presses)
    if self.drag ~= nil and self.drop ~= nil then
        table.insert(self.mns, self.drag)
        table.insert(self.mns, self.drop)
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