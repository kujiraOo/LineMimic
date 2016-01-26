-- File level/level8.lua

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local level = require ("level.level")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local level8 = level:extend("level8")

------------------------------------------------------------------------------------
-- Local constants
------------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4

local rnd = math.random

local function shuffleFlowers(t)

	for i = 1, 16 do
		local ind1 = rnd(1, 16)
		local ind2 = rnd(1, 16)

		t[ind1], t[ind2] = t[ind2], t[ind1]
	end
end

local function createFlowers( )

	local t = {}

	t.touchElement = "flower"

	local ind = 1
	
	for i = 1, 4 do

		local y = i * 60 + rnd(-5, 5)

		for j = 1, 4 do

			local x = j * 64 + rnd(-5, 5)

			t[ind] = {x, y, rnd(28, 33)}

			ind = ind + 1
		end
	end

	shuffleFlowers(t)

	return t
end


------------------------------------------------------------------------------------
-- Table of behaviours for level
-- Format:
-- id, pattern name, x, y, params
------------------------------------------------------------------------------------
level8.behaviours = {

	{
		pattern = "separatedLine",
		params = {
			{0, 380, right, 300},
			{320, 460, left, 300},
		},
		speed = 2,
	},

	{
		pattern = "simpleTouchElement", params = createFlowers(), speed = 4
	},

	{
		pattern = "separatedLine",
		params = {
			{64, 260, down, 50},
			{128, 260, down, 50},
			{192, 260, down, 50},
			{256, 260, down, 50},
		}, 
		speed = 1.5
	},

	{
		pattern = "simpleTouchElement", 
		params = {
			touchElement = "wheel",
			{180, 430, 20}, 
			{240, 430, 20}
		}
	},

	{
		pattern = "separatedLine", 
		params = {
			{155, 360, right, 50},
			{180, 360, down, 50},
			{180, 390, right, 60},
			{238, 390, down, 20}
		}
	},

}

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function level8:init()

	self.super.init(self)

	self.id = 8

	self.maxNumEls = 15
end

return level8