--[[

File: 		src/objects/gameobject.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Base Gameobject class.

]]--

_pixelsPerMeter = 64
_gravity = 0 * _pixelsPerMeter
-- _gravity = 9.8 * _pixelsPerMeter
_collisionPadding = 0.001
-- _defaultVelocityDampening = 0.0
-- _defaultAccelerationDampening = 0.0
_defaultVelocityDampening = 0.2
_defaultAccelerationDampening = 0.2

OBJECT_STATIC = 0
OBJECT_DYNAMIC = 1

local Gameobject = Class{function(self, position, size, gtype, collisionOffset, collisionSize)
	self.size = size or vector(16, 16)
	self.position = position or (-self.size / 2)
	self.type = gtype or OBJECT_DYNAMIC
	self.collisionOffset = collisionOffset or vector(0, 0)
	self.collisionSize = collisionSize or self.size

	self.isGravitized = false
	if self.type == OBJECT_DYNAMIC then
		self.isGravitized = true
	end

	self.velocityDampening = _defaultVelocityDampening
	self.accelerationDampening = _defaultAccelerationDampening

	self.velocity = vector(0, 0)
	self.acceleration = vector(0, 0)
end}

function Gameobject:update(dt)
	if self.type == OBJECT_STATIC then return end

	self.velocity = self.velocity + (self.acceleration * dt)
	self.position = self.position + (self.velocity * dt)

	if self.isGravitized and self.type == OBJECT_DYNAMIC then
		self.velocity.y = self.velocity.y + (_gravity * dt)
	end

	self.velocity = self.velocity * math.abs(self.velocityDampening - 1)
	self.acceleration = self.acceleration * math.abs(self.accelerationDampening - 1)
end

function Gameobject:draw()
	local p = self.position
	local cp = p + self.collisionOffset
	local s = self.size
	local cs = self.collisionSize

	love.graphics.setColor({255, 255, 255, 50})
	love.graphics.rectangle("fill", p.x, p.y, s.x, s.y)

	love.graphics.setColor({255, 0, 255, 50})
	love.graphics.rectangle("fill", cp.x, cp.y, cs.x, cs.y)
end

function Gameobject:getAABB()
	return (self.position + self.collisionOffset), self.collisionSize
end

function Gameobject:getCenter()
	return self.position + self.collisionOffset + (self.collisionSize / 2)
end

function Gameobject:getVelocityAABB(dv)
	if self.type == OBJECT_STATIC then return self:getAABB() end

	local dv = dv or self.velocity:clone()
	print('dv ' .. tostring(dv))
	local pos = (self.position + self.collisionOffset)
	local size = self.collisionSize:clone()
	if self.velocity.x < 0 then
		pos.x = pos.x + dv.x
		size.x = size.x - dv.x
	else
		size.x = size.x + dv.x
	end
	if self.velocity.y < 0 then
		pos.y = pos.y + dv.y
		size.y = size.y - dv.y
	else
		size.y = size.y + dv.y
	end
	return pos, size
end

function Gameobject:getFloorSensor(dt)
	return (self.position + self.collisionOffset), self.collisionSize
end

function Gameobject:collide(pos, size, dt)
	local cp = _collisionPadding
	local spos, ssize = self:getAABB(self.velocity * dt)
	local mtd = minimumTranslation(spos, ssize, pos, size)
	if love.keyboard.isDown(" ") or true then
		self.position = self.position + mtd
		if mtd.y >= cp or mtd.y < -cp then
			self.velocity.y = 0
			if mtd.y < -cp and self.isOnFloor == false then
				self.isOnFloor = true
			end
			self.isOnFloor = true
		elseif mtd.x >= cp or mtd.x < -cp then
			self.velocity.x = 0
		end
	end
end

function Gameobject:collideWithObject(g, dt)
	print('g.vel ' .. tostring(g.velocity))
	local p, s = g:getVelocityAABB(g.velocity * dt)
	self:collide(p, s, dt)
end

return Gameobject
