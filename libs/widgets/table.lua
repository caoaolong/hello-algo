grid = { children = {}, _type = "table", spaceX = 10, spaceY = 5 }
grid.__index = grid

function grid:new(padding, cs, rs, fs)
    fs = fs or 18
    local object = setmetatable({}, grid)
    object.font = love.graphics.newFont("ui.ttf", fs)
    object.padding = padding
    object.cs = cs
    object.rs = rs
    return object
end

function grid:add(r, c, widget)
    table.insert(self.children, {
        column = c, row = r, widget = widget
    })
end

function grid:draw(w, h)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    local cw, ch = math.floor((w - 2 * self.padding) / self.cs), math.floor((h - 2 * self.padding) / self.rs)
    for index, value in ipairs(self.children) do
        if value.widget._type == "button" then
            local bx, by = self.padding + cw * value.column, self.padding + ch * value.row
            local tw, th = self.font:getWidth(value.widget._label), self.font:getHeight(value.widget._label)
            local tx, ty = (cw - tw) / 2, (ch - th) / 2;
            value.widget:draw(w, h, bx + self.spaceX, by + self.spaceY, bx + tx, by + ty, cw - 2 * self.spaceX, ch - 2 * self.spaceY)
        end
    end
    love.graphics.setFont(font)
end

function grid:moved(x, y, dx, dy, istouch)
    for idx, widget in ipairs(self.children) do
        if widget.widget._type == "button" then
            if widget.widget:moved(x, y, dx, dy, istouch) then
                return true
            end
        end
    end
    return false
end

function grid:released(x, y, button, istouch, presses)
    for idx, widget in ipairs(self.children) do
        widget.widget:released(x, y, button, istouch, presses)
    end
end

function grid:pressed(x, y, button, istouch, presses)
    for idx, widget in ipairs(self.children) do
        widget.widget:pressed(x, y, button, istouch, presses)
    end
end

return grid