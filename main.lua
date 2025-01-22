win = require("libs.window")
scene = require("libs.scene")
suits = require("libs.suits")
ui2ds = require("libs.ui2ds")

function love.load()
    imgBg = love.graphics.newImage("images/bg.png")
    love.graphics.setFont(love.graphics.newFont("ui.ttf", 34))
    love.graphics.setDefaultFilter("linear", "linear", 1)
    -- UI2D初始化
    ui2ds.init()
    -- 加载场景
    scene.start("ui2d_list")
end

function love.resize(w, h)
    if scene.name == "cs" then
        win.resize(imgBg, w, h)
        scene.draw()
    elseif scene.name == "suit" then
        suits.draw()
    elseif scene.name == "ui2d" then
        UI2D.RenderFrame()
    end
end

function love.update()
    UI2D.InputInfo()
    if scene.name == "suit" then
        suits[scene.now]()
    end
end

function love.draw()
    if scene.name == "cs" then
        win.resize(imgBg)
        scene.draw()
    elseif scene.name == "suit" then
        win.suit()
        suits.draw()
    elseif scene.name == "ui2d" then
        win.ui2d()
        ui2ds.draw(scene.now)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if scene.name == "cs" then
        for index, value in ipairs(scene.widgets()) do
            value:pressed(x, y, button, istouch, presses)
        end
    elseif scene.name == "ui2d" then
        ui2ds.mousepressed(x, y, button, istouch, presses)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if scene.name == "cs" then
        for index, value in ipairs(scene.widgets()) do
            value:released(x, y, button, istouch, presses)
        end
    elseif scene.name == "ui2d" then
        ui2ds.mousereleased(x, y, button, istouch, presses)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if scene.name == "sc" then
        for index, value in ipairs(scene.widgets()) do
            if value:moved(x, y, dx, dy, istouch) then
                love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
                return
            else
                love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
            end
        end
    elseif scene.name == "ui2d" then
        ui2ds.mousemoved(x, y, dx, dy, istouch)
    end
end

function love.keypressed( key, scancode, isrepeat )
	ui2ds.keypressed( key, isrepeat, isrepeat )
end

function love.textinput( text )
	ui2ds.textinput( text )
end

function love.keyreleased( key, scancode )
	ui2ds.keyreleased( key, scancode )
end

function love.wheelmoved( x, y )
	ui2ds.wheelmoved( x, y )
end