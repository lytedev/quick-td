--[[

File: 		tower.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

The tower class.

]]--

local Tower = Class{__includes = Unit}

local pairs = pairs

function Tower:init(x, y)
	Unit.init(self, x, y)

	self.body:setMass(5)
	self.noBuildRadius = 0
	self.fireCooldown = 0.5

	self.fired = nil
	self.currentFireTime = 0
	self.fireTime = 0.4

	towers[table.address(self)] = self
end

function Tower:update(dt)
	Unit.update(self, dt)

	local leastRange = self.range + 1
	for k, v in pairs(enemies) do
		local tx, ty = self:getPosition()
		local ex, ey = v:getPosition()
		local distance = pointDistance(tx, ty, ex, ey)
		if distance < leastRange then
			leastRange = distance
			self.target = v
		end
	end
	if leastRange > self.range then
		self.target = nil
	end
	if self.target ~= nil and self.cooldown <= 0 then
		self.fired = vector(self.target:getPosition())
		self.target:takeDamage(self)
		self.cooldown = self.fireCooldown
		self.currentFireTime = self.fireTime
	end
	if self.currentFireTime <= 0 then
		self.currentFireTime = 0
		self.fired = nil
	else
		self.currentFireTime = self.currentFireTime - dt
	end
end

function Tower:drawAuras()
	local tx, ty = self:getPosition()
	--[[ 
	love.graphics.setColor(255, 20, 0, 40)
	love.graphics.circle("fill", tx, ty, self.noBuildRadius)
	love.graphics.setColor(255, 20, 0, 80)
	love.graphics.circle("line", tx, ty, self.noBuildRadius)
	]]--

	local col1 = {255, 255, 50, 10}
	if self.target ~= nil then
		col1 = {255, 150, 0, 10}
	end
	love.graphics.setColor(col1)
	love.graphics.circle("fill", tx, ty, self.range)
	love.graphics.circle("line", tx, ty, self.range)
end

function Tower:draw()
	love.graphics.setColor(255, 255, 255, 255)
	Unit.draw(self)
end

function Tower:drawAttack()
	if self.fired ~= nil and self.currentFireTime > 0 then
		if self.target ~= nil then
			if self.target.destroyed ~= true then
				self.fired = vector(self.target:getPosition())
			end
		else
			self.currentFireTime = 0
		end
		local tx, ty = self:getPosition()
		love.graphics.setLineStyle("smooth")
		love.graphics.setColor(0, 150, 255, 255 * (self.currentFireTime / self.fireTime))
		love.graphics.line(tx, ty, self.fired:unpack())
	end
end

function Tower:destroy()
	Unit.destroy(self)
	towers[table.address(self)] = nil	
end

return Tower
