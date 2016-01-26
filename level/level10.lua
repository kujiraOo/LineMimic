------------------------------------------------------------------------------------
-- File level/level10.lua
--
-- This level pictures windmills on the background consisting from rect patterns
-- and reaction bars
-- Icecreams representing people in front
-- Flower in front
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local level = require ("level.level")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local level10 = level:extend("level10")

------------------------------------------------------------------------------------
-- Local constants
------------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4

------------------------------------------------------------------------------------
-- Table of behaviours for level
-- Format:
-- id, pattern name, x, y, params
------------------------------------------------------------------------------------
level10.behaviours = {

	
	{
		pattern = "simpleTouchElement",
		speed = 5,
		params = {
			touchElement = "flower",
			{70, 270, 20},
			{250, 274, 22},
			{175, 330, 30},
			{100, 400, 35},
			{200, 402, 37},
		}
	},

	{
		pattern = "separatedLine",
		speed = 0.5,
		params = {
			{70, 280, down, 30},
			{250, 285, down, 30},
			{175, 375, up, 30},
			{100, 448, up, 30},
			{200, 418, down, 30},
		}
	},

	{
		pattern = "simpleTouchElement",
		speed = 6,
		params = {
			touchElement = "icecream",
			{50, 290, 35},
			{120, 330, 40},
			{270, 405, 50},
		}
	},

	{
		pattern = "simpleTouchElement", 
		params = {
			touchElement = "reactionBar", 
			{80, 90, 80},
			{157, 125, 90},
			{254, 90, 80}
		}, 
		speed = 3,
	},

	{
		pattern = "connectedLine",
		speed = 4,
		params = {
			x = 65, y = 200,
			{up, 160}, {right, 30}, {down, 156}
		}
	},

	{
		pattern = "connectedLine",
		params = {
			x = 140, y = 240,
			{up, 170}, {right, 34}, {down, 166},
		}
	},

	{
		pattern = "connectedLine",
		params = {
			x = 240, y = 190,
			{up, 155}, {right, 28}, {down, 151},
		}
	},
	
}

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function level10:init()

	self.super.init(self)

	self.id = 10

	self.maxNumEls = 8
end

return level10