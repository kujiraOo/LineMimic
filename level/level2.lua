-- File level/level2.lua

-- First text level
-- Contains 3 stages:
-- 50 long random lines, speed 3
-- 15 Chain patterns
-- 30 long lines speed 4

-- Imports
local level = require ("level.level")
local accelerationManager = require("accelerationManager")
local randomPattern = require("directionPattern.randomPattern")
local chainPattern = require("directionPattern.chainPattern")

-- Class declaration
local level2 = level:extend("level2")

-- Local constatnts
local centerX = 0.5 * display.contentWidth
local centerY = 0.5 * display.contentHeight

local config = {
	startSpeed = 2,
	startX = centerX,
	startY = centerY,
	acceleration = 0.1,
	incRate = 1,
}

local maxNUncheckedLines = 15
local nLinesStage1 = 50
local nLinesStage3 = 30

-- Class constructor
function level2:init()

	level2.super.init(self, config)

	self.id = 2
	self.phase = "stage1"
	self.stageCount = 0
	
	self:initLineManager(randomPattern, "long")
end

function level2:start( )
	
	self.lineManager:nextLine()
end


-- Restart
function level2:reset( )

	self:destroy()

	self.elementsView = display.newGroup( )
	self.view:insert(self.elementsView)

	self:initManagers()
	self.phase = "stage1"
	self.stageCount = 0
	self:initLineManager(randomPattern, "long")
end

-- Update level2, so it can change phases etc
function level2:update( )

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
function level2:checkGameOver( )

	local nUncheckedLines = #self.checkManager.elementsToCheck
	
	if nUncheckedLines > maxNUncheckedLines then
		self:gameOver()
	end
end

-- 100 segments in random pattern, normal length
function level2:updateStage1( )
	local nLines = #self.lineManager.linesTable

	if nLines > nLinesStage1 then
		self:initStage2()
	end
end

-- Init stage 2
function level2:initStage2( )
	
	self.phase = "stage2"
	self.lineManager.pattern = chainPattern(self.lineManager)
	self.accelerationManager.isActive = false
	self.lineManager.speed = 1.5
end

-- Update stage 2
function level2:updateStage2( )

	local isPatternComplete = self.lineManager.pattern.isComplete

	if isPatternComplete then
		self:initStage3()
	end
end

-- Init stage 3
function  level2:initStage3( )

	local lineManager = self.lineManager

	self.phase = "stage3"
	self.lineManager.pattern = randomPattern:new(lineManager)
	self.lineManager.pattern.mode = "long"
	lineManager.speed = 7
end

function level2:updateStage3( )

	local stageCount = self.stageCount

	if stageCount > nLinesStage3 then
		self:complete()
	end

	self.stageCount = stageCount + 1
end

return level2