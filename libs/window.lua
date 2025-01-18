window = {}

function window.resize(bg, w, h)
    if w == nil or h == nil then
        w, h = love.graphics.getDimensions()
    end
    local iw, ih = bg:getWidth(), bg:getHeight()
    local rw, rh = w / iw, h / ih;
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(bg, 0, 0, 0, rw, rh)
end

function window.suit()
    love.graphics.clear( .12, .12, .12 )
end

return window