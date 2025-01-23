anim = {}
anim.__index = anim

function anim:new(attr, target, step, node)
    local object = setmetatable({
        attr = attr, target = target, step = step, 
        node = node,
        now = 0, finish = false
    }, anim)
    return object
end

function anim:playing()
    local node = self.node
    if math.abs(node[node.attr] - node.target) <= node.step then
        node.x = target
    else
        node.x = node.x + self.step
    end
end

return anim