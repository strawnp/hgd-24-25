--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerSwingSwordState = Class{__includes = BaseState}

function PlayerSwingSwordState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 8

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 12
        hitboxHeight = 20
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 12
        hitboxHeight = 20
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 20
        hitboxHeight = 12
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 20
        hitboxHeight = 12
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    -- separate hitbox for the player's sword; will only be active during this state
    self.swordHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- flag to ensure damage is only applied once during the swing
    self.damageApplied = false

    -- sword-left, sword-up, etc
    self.player:changeAnimation('sword-' .. self.player.direction)
end

function PlayerSwingSwordState:enter(params)
    -- restart sword swing sound for rapid swinging
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- restart sword swing animation
    self.player.currentAnimation:refresh()
end

function PlayerSwingSwordState:update(dt)
    
    if not self.damageApplied then
        for k, entity in pairs(self.dungeon.currentRoom.entities) do
            if entity:collides(self.swordHitbox) then
                if math.random() > 0.95 then
                    entity:damage(6)
                    gSounds['crit']:play()
                else
                    entity:damage(1)
                end
                gSounds['hit-enemy']:play()
                
                self.damageApplied = true
            end
        end
    end

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    -- allow us to change into this state afresh if we swing within it, rapid swinging
    if love.keyboard.wasPressed('space') then
        self.player:changeState('swing-sword')
    end
end

function PlayerSwingSwordState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
        -- self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
