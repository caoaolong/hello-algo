widget = require("libs.widget")
event = require("libs.event")
strings = require("utils.string")
TIMER = 30

scene = { lft = 0, ltt = TIMER, children = {}, name = "cs", now = "" }

function scene.start(s)
    scene.now = s
    if s == "menu" then
        scene.children = {
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
            local idx = index - 1
            local r, c = math.floor(idx / table.cs), idx % table.cs
            table:add(r, c, widget.button(0, 0, index .. "." .. value.name, event.load, scene, value.scene))
        end
        scene.children = { table }
    elseif strings.startsWith(s, "suit_") then
        scene.name = "suit"
        scene.now = string.gsub(s, "suit_", "")
        love.graphics.setFont(love.graphics.newFont("ui.ttf", 18))
    elseif strings.startsWith(s, "ui2d_") then
        scene.name = "ui2d"
        scene.now = string.gsub(s, "ui2d_", "")
    end
end

function scene.draw()
    w, h = love.graphics.getDimensions()
    if scene.lft > 0 then
        love.graphics.setColor(.18, .18, .18, 1 - (scene.lft / TIMER))
        love.graphics.rectangle("fill", 0, 0, w, h)
        scene.lft = scene.lft - 1
        return
    end
    love.graphics.setColor(1, 1, 1)
    widget.draw(scene.children, w, h)
    if scene.ltt > 0 then
        love.graphics.setColor(.18, .18, .18, scene.ltt / TIMER)
        love.graphics.rectangle("fill", 0, 0, w, h)
        scene.ltt = scene.ltt - 1
    end
end

function scene.widgets()
    return scene.children
end

function scene.load()
    scene.lft = TIMER
    scene.ltt = TIMER
end

return scene