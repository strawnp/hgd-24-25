-- main.lua
local world
local ball
local pegs = {}
local paddle
local ballLaunched = false
local score = 0
local ballCount = 10

function love.load()
    -- Create the Box2D world with gravity
    world = love.physics.newWorld(0, 1000, true)
    
    -- Create paddle
    paddle = createPaddle()
    
    -- Create pegs
    createPegs()
    
    -- Create the ball
    ball = createBall()
end

function love.update(dt)
    world:update(dt)
    
    -- Update paddle position based on user input
    if love.keyboard.isDown("left") then
        paddle.body:setLinearVelocity(-100, 0)
    elseif love.keyboard.isDown("right") then
        paddle.body:setLinearVelocity(100, 0)
    else
        paddle.body:setLinearVelocity(0, 0)
    end
    
    -- Launch the ball when the user presses space
    if not ballLaunched and love.keyboard.isDown("space") then
        launchBall()
    end
    
    -- Check for peg collisions
    checkPegCollisions()
    
    -- Check if the ball is out of bounds
    if ball.body:getY() > love.graphics.getHeight() then
        resetBall()
    end
end

function love.draw()
    -- Draw paddle
    love.graphics.setColor(0, 0, 1)
    love.graphics.polygon("fill", paddle.body:getWorldPoints(paddle.shape:getPoints()))
    
    -- Draw pegs
    love.graphics.setColor(1, 0, 0)
    for _, peg in ipairs(pegs) do
        love.graphics.circle("fill", peg.body:getX(), peg.body:getY(), 10)
    end
    
    -- Draw ball
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), 10)
    
    -- Draw score and ball count
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Balls: " .. ballCount, 10, 30)
end

function createBall()
    local ball = {}
    -- Ball starts at the top, but doesn't move until launched
    ball.body = love.physics.newBody(world, love.graphics.getWidth() / 2, 100, "dynamic")
    ball.shape = love.physics.newCircleShape(10)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    
    -- Set initial velocity to 0 (it will fall due to gravity)
    ball.body:setLinearVelocity(0, 0)
    
    return ball
end


-- Function to create the paddle
function createPaddle()
    local paddle = {}
    paddle.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() - 50, "kinematic")
    paddle.shape = love.physics.newRectangleShape(100, 10)
    paddle.fixture = love.physics.newFixture(paddle.body, paddle.shape)
    return paddle
end

-- Launch the ball from the paddle
function launchBall()
    ball.body:setLinearVelocity(0, -500)
    ballLaunched = true
end

-- Reset the ball after it falls off the screen
function resetBall()
    if ballCount > 0 then
        ball.body = love.physics.newBody(world, love.graphics.getWidth() / 2, 100, "dynamic")
        ball.shape = love.physics.newCircleShape(10)
        ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)        ball.body:setLinearVelocity(0, 0)
        ballLaunched = false
        ballCount = ballCount - 1
    else
        love.graphics.print("Game Over", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2)
    end
end

-- Function to create the pegs with increased restitution for bounciness
function createPegs()
    local rows = 5
    local pegsPerRow = 10  -- Number of pegs per row
    local verticalSpacing = 50  -- Vertical distance between rows
    local horizontalSpacing = 60  -- Horizontal distance between pegs in each row

    -- Loop through each row
    for row = 1, rows do
        -- Loop through each peg in the row
        for col = 1, pegsPerRow do
            -- Calculate the X and Y position for each peg
            -- Adjust the Y position based on the row number
            local y = row * verticalSpacing + 100
            -- For odd rows, offset the X position to create a staggered effect
            local x = (col * horizontalSpacing) + (row % 2 == 0 and 30 or 0)
            
            -- Create a peg at the calculated position
            local peg = {}
            peg.body = love.physics.newBody(world, x, y, "static")
            peg.shape = love.physics.newCircleShape(10)  -- 10 is the radius of the peg
            peg.fixture = love.physics.newFixture(peg.body, peg.shape, 1)
            
            -- Set high restitution (bounciness)
            peg.fixture:setRestitution(0.8)  -- Adjust this value to control bounciness

            table.insert(pegs, peg)
        end
    end
end

-- Function to check for collisions with pegs (without removing them)
function checkPegCollisions()
    for _, peg in ipairs(pegs) do
        -- Get the ball and peg positions
        local bx, by = ball.body:getPosition()
        local px, py = peg.body:getPosition()

        -- Calculate the distance between the ball and the peg
        local dist = math.sqrt((bx - px)^2 + (by - py)^2)

        -- Check if the ball has collided with the peg (based on radius)
        if dist < 20 then  -- 20 is the sum of the radius of the ball (10) and the peg (10)
            -- When a peg is hit, we don't remove it, but we can still increase the score
            score = score + 10
        end
    end
end

