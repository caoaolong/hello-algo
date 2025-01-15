win = require("libs.window")
scene = require("libs.scene")

widgets = {}

function love.load()
    imgBg = love.graphics.newImage("images/bg.png")
    love.graphics.setFont(love.graphics.newFont("ui.ttf", 34))
    -- 加载场景
    scene.start("ac")
end

function love.resize(w, h)
    win.resize(imgBg, w, h)
    scene.draw()
end

function love.draw()
    win.resize(imgBg)
    scene.draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    for index, value in ipairs(scene.widgets()) do
        value:pressed(x, y, button, istouch, presses)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    for index, value in ipairs(scene.widgets()) do
        value:released(x, y, button, istouch, presses)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    for index, value in ipairs(scene.widgets()) do
        if value:moved(x, y, dx, dy, istouch) then
            love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
            return
        else
            love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
        end
    end
end