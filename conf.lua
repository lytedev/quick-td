--[[

File: 		conf.lua
Author: 	Daniel "lytedev" Flanagan
Website:	http://dmf.me

Sets the default configuration values for the LOVE2D framework and serves as a 'header'-type include file.

]]--

-- Header Stuff
require("lib.hump.vector")
vector = require("lib.hump.vector")
Class = require("lib.hump.class")
Timer = require("lib.hump.timer")
Camera = require("lib.hump.camera")
Gamestate = require("lib.hump.gamestate")
Gameobject = require("src.gameobject.gameobject")
Unit = require("src.gameobject.unit")
Player = require("src.gameobject.player")
Enemy = require("src.gameobject.enemy")
Tower = require("src.gameobject.tower")

player = {}
gameCamera = {}
gameobjects = {}
towers = {}
enemies = {}
pixelsPerMeter = 32
gravity = 0 -- 9.8 * pixelsPerMeter
world = {}
debugText = ""

-- Utilities
function table.address(t)
	return tostring(t):sub(8)
end

function addDebugText(x)
	debugText = debugText .. x .. "\n"
end

function drawDebugText()
	love.graphics.print(debugText, 5, 5)
	debugText = ""
end

function angleToPoint(x1, y1, x2, y2)
	return math.atan2(y1 - y2, x1 - x2)
end

function angledLine(x, y, length, angle)
	local angleVector = vector(length, 0)
	angleVector:rotate_inplace(angle)
	angleVector = angleVector + vector(x, y)
	return x, y, angleVector.x, angleVector.y
end

function drawAngledLine(x, y, length, angle)
	local x1, y1, x2, y2 = angledLine(x, y, length, angle)
	love.graphics.line(x1, y1, x2, y2)
end

function pointDistance(x1, y1, x2, y2)
	local x = x1 - x2
	local y = y1 - y2
	return math.sqrt(x * x + y * y)
end

-- LOVE2D config
function love.conf(t)
	-- Set config global
	config = t

	t.title = "Ludum Dare 27 Entry"
	t.author = "Daniel \"lytedev\" Flanagan"
	t.url = "http://lytedev.com"
	t.identity = "lytedev_ld27"
	t.titleVersion = "0.1.0-alpha"
	t.version = "0.8.0"

	print(string.format("%s\n%s\n%s\n%s", t.title, t.titleVersion, t.author, t.url))
	print("TODO: Finalize game metadata!")

	t.console = false

	print("TODO: Release!")
	t.release = false

	t.screen.scaleHeight = 180
	t.screen.width = 640
	t.screen.height = 360
	t.screen.fullscreen = false
	t.screen.vsync = true
	t.screen.fsaa = 0

	t.modules.joystick = true
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.physics = true

	return t
end

