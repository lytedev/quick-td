--[[

File:       src/level/background.lua
Author:     Daniel "lytedev" Flanagan
Website:    http://dmf.me

Defines the basic background class.

]]--

local Camera = require("lib.hump.camera")
local AnimationState = require("src.animations.animationstate")

local Background = Class{inherits = {AnimationState}, function(self, image, animationSet, size, initialKey, slide, parallax, flipX, flipY, offset)
    AnimationState.construct(self, image, animationSet, size, initialKey)
    self.slide = slide or vector(10, 10)
    self.parallax = parallax or 4
    self.alternateFlipsX = flipX or false
    self.alternateFlipsY = flipY or false
    self.offset = offset or vector(0, 0)
end}

function Background:update(dt)
    AnimationState.update(self, dt)
    self.offset = self.offset + (self.slide * dt)
    self.offset = vector(self.offset.x % self.size.x, self.offset.y % self.size.y)
end

function Background:draw()
    local c = getCurrentCamera()
    local pcam = Camera(c.x / self.parallax, c.y / self.parallax, c.scale, c.rot)
    local scvp = vector(love.graphics.getWidth() / c.scale, love.graphics.getHeight() / c.scale)
    c:detach()
    pcam:attach()

    local x, y = pcam:worldCoords(scvp.x, scvp.y)
    x = scvp.x / 2
    y = scvp.y / 2
    local pos = vector(-x, -y)

    local minx = math.floor(c.x / self.size.x / self.parallax) - 1
    local maxx = minx + (scvp.x / self.size.x) + 2
    local miny = math.floor(c.y / self.size.y / self.parallax) - 1
    local maxy = miny + (scvp.y / self.size.y) + 2

    for x = minx, maxx do
        for y = miny, maxy do
            local os = vector(self.size.x * x, self.size.y * y)
            AnimationState.draw(self, pos + os)
        end
    end

    pcam:detach()
    c:attach()
end

return Background
