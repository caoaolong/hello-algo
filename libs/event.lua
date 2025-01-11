event = {}

function event.load(scene)
    scene.load()
end

function event.exit()
    love.event.quit()
end

return event