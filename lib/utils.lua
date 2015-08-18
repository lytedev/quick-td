--[[

File: 		src/utils.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Defines basic utility/helper functions.

]]--

-- Load standard classes
vector = require("lib.hump.vector")
Class = require("lib.hump.class")
Gamestate = require("lib.hump.gamestate")
assetManager = require("lib.assetmanager")()

debugText = ""

function addDebug(s)
    debugText = debugText .. s .. "\n"
end

function printDebug(pos)
    local pos = pos or vector(5, 5)
    love.graphics.print(debugText, pos.x, pos.y)
    debugText = ""
end

function rerequire(module)
    package.loaded[module] = nil
    return require(module)
end

function math.wrap(low, n, high) if n<=high and n>=low then return n else return ((n-low)%(high-low))+low end end

function math.clamp(low, n, high) return math.min(math.max(low, n), high) end

function lerp(a,b,t) return a+(b-a)*t end

function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end
