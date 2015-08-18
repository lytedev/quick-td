require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Sprite = require("gameobjects.sprite")

local DeathBolt = Sprite(
    assetManager:getImage("death"),
    assetManager:getAnimationSet("death"),
    vector(16, 12))

DeathBolt.velocity = vector(0, 0)
DeathBolt.collisionSize = vector(16, 12)
DeathBolt.collisionOffset = vector(0, 0)
DeathBolt.friction = 0
DeathBolt.speed = 200
DeathBolt.static = false

function DeathBolt:onCollide(pos, size)
    self.delete = true
end

function DeathBolt:onCollideWith(g)
    self.delete = true
end

return DeathBolt
