widget = require("libs.widget")
event = require("libs.event")

scene = {}
widgets = {}

function scene.init()
    loadingFromTimer = 0
end

function scene.menu()
    widgets = {
        widget.button(-100, 200, "目录", event.load, scene),
        widget.button(100, 200, "退出", event.exit)
    }
end

TIMER = 30
loadingFromTimer = TIMER
loadingToTimer = TIMER

function scene.draw()
    w, h = love.graphics.getDimensions()
    if loadingFromTimer > 0 then
        love.graphics.setColor(0, 0, 0, 1 - (loadingFromTimer / TIMER))
        love.graphics.rectangle("fill", 0, 0, w, h)
        loadingFromTimer = loadingFromTimer - 1
        return
    end
    love.graphics.setColor(1, 1, 1)
    widget.draw(widgets)
    if loadingToTimer > 0 then
        love.graphics.setColor(0, 0, 0, loadingToTimer / TIMER)
        love.graphics.rectangle("fill", 0, 0, w, h)
        loadingToTimer = loadingToTimer - 1
    end
end

function scene.widgets()
    return widgets
end

function scene.load()
    loadingFromTimer = TIMER
    loadingToTimer = TIMER
end

return scene