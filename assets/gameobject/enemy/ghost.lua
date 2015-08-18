require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Character = require("gameobjects.character")

local Ghost = Character(
    assetManager:getImage("death"),
    assetManager:getAnimationSet("death"),
    vector(16, 24),
    vector(3, 14),
    vector(10, 10))

Ghost.name = "Ghost"

return Ghost
