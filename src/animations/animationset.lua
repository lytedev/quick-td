--[[

File:       src/animations/animationset.lua
Author:     Daniel "lytedev" Flanagan
Website:    http://dmf.me

Defines a set of animations

]]--

local Animation = require("src.animations.animation")
local AnimationFrame = require("src.animations.animationframe")

local AnimationSet = Class{function(self, animationKeysTable)
    self.animations = {}
    self.initialKey = ""
    if animationKeysTable then
        for i = 1, #animationKeysTable, 1 do
            self:addAnimation(animationKeysTable[i].key, animationKeysTable[i].animation)
        end
    end
end}

function AnimationSet:getFrame(key, fid)
    local a = self:getAnimation(key)
    return a:getFrame(fid)
end

function AnimationSet:getAnimation(key)
    return self.animations[key]
end

function AnimationSet:removeAnimation(key)
    self.animations[key] = nil
end

function AnimationSet:addAnimation(key, animation)
    if self.initialKey == "" then
        self.initialKey = key
    end
    self.animations[key] = animation
end

return AnimationSet
