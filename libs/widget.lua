widget = {}

FONT = love.graphics.newFont("ui.ttf", 34)
-- button size
BTNSZ = {
    w = 160,
    h = 50,
    r = 8
}

function widget.button(x, y, label)
    local w, h = love.graphics.getDimensions()
    local cx, cy = (w - BTNSZ.w) / 2, (h - BTNSZ.h) / 2
    love.graphics.rectangle("line", cx + x, cy + y, BTNSZ.w, BTNSZ.h, BTNSZ.r)
    love.graphics.setFont(FONT)
    cx, cy = (w - FONT:getWidth(label)) / 2, (h - FONT:getHeight(label)) / 2
    love.graphics.print(label, cx + x, cy + y)
end

return widget