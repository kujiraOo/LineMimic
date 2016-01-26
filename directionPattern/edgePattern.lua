-- File directionPattern/edge.lua

-- Line goes to the top edge then in "teeth" like motion reaches the right 
-- edge of the screen and circles the screen clockwise
-- Has 5 phases: center, top, right, bottom, left

--Imports
local pattern = require("directionPattern.pattern")
local randomPattern = require("directionPattern.randomPattern")

-- Class declaration
local edgePattern = pattern:extend("edge")

-- Local constatns
local up = 1
local down = 2
local left = 3
local right = 4

local topEdge = 25
local rightEdge = display.contentWidth - 25
local leftEdge = 25
local bottomEdge = display.contentHeight - 25

local length = 30

local rnd = math.random

-- Class constructor
function edgePattern:init( lineManager )
	
	print("passing lineManager", lineManager)

	self.lineManager = lineManager
	self.id = "edge"
	self.phase = "center"
end

-- Main function that calculates line's attributes for line manager
function edgePattern:calcNextLine( )

	local phase = self.phase
	
	if phase == "center" then
		return self:onCenterPhase()
	elseif phase == "top" then
		return self:onTopPhase()
	elseif phase == "right" then
		return self:onRightPhase()
	elseif phase == "bottom" then
		return self:onBottomPhase()
	elseif phase == "left" then
		return self:onLeftPhase()
	end
end

function edgePattern:onCenterPhase()

	local lastDir = self.lineManager.lastLine.dir

	local dir

	if lastDir == up or lastDir == down then
		dir = right
		self.phase = "right"
	else 
		dir = up
		self.phase = "top"
	end

	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2

	if dir == up then 
		x2 = x1
		y2 = topEdge
	else
		x2 = rightEdge
 		y2 = y1
	end

	return x1, y1, x2, y2, dir
end

-- Calculate line's direction on top phase
function edgePattern:calcTopDir(lastDir)

	preLastDir = self.lineManager.linesTable[#self.lineManager.linesTable - 1].dir
	lastDir = self.lineManager.lastLine.dir

	if lastDir == up or lastDir == down then
		return right
	elseif preLastDir == down then 
		return up
	else
		return down
	end
end

-- Calculate line's direction on top phase
function edgePattern:onTopPhase( )
	
	local dir = self:calcTopDir()
	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	if rightEdge - x1 < length and (dir == right or dir == down) then
		self.phase = "right"
	end

	return x1, y1, x2, y2, dir
end

-- Calc line's direction on right phase
function edgePattern:calcRightDir()

	preLastDir = self.lineManager.linesTable[#self.lineManager.linesTable - 1].dir
	lastDir = self.lineManager.lastLine.dir

	if lastDir == left or lastDir == right then
		return down
	elseif preLastDir == left then 
		return right
	else
		return left
	end
end

-- Calc line's direction on right phase
function edgePattern:onRightPhase( )
	
	local dir = self:calcRightDir()
	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	if bottomEdge - y1 < length and (dir == left or dir == down) then
		self.phase = "bottom"
	end

	return x1, y1, x2, y2, dir
end


-- Calc line's direction on bottom phase
function edgePattern:calcBottomDir()

	preLastDir = self.lineManager.linesTable[#self.lineManager.linesTable - 1].dir
	lastDir = self.lineManager.lastLine.dir

	if lastDir == down or lastDir == up then
		return left
	elseif preLastDir == up then 
		return down
	else
		return up
	end
end

-- Calc line's direction on bottom phase
function edgePattern:onBottomPhase( )
	
	local dir = self:calcBottomDir()
	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	if x1 - leftEdge < length and (dir == up or dir == right) then
		self.phase = "left"
	end

	return x1, y1, x2, y2, dir
end

-- Calc line's direction on bottom phase
function edgePattern:calcLeftDir()

	preLastDir = self.lineManager.linesTable[#self.lineManager.linesTable - 1].dir
	lastDir = self.lineManager.lastLine.dir

	if lastDir == left or lastDir == right then
		return up
	elseif preLastDir == left then 
		return right
	else
		return left
	end
end

-- Calc line's direction on bottom phase
function edgePattern:onLeftPhase( )

	local lineManager= self.lineManager
	
	local dir = self:calcLeftDir()
	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	if y1 - topEdge < 2 * length then
		self.isComplete = true
	end

	return x1, y1, x2, y2, dir
end


return edgePattern