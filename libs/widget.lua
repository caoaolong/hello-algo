widget = {}
-- button size
BTNSZ = {
    w = 160,
    h = 50,
    r = 8
}

DEFBC = { 0, .18, .36 }
DEFTC = { .7, .7, .7 }
ACTTC = { 1, 1, 1 }
TCHTC = { 0, .48, .96 }

-- state: d: default; a: active; t: touch
function widget.button(x, y, label)
    button = { _type = "button", _x = x, _y = y, _w = BTNSZ.w, _h = BTNSZ.h, _label = label, x = 0, y = 0, state = 'd' }
    return button
end

function widget.draw(widgets)
    local w, h = love.graphics.getDimensions()
    local font = love.graphics.getFont()
    for index, value in ipairs(widgets) do
        if value._type == "button" then -- 绘制按钮
            widget.drawButton(button, font, w, h)
        end
    end
end

function widget.drawButton(button, font, w, h)
    -- 计算按钮坐标
    local cx, cy = (w - button._w) / 2, (h - button._h) / 2
    local bx, by = cx + button._x, cy + button._y
    -- 计算文字坐标
    cx, cy = (w - font:getWidth(button._label)) / 2, (h - font:getHeight(button._label)) / 2
    local tx, ty = cx + button._x, cy + button._y
    -- 更新按钮的屏幕坐标
    button.x, button.y = bx, by
    -- 绘制按钮
    local color = nil
    if button.state == 'd' then
        color = DEFTC
    elseif button.state == 'a' then
        color = ACTTC
    elseif button.state == 't' then
        color = TCHTC
    end
    love.graphics.setColor(DEFBC[1], DEFBC[2], DEFBC[3])
    love.graphics.rectangle("fill", bx, by, BTNSZ.w, BTNSZ.h, BTNSZ.r)
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("line", bx, by, BTNSZ.w, BTNSZ.h, BTNSZ.r)
    love.graphics.print(button._label, tx, ty)
end

return widget