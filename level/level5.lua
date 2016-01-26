-- File level/level5.lua

-- First text level
-- Contains 3 stages:
-- 100 lines in random pattern, normal length
-- 50 lines in short
-- Spiral 

-- Imports
local level = require ("level.level")

-- Class declaration
local level5 = level:extend("level5")

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
level5.behaviours = {

	{
		pattern = "connectedLine", 
		params = {
					x = padding, y= 50, 
					{right, 100}, {down, 300}
				},
	},

	{
		pattern = "connectedLine", 
		params = {
					x = padding + 100, y = 150, 
					{right, 100}, {down, 200}
				},
	},

	{pattern = "chain", params = {x = 30, y = 80, {right, 35}, {right, 35}}},
	{pattern = "chain", params = {x = 30, y = 130, {right, 35}, {right, 35}}},
	{pattern = "chain", params = {x = 130, y = 180, {right, 35}, {right, 35}}},
	{pattern = "chain", params = {x = 130, y = 230, {right, 35}, {right, 35}}},

	{
		pattern = "separatedLine", 
		params = {
					{50, 350, down, 50},
					{100, 420, up, 50},
					{150, 350, down, 50},
					{200, 410, up, 50},
					{250, 350, down, 50},
				}
	},

	{
		pattern = "simpleTouchElement", 
		params = {
					touchElement = "flower",
					{50, 340, 25},
					{100, 360, 25},
					{150, 340, 25},
					{200, 350, 25},
					{250, 340, 25},
					{230, 100, 50}
				}
	},
}

-- Class constructor
function level5:init()

	self.super.init(self)

	self.id = 5

	self.maxNumEls = 10
	self.drawManager.speed = 1
end

return level5