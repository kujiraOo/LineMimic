-- File level/level3.lua

-- 30 short speed 2
-- 20 long speed 8
-- edge pattern

-- Imports
local level = require ("level.level")
local composer = require ("composer")
local accelerationManager = require("accelerationManager")
local randomPattern = require("directionPattern.randomPattern")
local edgePattern = require("directionPattern.edgePattern")

-- Class declaration
local level3 = level:extend("level3")

-- Local constatnts
local centerX = 0.5 * display.contentWidth
local centerY = 0.5 * display.contentHeight

local config = {
	startSpeed = 1,
	startX = centerX,
	startY = centerY,
	acceleration = 0.05,
	incRate = 3,
}

local maxNUncheckedLines = 15
local nLinesStage1 = 30
local nLinesStage2 = 20

-- Class constructor
function level3:init()

	level3.super.init(self, config)

	self.id = 3

	self.phase = "stage1"
	self.stageCount = 0

	self:initLineManager(randomPattern, "short")
end

function level3:start( )
	self.lineManager:nextLine()
end

-- Restart
function level3:reset( )

	self:destroy()

	self.elementsView = display.newGroup( )
	self.view:insert(self.elementsView)

	self:initManagers()

	self.phase = "stage1"
	self.stageCount = 0
	self:initLineManager(randomPattern, "short")
end


-- Check game over
function level3:checkGameOver( )

	local nUncheckedLines = #self.checkManager.elementsToCheck
	
	if nUncheckedLines > maxNUncheckedLines then
		self:gameOver()
	end
end

-- 100 segments in random pattern, normal length
function level3:updateStage1( )
	local stageCount = self.stageCount

	if stageCount > nLinesStage1 then
		self:initStage2()
	else
		self.stageCount = stageCount + 1
	end
end

-- Init stage 2
function level3:initStage2( )
	
	self.phase = "stage2"
	self.stageCount = 0
	self.lineManager.pattern.mode = "long"
	self.accelerationManager.isActive = false
	self.lineManager.speed = 4
end

-- Update stage 2
function level3:updateStage2( )

	local stageCount = self.stageCount

	if stageCount > nLinesStage2 then
		self:initStage3()
	else
		self.stageCount = stageCount + 1
	end
end

-- Init stage 3
function  level3:initStage3( )

	local lineManager = self.lineManager

	self.phase = "stage3"
	self.lineManager.pattern = edgePattern:new(lineManager)
	lineManager.speed = 1.3
end

function level3:updateStage3( )
	
	local isPatternComplete = self.lineManager.pattern.isComplete

	if isPatternComplete then
		self:complete()
	end
end


return level3