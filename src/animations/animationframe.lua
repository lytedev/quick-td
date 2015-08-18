--[[

File: 		src/animations/animationframe.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Defines a single animation frame.

]]--

local AnimationFrame = Class{function(self, source, size, offset, time, frames)
    self.source = source or vector(0, 0)
    self.size = size or vector(16, 16)
    self.offset = offset or vector(0, 0)
    self.time = time or 0.2
    self.frames = frames or 12
end}

return AnimationFrame
