shape = {}

function shape.axis(center)
    local axis = require("libs.shapes.axis")
    local object = axis:new(center)
    return object
end

return shape