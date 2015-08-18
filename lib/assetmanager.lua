--[[

File:       src/assetmanager.lua
Author:     Daniel "lytedev" Flanagan
Website:    http://dmf.me

Defines a current animation state. Effectively the IDrawable interface for a sprite.

]]--

local AssetManager = Class{function(self)
    local imgData = love.image.newImageData(1, 1)
    imgData:setPixel(0, 0, 0, 0, 0, 0)
    self.blankImage = love.graphics.newImage(imgData)

    self.assetRoot = "assets/"
    self.imageFolder = "img/"
    self.fontFolder = "font/"

    self.images = {}
    self.fonts = {}
end}

function AssetManager:createImagePath(file)
    return (self.assetRoot .. self.imageFolder .. string.gsub(file, "[\\.]", "/") .. ".png")
end

function AssetManager:getImage(key)
    return self.images[key]
end

function AssetManager:getFont(key)
    return self.fonts[key]
end

function AssetManager:loadImage(file, key)
    local key = key or file
    if not self.images[key] then
        self.images[key] = love.graphics.newImage(self:createImagePath(file))
        if self.images[key] == nil then
            print("Could not load image \"" .. file .. "\". Using blankImage.")
            self.images[key] = self.blankImage
        end
    end
    return self.images[key]
end

function AssetManager:loadFont(file, size, key)
    local key = key or file
    file = string.gsub(file, "\\.", "/")
    if not self.fonts[key] then
        self.fonts[key] = love.graphics.newFont(self.assetRoot .. self.fontFolder .. file .. ".ttf", size)
    end
    return self.fonts[key]
end

function AssetManager:clearCache()
    self:clearImages()
    self:clearFonts()
    self:clearAnimationSets()
end

function AssetManager:clearImages()
    self.image = {}
end

function AssetManager:clearFonts()
    self.fonts = {}
end