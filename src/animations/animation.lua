--[[

File:       src/animations/animation.lua
Author:     Daniel "lytedev" Flanagan
Website:    http://dmf.me

Defines a single animation.

]]--

local AnimationFrame = require("src.animations.animationframe")

local Animation = Class{function(self, frames, loopStart, loopEnd, bounce)
    self.frames = frames or {}

    self.loopStart = loopStart or 0
    self.loopEnd = loopEnd or 0

    self.bounce = bounce or false
end}

function Animation:getFrame(fid)
    return self.frames[fid]
end

function Animation:removeFrame(fid)
    if fid < 1 or fid > #self.frames then return end
    self.frames:remove(fid)
end

function Animation:insertFrame(fid, frame)
    if fid < 1 or fid > #self.frames + 1 then return end
    self.frames[fid] = frame
end

function Animation:addFrame(frame)
    self.frames[#self.frames + 1] = frame
end

return Animation
