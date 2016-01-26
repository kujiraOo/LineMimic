-- File: directionPatter/chainPattern.lua

-- This pattern is a spiral from edges of the screen to the center

-- Imports
local pattern = require("directionPattern.pattern")
local randomPattern = require("directionPattern.randomPattern")

-- Class declaration
local chainPattern = pattern:extend("chainPattern")

-- Local constatns
local up = 1
local down = 2
local left = 3
local right = 4

local topEdge = 40
local rightEdge = display.contentWidth - 10
local leftEdge = 10
local bottomEdge = display.contentHeight - 40

local centerX = 0.5 * display.contentWidth
local centerY = 0.5 * display.contentHeight

local length = 60

-- Class constructor
function  chainPattern:init(lineManager)
	
	self.id = "chain"
	self.lineManager = lineManager
	
	self:choseInitialPhase()

	self.nSubs = 10
	self.subCount = 0

	self.topEdge = topEdge
	self.rightEdge = rightEdge
	self.leftEdge = leftEdge
	self.bottomEdge = bottomEdge
end

-- Main function that calculates line's directions
function chainPattern:calcNextLine( )

	local phase = self.phase
	
	if phase == "subleft" or phase == "subright" then
		return self:onSubPhase()
	elseif phase == "uturn" then
		return self:onUturnPhase()
	end
end


-- Chose direction of pattern's main phase right/left
function chainPattern:choseInitialPhase( )


	local lastX = self.lineManager.lastX
	local lastDir = self.lineManager.lastDir

	if lastX then
		if lastX + 1.5 * length > rightEdge then
			self.phase = "subleft"
		else
			self.phase = "subright"
		end

		if lastDir == up or lastDir == down then
			self.stepCount = 0
		else
			self.stepCount = 1
		end
	else
		self.phase = "subleft"
		self.stepCount = 1
	end
end


-- Make one step of right phase
function chainPattern:subStep( )
	
	local step = self.stepCount
	local length = length
	local dir, hDir1, hDir2

	if self.phase == "subleft" then
		hDir1 = left
		hDir2 = right
	else
		hDir1 = right
		hDir2 = left
	end

	if step == 0 then
		dir = hDir1
		length = 0.5 * length

	elseif step == 1 then
		dir = up
		length = 0.5 * length 

	elseif step == 2 then
		dir = hDir1
		length = 0.5 * length

	elseif step == 3 then
		dir = down

	elseif step == 4 then
		dir = hDir2
		length = 0.5 * length

	elseif step == 5 then
		dir = up
		length = 0.5 * length

	elseif step == 6 then
		dir = hDir1
	end


	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	step = step + 1 

	if step > 6 then
		step = 1
		self.subPatternComplete = true
	end

	self.stepCount = step

	return x1, y1, x2, y2, dir
end



-- Right phase
function chainPattern:onSubPhase( )

	if self.subPatternComplete then

		self:onSubPatternComplete()
	end

	if self.phase == "uturn" then
		return self:calcNextLine()
	else
		return self:subStep()
	end
end

function chainPattern:onSubPatternComplete( )

	local subCount = self.subCount
	local nSubs = self.nSubs


	self:checkUturn()

	if subCount > nSubs then
		self.isComplete = true
	end

	self.subCount = subCount + 1

	self.subPatternComplete = false
end

-- Checks if subpattern has enough room to move in the same direction
-- If subpattern doesn't have enough room then pattern's phase is set to
-- "uturn"
function chainPattern:checkUturn( )

	print("checking uturn ")
	
	local lastX = self.lineManager.lastX
	local phase = self.phase

	if phase == "subleft" and lastX - length < leftEdge then

		self.phase = "uturn"

	elseif phase == "subright" and lastX + length > rightEdge then

		self.phase = "uturn"
	end
end

-- Calculates whether the line goes up or down after a horizontal
-- sequence of subpatterns
function chainPattern:uturnVertDir()
	
	local uturnLastDir = self.uturnLastDir
	local length = 1.5 * length
	local lastY = self.lineManager.lastY

	if uturnLastDir then
		
		if self:traverseEdge(uturnLastDir, length) then
			return self:reverseDir(uturnLastDir)
		else
			return uturnLastDir
		end

	else
		if lastY > centerY then
			self.uturnLastDir = up
			return up
		else
			self.uturnLastDir = down
			return down
		end
	end
end

function chainPattern:onUturnPhase( )

	local lastLine = self.lineManager.lastLine
	local lastDir = lastLine.dir
	local preLastDir = self.lineManager.preLastDir
	local dir
	local length = length

	if lastDir == left or lastDir == right then
		
		dir = self:uturnVertDir()

		length = 1.5 * length
	else
		if preLastDir == left then
			dir = right
			self.phase = "subright"
		else
			dir = left
			self.phase = "subleft"
		end

		length = 0.5 * length
	end

	local x1, y1 = self:calcStartPoint(dir)
	local x2, y2 = self:calcEndPoint(length, dir, x1, y1)

	return x1, y1, x2, y2, dir
end


return chainPattern