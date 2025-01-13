widget = require("libs.widget")
event = require("libs.event")

scene = {}
widgets = {}

function scene.init()
    loadingFromTimer = 0
end

function scene.start(s)
    if s == "menu" then
        widgets = {
            widget.button(-100, 200, "目录", event.load, scene, "contents"),
            widget.button(100, 200, "退出", event.exit)
        }
    elseif s == "contents" then
        local table = widget.table(100, 3, 10, 22)
        local json = require("utils.dkjson")
        local file = love.filesystem.newFile("data/contents.json")
        local data, pos, err = json.decode(file:read(), 1, nil)
        if err then
            love.window.showMessageBox("提示", err, "error", true)
            love.event.quit()
            return
        end
        for index, value in ipairs(data) do
            local r, c = math.floor(index / table.cs), index % table.cs - 1
            table:add(r, c, widget.button(0, 0, index .. "." .. value.name, event.load, scene, value.scene))
        end
        widgets = { table }
    end
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