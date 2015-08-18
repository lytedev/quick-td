--[[

File: 		main.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Game entry point.

]]--

require("conf")

local Game = require("src.states.game")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(Game)
end

function love.update(dt)

end

function love.draw()
	
end
