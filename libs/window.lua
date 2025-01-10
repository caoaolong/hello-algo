window = {}

function window.resize(bg, w, h)
    if w == nil or h == nil then
        w, h = love.graphics.getDimensions()
    end
    local iw, ih = bg:getWidth(), bg:getHeight()
    local rw, rh = w / iw, h / ih;
    love.graphics.draw(bg, 0, 0, 0, rw, rh)
end

return window