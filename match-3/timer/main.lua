push = require 'push'
Timer = require 'knife.timer'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    -- timing intervals
    intervals = {1, 3, 5, 10}

    -- counters for our labels
    counters = {0, 0, 0, 0}

    -- create Timer entries for each interval/counter pair
    for i = 1, 4 do 
        Timer.every(intervals[i], function()
            counters[i] = counters[i] + 1
        end)
    end

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    end
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    push:start()
    for i = 1, 4 do
        love.graphics.printf('Timer: ' .. tostring(counters[i]) .. ' seconds (every ' ..
        tostring(intervals[i]) .. ')', 0, 54 + i * 16, VIRTUAL_WIDTH, 'center')
    end
    push:finish()
end