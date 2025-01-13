event = {}

function event.load(scene, value)
    scene.load()
    scene.start(value)
end

function event.exit()
    love.event.quit()
end

return event