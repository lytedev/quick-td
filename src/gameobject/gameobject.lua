--[[

File: 		gameobject.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

The base gameobject class.

]]--

local Gameobject = Class{}

function Gameobject:init(x, y, width, height, objectType, shape)
	local objectType = objectType or "static"
	local width = width or 8
	local height = height or 8

	gameobjects[table.address(self)] = self

	local x = x or 0
	local y = y or 0
	self.body = love.physics.newBody(world, x, y, objectType)

	self.shapeType = shape or "circle"
	if self.shapeType == "circle" then
		self.shape = love.physics.newCircleShape(width)
	else
		self.shape = love.physics.newRectangleShape(width, height)
	end
	self.fixture = love.physics.newFixture(self.body, self.shape)

	self.body:setLinearDamping(20)
	self.body:setFixedRotation(true)
end

function Gameobject:update(dt)

end

function Gameobject:draw()
	if self.shapeType == "circle" then
		love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	else
		love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	end
end

function Gameobject:applyForce(x, y)
	self.body:applyForce(x, y)
end

function Gameobject:getPosition()
	return self.body:getPosition()
end

function Gameobject:destroy()
	self.destroyed = true
	self.body:destroy()
	gameobjects[table.address(self)] = nil
end

return Gameobject
