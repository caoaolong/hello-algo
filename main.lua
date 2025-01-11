win = require("libs.window")
widget = require("libs.widget")

widgets = {}

function love.load()
    imgBg = love.graphics.newImage("images/bg.png")
    love.graphics.setFont(love.graphics.newFont("ui.ttf", 34))
    -- 界面组件
    table.insert(widgets, widget.button(0, 100, "目录"))
end

function love.resize(w, h)
    win.resize(imgBg, w, h)
    widget.draw(widgets)
end

function love.draw()
    win.resize(imgBg)
    widget.draw(widgets)
end

function love.mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(widgets) do
        if value.state == 'a' and button == 1 then
            value.state = 't'
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    for index, value in ipairs(widgets) do
        if value.state == 't' and button == 1 then
            value.state = 'a'
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    for index, value in ipairs(widgets) do
        local rx, ry = value.x + value._w, value.y + value._h
        if x >= value.x and x <= rx and y >= value.y and y <= ry then
            love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
            value.state = 'a'
        else
            love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
            value.state = 'd'
        end
    end
end