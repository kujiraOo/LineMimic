-- File: directionPattern.random.lua

-- Works with line direction
-- Calculates next line segment's direction and coordinates, has random mode and several patterns

-- Imports
local animatedLineSegment = require("element.animatedLineSegment")

-- Class declaration
local randomConnectedLine = class("randomConnectedLine")

-- Local constatnts
local padding = 10
local paddingTop = 50
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

local nDirs = 4
local up = 1
local down = 2
local left = 3
local right = 4

local halfWidth = 2

local varLen = {

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

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function randomConnectedLine:init(params, view)
	
	self.x, self.y, self.view = params.x, params.y, view

	self.numSegments = params.numSegments
	self.lenChangeRate = params.lenChangeRate
	self.normChance = params.normChance * 0.01
	self.shortChance = params.shortChance * 0.01

	self.mode = self:choseLenMode()
end



------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function randomConnectedLine:choseLenMode( )
	
	local normChance = self.normChance
	local shortChance = self.shortChance
	
	local roll = rnd()

	if roll > normChance + shortChance then

		return "long"
	elseif roll > normChance then

		return "short"
	else

		return "normal"
	end
end

------------------------------------------------------------------------------------
-- This method return an instance of animatedLineSegment
-- Each time this method is called elId var is increased, so next time a new
-- segment from elsData table will be added to the screen
------------------------------------------------------------------------------------
function randomConnectedLine:nextEl(speed)

	local elsData = self.elsData
	local elId = self.elId

	local parentView = self.view
	local len = self:randomizeLen()
	local dir = self:randomizeDir(len)
	local x, y = self:calcStartPoint(dir)

	self.lastX, self.lastY, self.lastDir, self.lastLen = x, y, dir, len

	return animatedLineSegment:new(parentView, x, y, dir, len, speed)
end

------------------------------------------------------------------------------------
-- Randomize len
------------------------------------------------------------------------------------
function randomConnectedLine:calcStartPoint(dir)

	if self.lastX then

		return self:calcNextStartPoint(dir)
	else

		return self.x, self.y
	end
end

------------------------------------------------------------------------------------
-- Randomize len
------------------------------------------------------------------------------------
function randomConnectedLine:randomizeLen( )

	local mode = self.mode
	local min = varLen[mode]["min"]
	local max = varLen[mode]["max"]

	return rnd(min, max)
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
local function calcEndPoint(x, y, dir, len)
	
	if dir == up then

		return x, y - len

	elseif dir == down then

		return x, y + len

	elseif dir == left then

		return x - len, y

	else

		return x + len, y
	end
end

------------------------------------------------------------------------------------
-- Calculate direction
------------------------------------------------------------------------------------
function randomConnectedLine:randomizeDir(len)

	local lastX, lastY, lastDir, lastLen = self.lastX, self.lastY, self.lastDir, self.lastLen

	if lastX then 
		local lastX2, lastY2 = calcEndPoint(lastX, lastY, lastDir, lastLen)

		if lastDir == up or lastDir == down then

			if lastX2 - len < padding then
				return right
			elseif lastX2 + len > screenWidth - padding then
				return left
			else
				return rnd(left, right)
			end

		elseif lastDir == left or lastDir == right then

			if lastY2 - len < paddingTop then
				return down
			elseif lastY2 + len > screenHeight - padding then
				return up
			else
				return rnd(up, down)
			end
		end
	else

		return rnd(up, right)
	end
end

------------------------------------------------------------------------------------
-- This method calculates the starting point of first or next sement from the
-- segmentsData table
-- It takes into account direction of the current segment and of the last segment
-- to assure proper connection of both segments
------------------------------------------------------------------------------------
function randomConnectedLine:calcNextStartPoint(currentDir)

	local lastX, lastY, lastDir, lastLen = self.lastX, self.lastY, self.lastDir, self.lastLen
	local x, y

	if lastDir == up then -- to avoid line start and end points intersection
		
		y = lastY - lastLen + halfWidth
	elseif lastDir == down then

		y = lastY + lastLen - halfWidth
	elseif lastDir == left then

		x = lastX - lastLen + halfWidth
	elseif lastDir == right then

		x = lastX + lastLen - halfWidth
	end

	if lastDir == up or lastDir == down then

		if currentDir == left then

			x = lastX - halfWidth
		else

			x = lastX + halfWidth
		end
	else

		if currentDir == up then

			y = lastY - halfWidth
		else

			y = lastY + halfWidth
		end
	end

	return x, y
end

return randomConnectedLine