push = require 'push'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

MOVE_TIME = 10

function love.load()
    flappySprite = love.graphics.newImage('bird.png')

    birds = {}

    for i = 1, 1000 do 
        table.insert(birds, {
            x = 0,
            y = math.random(VIRTUAL_HEIGHT - 24),
            rate = math.random() + math.random(MOVE_TIME - 1)
        })
    end 

    timer = 0

    endX = VIRTUAL_WIDTH - flappySprite:getWidth()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.update(dt) 
    if timer < MOVE_TIME then 
        timer = timer + dt

        for k, bird in pairs(birds) do 
            bird.x = math.min(endX, endX * (timer / bird.rate))
        end
    end
end

function love.draw()
    push:start()
    for k, bird in pairs(birds) do 
        love.graphics.draw(flappySprite, bird.x, bird.y)
    end
    love.graphics.print(tostring(timer), 4, 4)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 4, 24)
    push:finish()
end