--[[

File: 		enemy.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

The enemy class.

]]--

local Enemy = Class{__includes = Unit}

function Enemy:init(x, y)
	Unit.init(self, x, y, 8, 8, "dynamic")

	self.speed = 500
	self.target = player

	enemies[table.address(self)] = self
end

function Enemy:update(dt)
	Unit.update(self, dt)

	local px, py = self.target:getPosition()
	local x, y = self:getPosition()
	local angle = angleToPoint(px, py, x, y)

	local movement = vector(self.speed, 0)
	movement:rotate_inplace(angle)
	self:applyForce(movement:unpack())
end

function Enemy:draw()
	love.graphics.setColor(200, 20, 0, 255)
	Unit.draw(self)
end

function Enemy:destroy()
	Unit.destroy(self)
	enemies[table.address(self)] = nil	
end

return Enemy
