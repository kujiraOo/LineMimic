-- File level/level6.lua



-- Imports
local level = require ("level.level")
local composer = require("composer")

-- Class declaration
local level6 = level:extend("level6")

-- Native cache
local tableInsert = table.insert

-- Local constatnts
local centerX = 0.5 * display.contentWidth
local centerY = 0.5 * display.contentHeight

local up = 1
local down = 2
local left = 3
local right = 4

local padding = 10


-- Table of behaviours for level
-- Format:
-- id, pattern name, x, y, params
level6.behaviours = {

	{
		pattern = "simpleTouchElement", 
		params = {
					touchElement = "flower",
					{40, 240, 24},
					{140, 240, 24}
				}
	},

	{
		pattern = "separatedLine", 
		params = {
			{75, 170, down, 130},
			{75, 240, right, 35},
			{175, 170, down, 130},
			{210, 185, right, 60},
			{268, 185, down, 40},
			{210, 240, right, 60},
			{240, 240, down, 40},
		}
	}
}

-- Class constructor
function level6:init()

	self.super.init(self)

	self.id = 6

	self.maxNumEls = 5
	self.drawManager.speed = 1
end


return level6