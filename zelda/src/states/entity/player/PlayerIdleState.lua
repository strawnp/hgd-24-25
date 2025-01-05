--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('a') or love.keyboard.isDown('d') or
       love.keyboard.isDown('w') or love.keyboard.isDown('s') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end