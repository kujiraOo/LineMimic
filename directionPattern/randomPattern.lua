-- File: directionPattern.random.lua

-- Works with line direction
-- Calculates next line segment's direction and coordinates, has random mode and several patterns

-- Imports
local pattern = require("directionPattern.pattern")

-- Class declaration
local randomPattern = pattern:extend("randomPattern")

-- Local constatnts
local padding = 10
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

local nDirs = 4
local up = 1
local down = 2
local left = 3
local right = 4

local varLength = {

	normal = {
		min = 30,
		max = 100,
	},
	short = {
		min = 20,
		max = 40,
	},
	long = {
		min = 100,
		max = 130,
	}	
}

local rnd = math.random 

-- Class constructor
function randomPattern:init(lineManager)
	
	self.id = "random"
	self.mode = "normal"
	self.lineManager = lineManager
end

-- Randomize length
function randomPattern:randomizeLength( )

	local mode = self.mode
	local min = varLength[mode]["min"]
	local max = varLength[mode]["max"]

	return rnd(min, max)
end



-- Calculate direction
function randomPattern:randomizeDir(length)

	local lastLine = self.lineManager.lastLine

	local lastLineDir, x1, y1

	if lastLine then
		lastLineDir = lastLine.dir
		x1, y1 = lastLine.x2, lastLine.y2
	end

	if lastLineDir == up or lastLineDir == down then

		if x1 - length < padding then
			return right
		elseif x1 + length > screenWidth - padding then
			return left
		else
			return rnd(left, right)
		end

	elseif lastLineDir == left or lastLineDir == right then

		if y1 - length < padding then
			return down
		elseif y1 + length > screenHeight - padding then
			return up
		else
			return rnd(up, down)
		end
	else

		return rnd(up, right)
	end
end


-- Calculate next line's dierction, length and position
function randomPattern:calcNextLine()

	local length = self:randomizeLength()
	local dir = self:randomizeDir(length)
	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	return x1, y1, x2, y2, dir
end

return randomPattern