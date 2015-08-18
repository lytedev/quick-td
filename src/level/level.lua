--[[

File: 		src/level/level.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Defines a game level.

]]--

local Tile = require("src.level.tile")
local Layer = require("src.level.layer")

local Level = Class{function(self, size)
	size = size or vector(20, 20)
	self.layers = {Layer(self.size)}

    self.backgrounds = {}
    self.foregrounds = {}

	self.lastLayerId = 0
end}

function Level:getNextObjectId(lid)
    return self.layers[lid]:getNextObjectId()
end

function Level:getObject(lid, id)
    return self.layers[lid]:getObject(id)
end

function Level:addObject(lid, g)
    return self.layers[lid]:addObject(g)
end

function Level:removeObject(lid, id)
    return self.layers[lid]:removeObject(id)
end

-- Layer Methods
function Level:getNextLayerId()
    if self.lastLayerId >= 99999999999999 then
        self.lastLayerId = 0
    end

    repeat
        self.lastLayerId = self.lastLayerId + 1
    until self.layers[self.lastLayerId] == nil

    return self.lastLayerId
end

function Level:getLayer(lid)
	return self.layers[lid]
end

function Level:addLayer(layer)
	local layer = layer or Layer(self.size)
    layer.level = self
    layer.id = self:getNextLayerId()
    self.layers[layer.id] = layer
end

function Level:removeLayer(id)
    table.remove(self.layers, id)
end

-- Background/Foreground Methods
function Level:addBackground(bg)
    self.backgrounds[#self.backgrounds + 1] = bg
end

function Level:removeBackground(id)
    table.remove(self.backgrounds, id)
end

function Level:addForeground(bg)
    self.foregrounds[#self.foregrounds + 1] = bg
end

function Level:removeForeground(id)
    table.remove(self.foregrounds, id)
end

-- Conversions between tile coordinates to tile IDs and vice versa
function Level:coordsToId(lid, x, y)
	self.layers[lid]:coordsToId(x, y)
end

function Level:idToCoords(lid, id)
	self.layers[lid]:idToCoords(id)
end

function Level:setTile(lid, x, y, type)
	self.layers[lid]:setTile(x, y, type)
end

function Level:setTileById(lid, id, type)
	self.layers[lid]:setTileById(id, type)
end

-- Tile Methods
function Level:getTileType(lid, x, y)
	self.layers[lid]:getTileType(x, y)
end

function Level:getTileTypeById(lid, id)
	self.layers[lid]:getTileTypeById(id)
end

function Level:getTile(lid, x, y)
	self.layers[lid]:getTile(x, y)
end

function Level:getTileById(lid, id)
	self.layers[lid]:getTileById(id)
end

function Level:selectTileSection(lid, position, size, noclamp)
	self.layers[lid]:selectTileSection(position, size, noclamp)
end

function Level:tileExists(lid, x, y)
	self.layers[lid]:tileExists(x, y)
end

function Level:tileExistsById(lid, i)
	self.layers[lid]:tileExistsById(i)
end

function Level:collideObjectWithTiles(lid, g, dt)
	self.layers[lid]:collideObjectWithTiles(g, dt)
end

-- Update and Draw Methods
function Level:update(dt)
	for k, v in pairs(self.layers) do
		v:update(dt)
	end
end

function Level:draw()
	for k, v in pairs(self.layers) do
		v:draw()
	end
end

return Level
