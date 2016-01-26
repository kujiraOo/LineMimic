------------------------------------------------------------------------------------
-- File level/level9.lua
--
-- This level contains 
-- - a city in the background, formed from connected line
--   patterns,
-- - an antenna on one of the houses created from wheel object and line
-- - a giant icecream ad created from icecream and separate lines objects
-- - people - ice cream objects
-- - road seprate lines, rects
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local level = require ("level.level")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local level9 = level:extend("level9")

------------------------------------------------------------------------------------
-- Local constants
------------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4

local rnd = math.random


------------------------------------------------------------------------------------
-- Table of behaviours for level
-- Format:
-- id, pattern name, x, y, params
------------------------------------------------------------------------------------
level9.behaviours = {
	{
		pattern = "connectedLine", 
		speed = 1,
		params = {
			x = 30, y = 170, {up, 60}, {right, 50}
		}
	},

	{
		pattern = "connectedLine", 
		speed =1,
		params = {
			x = 130, y = 170, {up, 110}, {left, 50}, {down, 110}
		}
	},

	{
		pattern = "connectedLine", 
		speed = 1,
		params = {
			x = 130, y = 90, {right, 50}, {down, 80}
		}
	},
	
	{
		pattern = "simpleTouchElement", 
		params = {
			touchElement = "wheel",
			{170, 45, 18}
		}
	},

	{
		pattern = "simpleTouchElement", 
		speed = 5,
		params = {
			touchElement = "icecream",
			{230, 40, 120}, 
		}
	},

	{
		pattern = "separatedLine", 
		speed = 1.5,
		params = {
			{170, 90, up, 26},
			{180, 110, right, 30},
			{180, 160, right, 47},
		}, 
	},

	{
		pattern = "simpleTouchElement", 
		params = {
			touchElement = "icecream",
			{80, 210, 55},
			{160, 210, 55},
			{240, 210, 55},
		}
	},

	{
		pattern = "separatedLine", 
		params = {
			{20, 280, right, 280},
			{300, 390, left, 280},
		}
	},

	{
		pattern = "simpleTouchElement",
		speed = 4,
		params = {
			touchElement = "icecream",
			{80, 415, 55},
			{160, 415, 55},
			{240, 415, 55},
		}
	},

	{
		pattern = "connectedLineRect", 
		params = {x = 110, y = 290, w = 100, h = 20}
	},

	{
		pattern = "connectedLineRect", 
		params = {x = 110, y = 325, w = 100, h = 20}
	},

	{
		pattern = "connectedLineRect", 
		params = {x = 110, y = 360, w = 100, h = 20}
	},
}

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function level9:init()

	self.super.init(self)

	self.id = 9

	self.maxNumEls = 15
end

return level9