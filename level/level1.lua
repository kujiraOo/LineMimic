-- File level/level1.lua

-- First text level
-- Contains 3 stages:
-- 100 lines in random pattern, normal length
-- 50 lines in short
-- Spiral 

-- Imports
local level = require ("level.level")
local randomPattern = require("directionPattern.randomPattern")
local spiralPattern = require("directionPattern.spiralPattern")

-- Class declaration
local level1 = level:extend("level1")

-- Local constatnts
local centerX = 0.5 * display.contentWidth
local centerY = 0.5 * display.contentHeight


local config = {
	startSpeed = 1,
	startX = centerX,
	startY = centerY,
	acceleration = 0.1,
	incRate = 1
}

local maxNUncheckedLines = 15
local nStage1Lines = 25
local nStage2Lines = 65

-- Class constructor
function level1:init()

	level1.super.init(self, config)

	self.id = 1
	self.phase = "stage1"

	self:initLineManager(randomPattern)
end

function level1:start( )
	
	self.lineManager:nextLine()
end

-- Restart
function level1:reset( )

	self:destroy()

	self.elementsView = display.newGroup( )
	self.view:insert(self.elementsView)

	self:initManagers()
	self.phase = "stage1"
	self:initLineManager(randomPattern)
end

-- Update level1, so it can change phases etc
function level1:update( )

	local phase = self.phase

	if phase == "stage1" then
		self:updateStage1()
	elseif phase == "stage2" then
		self:updateStage2()
	elseif phase == "stage3" then
		self:updateStage3()
	end

	self:checkGameOver()
end

-- Check game over
function level1:checkGameOver( )

	local nUncheckedLines = #self.checkManager.elementsToCheck
	
	if nUncheckedLines > maxNUncheckedLines then
		self:gameOver()
	end
end

-- 100 segments in random pattern, normal length
function level1:updateStage1( )
	local nLines = #self.lineManager.linesTable

	if nLines > nStage1Lines then
		self:initStage2()
	end
end

-- Init stage 2
function level1:initStage2( )
	
	self.phase = "stage2"
	self.lineManager.pattern.mode = "short"
	self.accelerationManager.isActive = false
	self.lineManager.speed = 1
end

-- Update stage 2
function level1:updateStage2( )
	
	local nLines = #self.lineManager.linesTable

	if nLines > nStage2Lines then
		self:initStage3()
	end
end

-- Init stage 3
function  level1:initStage3( )

	local lineManager = self.lineManager

	self.phase = "stage3"
	self.lineManager.pattern = spiralPattern:new(lineManager)
	lineManager.speed = 10
end

function level1:updateStage3( )
	
	local patternPhase = self.lineManager.pattern.phase

	if patternPhase == "complete" then
		self:complete()
	end
end

return level1