--[[

File: 		src/level/layer.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Defines a layer of tiles and methods for manipulating/managing them.

]]--

local Tile = require("src.level.tile")

local Layer = Class{function(self, size, tileset, tileSize)
	self.tiles = {}
	self.size = vector(20, 20)
    self.objects = {}
    self.level = nil

	for i = 1, self.size.x * self.size.y do
		self.tiles[i] = 0
	end

	self.tileset = tileset or {Tile()}
	self.tileSize = tileSize or vector(16, 16)
    self.lastObjectId = 0
end}

-- Object Methods
function Layer:getNextObjectId()
    if self.lastObjectId >= 99999999999999 then
        self.lastObjectId = 0
    end

    repeat
        self.lastObjectId = self.lastObjectId + 1
    until self.layers[self.lastObjectId] == nil

    return self.lastObjectId
end

function Layer:getObject(id)
    return self.objects[id]
end

function Layer:addObject(g)
    g.level = self.level
    g.layer = self
    g.id = self:getNextObjectId()
    self.objects[g.id] = g
end

function Layer:removeObject(id)
    table.remove(self.objects, id)
end

function Layer:coordsToId(x, y)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        return ((y * self.size.x) + x) + 1;
    else
        return nil
    end
end

function Layer:idToCoords(id)
    return vector(math.floor((id - 1) % self.size.x), math.floor((id - 1) / self.size.x))
end

function Layer:setTile(x, y, type)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        self.tiles[self:coordsToId(x, y)] = type
    end
end

function Layer:setTileById(id, type)
	if id <= #self.tiles and id > 0 then
    	self.tiles[id] = type
    end
end

function Layer:getTileType(x, y)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        return self.tiles[self:coordsToId(x, y)]
    else
        return 0
    end
end

function Layer:getTileTypeById(id)
	if id <= #self.tiles and id > 0 then
    	return self.tiles[id]
    end
end

function Layer:getTile(x, y)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        return self.tileset[self:getTileType(x, y)]
    else
        return self.blankTile
    end
end

function Layer:getTileById(id)
    local tileTypeId = self:getTileTypeById(id)
    if tileTypeId ~= 0 then
        return self.tileset[tileTypeId]
    else
        return self.blankTile
    end
end

function Layer:selectTileSection(position, size, noclamp)
    local noclamp = noclamp or false
    noclamp = false
    local x1, y1, x2, y2 = selectRectangles(position, size, vector(self.tileSize, self.tileSize))
    if not noclamp then
        x1 = math.clamp(0, x1, self.size.x - 1)
        y1 = math.clamp(0, y1, self.size.y - 1)
        x2 = math.clamp(0, x2, self.size.x - 1)
        y2 = math.clamp(0, y2, self.size.y - 1)
        -- print(TileGrid.numofclamps .. "HEY!")
    end
    return x1, y1, x2, y2
end

function Layer:tileExists(x, y)
    return x >= 0 and x < self.size.x and y >= 0 and y < self.size.y
end

function Layer:tileExistsById(i)
    return self:tileExists(self:idToCoords(i))
end

function Layer:collideObjectWithTiles(g, dt)
    local pos, size = g:getVelocityAABB(g.velocity * dt)
    local x1, y1, x2, y2 = self:selectTileSection(pos, size)
    if not x1 or not y1 or not x2 or not y2 then
        return nil
    end

    local tsize = vector(self.tileSize, self.tileSize)

    for x = x1, x2 do
        for y = y1, y2 do
            local t = self:getTile(x, y)
            if t then
            	local p = vector(x, y) * tsize
                g:collide(p, tsize)
            end
        end
    end
end

function Layer:update(dt)
    for i = 1, #self.tileset do
        self.tileset[i]:update(dt)
    end
    for k, v in pairs(self.objects) do
        v:update(dt)
        for k2, v2 in pairs(self.objects) do
            if v2 ~= v then
                v:collideWithObject(v2, dt)
            end
        end
        self:collideObjectWithTiles(v, dt)
    end
end

function Layer:getNextObjectId()
    if self.lastObjectId >= 99999999999999 then
        self.lastObjectId = 0
    end

    repeat
        self.lastObjectId = self.lastObjectId + 1
    until self.objects[self.lastObjectId] == nil

    return self.lastObjectId
end

function Layer:addObject(g)
    g.layer = self
    g.lid = self.id
    g.id = self:getNextObjectId()
    self.objects[g.id] = g
end

function Layer:draw()
    local max = self.size.x * self.size.y
    for i = 1, max do
        local c = self:idToCoords(i)
        local tile = self:getTileById(i)
        local c2 = vector(c.x * self.tileSize.x, c.y, c.y * self.tileSize.y)
        if tile then
            tile:draw(c2)
        end
        -- love.graphics.rectangle("line", c.x * self.tileSize, c.y * self.tileSize, self.tileSize, self.tileSize)
    end
    for k, v in pairs(self.objects) do
        v:draw()
    end
end

return Layer
