-- File: directionPatter/spiralPattern.lua

-- This pattern is a spiral from edges of the screen to the center

-- Imports
local pattern = require("directionPattern.pattern")
local randomPattern = require("directionPattern.randomPattern")

-- Class declaration
local spiralPattern = pattern:extend("spiralPattern")

-- Local constatns
local up = 1
local down = 2
local left = 3
local right = 4

local topEdge = 10
local rightEdge = display.contentWidth - 10
local leftEdge = 10
local bottomEdge = display.contentHeight - 10

-- Class constructor
function  spiralPattern:init(lineManager)
	
	self.id = "spiral"
	self.lineManager = lineManager
	self.phase = "center"

	self.hLength = rightEdge - leftEdge
	self.vLength = bottomEdge - topEdge
end

-- Main function that calculates line's directions
function  spiralPattern:calcNextLine( )

	local phase = self.phase
	
	if phase == "center" then
		return self:onCenterPhase()
	elseif phase == "edge" then
		return self:onEdgePhase()
	elseif phase == "spiral" then
		return self:onSpiralPhase()
	end
end

-- Calculate line's dir in center phase. Move line to bottom, or left edge of the screen
function spiralPattern:onCenterPhase(  )
	
	local lastDir = self.lineManager.lastLine.dir
	local dir

	if lastDir == up or lastDir == down then
		dir = left
	else
		dir = down
	end

	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2

	if dir == left then
		x2 = leftEdge
		y2 = y1
	else
		x2 = x1
		y2 = bottomEdge
	end

	self.phase = "edge"

	return x1, y1, x2, y2, dir
end

function spiralPattern:onEdgePhase( )
	
	local lastDir = self.lineManager.lastLine.dir
	local dir

	if lastDir == left then
		dir = down
	else 
		dir = right
	end

	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2

	if dir == down then
		x2 = x1
		y2 = bottomEdge
	else
		x2 = rightEdge
		y2 = y1
	end

	self.phase = "spiral"

	return x1, y1, x2, y2, dir
end

-- Main phase of the pattern draws a spiral
function spiralPattern:onSpiralPhase( )

	local lastDir = self.lineManager.lastLine.dir
	local lineManager = self.lineManager
	local dir, length

	if lastDir == down then
		dir = right
	elseif lastDir == right then
		dir = up
	elseif lastDir == up then
		dir = left
	elseif lastDir == left then
		dir = down
	end

	if dir == down or dir == up then
		length = self.vLength
		self.vLength = self.vLength - 20
	else
		length = self.hLength
		self.hLength = self.hLength - 20
	end

	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	if self.hLength < 20 then
		self.phase = "complete"
	end

	return x1, y1, x2, y2, dir
end


return spiralPattern