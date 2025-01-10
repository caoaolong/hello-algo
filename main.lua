win = require("libs.window")
widget = require("libs.widget")

function love.load()
    imgBg = love.graphics.newImage("images/bg.png")
    print(imgBg)
end

function love.resize(w, h)
    win.resize(imgBg, w, h)
end

function love.draw()
    win.resize(imgBg)
    widget.button(0, 100, "目录")
end