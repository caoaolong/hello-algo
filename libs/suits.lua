suit = require("suit")
suits = {}

function suits.ac()
    if suit.Button("Hello, World!", 100,100, 300,30).hit then
        show_message = true
    end
    -- if the button was pressed at least one time, but a label below
    if show_message then
        suit.Label("How are you today?", 100,150, 300,30)
    end
end

function suits.draw()
    suit.draw()
end

return suits