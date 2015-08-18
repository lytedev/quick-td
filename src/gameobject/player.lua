--[[

File: 		player.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

The player class.

]]--

local Player = Class{__includes = Unit}

local pairs = pairs

function Player:init(x, y)
	Unit.init(self, x, y, 8, 8, "dynamic")

	self.speed = 1000
	self.towerCooldown = 0.5
	self.towerDropRange = 27
end

function Player:update(dt)
	Unit.update(self, dt)
end

function Player:draw()
	love.graphics.setColor(100, 255, 0, 255)
	Unit.draw(self)

	local mx, my = gameCamera:mousepos()
	local px, py = self:getPosition()
	local angle = angleToPoint(mx, my, px, py)
	love.graphics.setLineWidth(2)
	drawAngledLine(px, py, self.towerDropRange, angle)

	local mx, my = gameCamera:mousepos()
	local px, py = self:getPosition()
	local angle = angleToPoint(mx, my, px, py)
	local x1, y1, x2, y2 = angledLine(px, py, self.towerDropRange, angle)

	local cellSize = 8

	x2 = math.floor((x2 / cellSize) + 0.5) * cellSize
	y2 = math.floor((y2 / cellSize) + 0.5) * cellSize
end

function Player:drawDropPoint()
	local mx, my = gameCamera:mousepos()
	local px, py = self:getPosition()
	local angle = angleToPoint(mx, my, px, py)
	local x1, y1, x2, y2 = angledLine(px, py, self.towerDropRange, angle)

	local cellSize = 8

	x2 = math.floor((x2 / cellSize) + 0.5) * cellSize
	y2 = math.floor((y2 / cellSize) + 0.5) * cellSize

	love.graphics.setColor(0, 150, 255, 200)
	love.graphics.circle("fill", x2, y2, 4)
end

function Player:dropTower()
	if self.cooldown <= 0 then
		local mx, my = gameCamera:mousepos()
		local px, py = self:getPosition()
		local angle = angleToPoint(mx, my, px, py)
		local x1, y1, x2, y2 = angledLine(px, py, self.towerDropRange, angle)
		
		local cellSize = 8

		x2 = math.floor((x2 / cellSize) + 0.5) * cellSize
		y2 = math.floor((y2 / cellSize) + 0.5) * cellSize

		local canPlace = true
		for k, v in pairs(towers) do
			-- local hit = v.fixture:testPoint(x2, y2)
			local hit = pointDistance(x2, y2, v:getPosition()) < cellSize * 2
			print(hit)
			if hit then
				canPlace = false
				break
			end
		end

		if canPlace then
			Tower(x2, y2)
			self.cooldown = self.towerCooldown
		end
	end
end

function Player:deleteTower()
	if self.cooldown <= 0 then
		local mx, my = gameCamera:mousepos()
		local px, py = self:getPosition()
		local angle = angleToPoint(mx, my, px, py)
		local x1, y1, x2, y2 = angledLine(px, py, self.towerDropRange, angle)

		local cellSize = 8

		x2 = math.floor((x2 / cellSize) + 0.5) * cellSize
		y2 = math.floor((y2 / cellSize) + 0.5) * cellSize

		local canDelete = false
		for k, v in pairs(towers) do
			local hit = v.fixture:testPoint(x2, y2)
			print(hit)
			if hit and v.destroyed ~= true then
				canDelete = v
				break
			end
		end

		if canDelete ~= false then
			canDelete:destroy()
			self.cooldown = 0.1
		end
	end
end

function Player:destroy()
	Unit.destroy(self)
end

return Player
