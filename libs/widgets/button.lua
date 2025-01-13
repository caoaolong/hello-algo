button = {
    _type = "button", _w = 160, _h = 50, _r = 8, state = 'd',
    _x = 0, _y = 0
}
button.__index = button

DEFBC = { 0, .18, .36 }
DEFTC = { .7, .7, .7 }
ACTTC = { 1, 1, 1 }
TCHTC = { 0, .48, .96 }

function button:new(label, x, y, event)
    local object = setmetatable({
        font = love.graphics.getFont(),
        x = x, y = y, 
        action = event.action, arg = event.arg, value = event.value,
        _label = label
    }, button)
    return object
end

function button:draw(bx, by, tx, ty, bw, bh)
    bw = bw or self._w
    bh = bh or self._h
    if bx == nil or by == nil or tx == nil or ty == nil then
        -- 计算按钮坐标
        local cx, cy = (w - self._w) / 2, (h - self._h) / 2
        bx, by = cx + self.x, cy + self.y
        -- 计算文字坐标
        cx, cy = (w - self.font:getWidth(self._label)) / 2, (h - self.font:getHeight(self._label)) / 2
        tx, ty = cx + self.x, cy + self.y
        -- 更新按钮的屏幕坐标
        self._x, self._y = bx, by
    end
    -- 绘制按钮
    local color = nil
    if self.state == 'd' then
        color = DEFTC
    elseif self.state == 'a' then
        color = ACTTC
    elseif self.state == 't' then
        color = TCHTC
    end

    love.graphics.setColor(DEFBC[1], DEFBC[2], DEFBC[3])
    love.graphics.rectangle("fill", bx, by, bw, bh, self._r)
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("line", bx, by, bw, bh, self._r)
    love.graphics.print(self._label, tx, ty)
end

return button