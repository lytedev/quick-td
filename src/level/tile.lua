--[[

File: 		src/level/tile.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Defines the basic tiletype class.

]]--

local AnimationState = require("src.animations.animationstate")

local Tile = Class{__includes = AnimationState, function(self, image, animationSet, size, initialKey)
	AnimationState.init(self, image, animationSet, size, initialKey)
	self.solid = true
end}

return Tile
