win = require("libs.window")
scene = require("libs.scene")

widgets = {}

function love.load()
    imgBg = love.graphics.newImage("images/bg.png")
    love.graphics.setFont(love.graphics.newFont("ui.ttf", 34))
    -- 初始化场景
    scene.init()
    -- 加载场景
    scene.menu()
end

function love.resize(w, h)
    win.resize(imgBg, w, h)
end

function love.draw()
    win.resize(imgBg)
    scene.draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(scene.widgets()) do
        if value.state == 'a' and button == 1 then
            value.state = 't'
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    for index, value in ipairs(scene.widgets()) do
        if value.state == 't' and button == 1 then
            value.state = 'a'
            if value._type == 'button' then
                value.action(value.arg)
            end
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    for index, value in ipairs(scene.widgets()) do
        local rx, ry = value.x + value._w, value.y + value._h
        if x >= value.x and x <= rx and y >= value.y and y <= ry then
            love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
            if love.mouse.isDown(1) then
                value.state = 't'
            else
                value.state = 'a'
            end
            return
        else
            love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
            value.state = 'd'
        end
    end
end