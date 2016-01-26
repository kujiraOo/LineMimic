-- File level/level4.lua

-- First text level
-- Contains 3 stages:
-- 100 lines in random pattern, normal length
-- 50 lines in short
-- Spiral 

-- Imports
local level = require ("level.level")
local touchElementManager = require("touchElementManager")
local touchController = require("touchController")
local checkManager = require("checkManager")
local alphaManager = require("alphaManager")
local lineManager = require("lineManager")
local randomPattern = require("directionPattern.randomPattern")
local spiralPattern = require("directionPattern.spiralPattern")
local flower = require("flower")
local composer = require("composer")

-- Class declaration
local level4 = level:extend("level4")

-- Native cache
local tableInsert = table.insert

-- Local constatnts
local centerX = 0.5 * display.contentWidth
local centerY = 0.5 * display.contentHeight

local up = 1
local down = 2
local left = 3
local right = 4

local config = {
	startSpeed = 2,
	startX = centerX,
	startY = centerY
}

local nLinesStage1 = 12
local nElsStage2 = 3

-- Class constructor
function level4:init()

	self.super.init(self, config)

	self.phase = "stage1"
	self.stageCount = 0
end

local function createNextLinesTable ()

	local length = 100
	local width = 2

	local t = {}

	for i = 0, 2 do

		local x = centerX - 0.5 * length
		local y = 50 + i * 150

		tableInsert(t, {x, y, x + length, y, right})
		tableInsert(t, {x + length + width, y - width, x + length + width, y + length, down})
		tableInsert(t, {x + length + 2 * width , y + length, x + width, y + length, left})
		tableInsert(t, {x, y + length + width, x, y - width, up})
	end

	return t
end

function level4:initManagers( )

	local checkManager = checkManager:new(self)
	self.checkManager = checkManager

	local alphaManager = alphaManager:new(self)
	self.alphaManager = alphaManager

	local touchElementManager = touchElementManager:new(self)
	touchElementManager.nextElementsTable = {{centerX, 100}, {centerX, 250}, {centerX, 400}}
	touchElementManager.currentElementClass = flower
	self.touchElementManager = touchElementManager

	local lineManager = lineManager:new(self)
	lineManager.nextLines = createNextLinesTable()
	self.lineManager = lineManager

	self.touchController = touchController:new(checkManager)
end


function level4:start( )
	
	self.lineManager:nextLine()
end

-- Restart
function level4:reset( )

	self:destroy()

	self.elementsView = display.newGroup( )
	self.view:insert(self.elementsView)

	self:initManagers()
	self.phase = "stage1"
	self.stageCount = 0
end

-- Update level4, so it can change phases etc
function level4:update( )

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
function level4:checkGameOver( )
end

-- 100 segments in random pattern, normal length
function level4:updateStage1( )
	
	self.stageCount = self.stageCount + 1

	local stageCount = self.stageCount

	if stageCount >= nLinesStage1 then
		self:initStage2()
	end
end

-- Init stage 2
function level4:initStage2( )
	
	self.stageCount = 0

	self.phase = "stage2"
	self.lineManager.pattern = nil

	self.touchElementManager:nextElement()
end

-- Update stage 2
function level4:updateStage2( )
	
	self.stageCount = self.stageCount + 1

	local stageCount = self.stageCount

	if stageCount >= nElsStage2 then
		self.stageCount = 0
		self:initStage3()
	end
end

-- Init stage 3
function  level4:initStage3( )

	print("init stage 3")

	local lineManager = self.lineManager

	self.phase = "stage3"
	self.lineManager.pattern = spiralPattern:new(lineManager)
	lineManager.speed = 10
	lineManager:nextLine()
end

function level4:updateStage3( )
	
	local patternPhase = self.lineManager.pattern.phase

	if patternPhase == "complete" then
		self:complete()
	end
end

function level4:checkGameOver( )
	
	local nEls = #self.checkManager.elementsToCheck

	if nEls > 15 then
		self:gameOver()
	end
end

function level4:complete( )

	self:destroy()
	composer.gotoScene( "scenes.levelComplete", {effect = "fromTop", params = {isFinalLevel = true}} )
end

return level4