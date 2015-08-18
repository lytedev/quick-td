--[[

File: 		unit.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

The unit class.

]]--

local Unit = Class{__includes = Gameobject}

function Unit:init(x, y, width, height, type)
	Gameobject.init(self, x, y, width, height, type)

	self.cooldown = 0
	self.speed = 500
	self.range = 40
	self.target = nil
	self.range = 40
	self.damage = 5
	self.health = 100
	self.maxHealth = 100
end

function Unit:update(dt)
	Gameobject.update(dt)
	if self.cooldown > 0 then
		self.cooldown = self.cooldown - dt
	else 
		self.cooldown = 0
	end
end

function Unit:takeDamage(attacker)
	self.health = self.health - attacker.damage 
	if self.health > self.maxHealth then
		self.health = maxHealth
	elseif self.health <= 0 then
		self:destroy()
	end
end

return Unit
