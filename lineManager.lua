-- File: lineManager.lua

-- This static class adds new animated lines to screen. 
-- Saves this lines to table and provides methods to access this lines.

-- Imports
local animatedLineSegment = require("animatedLineSegment")
local color = require("color")
local randomPattern = require("directionPattern.randomPattern")
local edgePattern = require("directionPattern.edgePattern")
local spiralPattern = require("directionPattern.spiralPattern")
local chainPattern = require("directionPattern.chainPattern")

-- Class declaration
local lineManager = class("lineManager")

-- Constants
local PADDING = 20
local WIDTH = display.contentWidth
local HEIGHT = display.contentHeight

local defaultConfig = {
	maxNumLines = 30,
}

-- Functions
local rnd = math.random
local floor = math.floor
local tableRemove = table.remove

local function roundUp( n, dp )
	return floor(n * 10 ^ dp) / 10 ^ dp
end

local function isSuccessfulRoll(chance)

	chance = chance / 100

	return rnd() < chance
end


local function initDebugInfoGroup(speed, nLines)
	local fontSize = 15

	local group = display.newGroup( )

	group.speed = display.newText(  group, "s: "..speed, 10, 10 , native.systemFont, fontSize)
	group.speed.anchorX = 0
	group.speed:setFillColor( 0 )


	group.nLines = display.newText( group, nLines, 10, 40, native.systemFont, fontSize)
	group.nLines.anchorX = 0
	group.nLines:setFillColor( 0 )

	return group
end

function lineManager:updateDebugInfoGroupText()
	if self.linesTable then

		local group = self.debugInfoGroup
		local speed = self.speed
		local nLines = #self.linesTable

		group.speed.text = "s: "..roundUp(speed, 2)
		group.nLines.text = nLines
	end
end


-- Methods
function lineManager:init(level)

	self.linesTable = {} -- Here new lines are saved. 
	self.nextLines = {} 

	self.level = level

	self.config = level.config

	self.speed = level.config.startSpeed
	
	self.view = display.newGroup( )

	self.isActive = true

	self.debugInfoGroup = initDebugInfoGroup(self.speed, #self.linesTable)

	Runtime:addEventListener( "gamePaused", self)
	Runtime:addEventListener( "gameResumed", self)
	Runtime:addEventListener( "powerUpCollected", self )
end


-- On game paused
function lineManager:gamePaused( )
	print("pause game")

	local lastLine = self.lastLine
	local freezeTimer = self.freezeTimer

	if lastLine then
		lastLine.isPaused = true
	end

	if freezeTimer then
		timer.pause( freezeTimer )
	end
end

-- On game resumed
function lineManager:gameResumed( )

	local lastLine = self.linesTable[#self.linesTable]
	local freezeTimer = self.freezeTimer

	if freezeTimer then

		timer.resume( freezeTimer )
	else
		lastLine.isPaused = false
	end
end


----------------------------------------------------------------
-- Power up Section
----------------------------------------------------------------

-- Decrease line's speed when speedDown power up is collected
-- Speed cannot be less than 0.5
function lineManager:speedDown( )

	local speed = self.speed
	local normalSpeed = self.config.normalSpeed
	local baseAcceleration = self.config.baseAcceleration
	local normalSpeed = self.config.normalSpeed
	local speedDown = self.config.speedDown
	
	speed = speed - speedDown

	if speed < normalSpeed then
		speed = normalSpeed
	end

	self.speed = speed
end

-- Resume line after freeze 
local function onFreezeTimer( event )

	local lineManager = event.source.params.lineManager
	local lastLine = lineManager.linesTable[#lineManager.linesTable]
	local isFreezeStacked = lineManager.isFreezeStacked

	if isFreezeStacked then

		lineManager.isFreezeStacked = false
		lineManager:initFreezeTimer()
	else

		lastLine.isPaused = false
		lineManager.freezeTimer = nil
	end
end

-- Handle the situation where player collects one more freeze power up while lineManager is frozen
function lineManager:stackFreeze( )
	
	local isFreezeStacked = self.isFreezeStacked

	if not isFreezeStacked then

		self.isFreezeStacked = true
	end
end

function lineManager:initFreezeTimer( )

	local freezeTime = 1000 * self.config.freezeTime

	local freezeTimer = timer.performWithDelay( freezeTime, onFreezeTimer )
	freezeTimer.params = {lineManager = self}

	self.freezeTimer = freezeTimer
end

-- Pause line for specified time when power up is collected
function lineManager:freeze( )

	local freezeTimer = self.freezeTimer

	-- If a freezeTime is running
	if freezeTimer then
		
		lineManager:stackFreeze()
	else

		local lastLine = self.linesTable[#self.linesTable]
		lastLine.isPaused = true
		self:initFreezeTimer()
	end
end

function lineManager:fill( )
	
	local linesToCheck = self.linesToCheck

	for i = 1, #linesToCheck do

		local line = linesToCheck[1]

		if line then
			line:setColor(color.standard.checked)
			self:manageLinesAlphaOnCheck()
			table.remove(linesToCheck, 1)
		end
	end
end


function lineManager:powerUpCollected( event )

	local kind = event.kind

	if kind == "speedDown" then
		self:speedDown()
	elseif kind == "freeze" then
		self:freeze()
	elseif kind == "fill" then
		self:fill()
	end
end


-- Add new line to the screen
function lineManager:addNewLine(x1, y1, x2, y2, dir)

	local isLineManagerActive = self.isActive
	local view = self.level.elementsView

	local line = animatedLineSegment:new(view, x1, y1, x2, y2)
	line.dir = dir

	line:setActionAfterAnimation(lineManager.onLineSegmentComplete, self)
	
	line:setSpeed(self.speed)
	line:setColor(color.standard.unchecked)

	self:registerLastLine(x2, y2, dir, line)

	table.insert(self.linesTable, line)

	self.level.checkManager:addElement(line)
	self.level.alphaManager:addElement(line)
end

function lineManager:onLineSegmentComplete( )
	
	local isActive = self.isActive
	local pattern = self.pattern

	self.level:update()

	if pattern and pattern.isLastLine then
		pattern.isComplete = true
	end

	if self.isActive then
		self:nextLine()
	end
end

function lineManager:registerLastLine(x2, y2, dir, line)
	
	local lastLine = self.lastLine

	if lastLine then
		self.preLastLine = lastLine
		self.preLastX = lastLine.x2
		self.preLastY = lastLine.y2
		self.preLastDir = lastLine.dir
	end

	self.lastLine = line
	self.lastX = x2
	self.lastY = y2
	self.lastDir = dir
end


function lineManager:addNextLine()

	local pattern = self.pattern
	local nl = self.nextLines[1]

	local x1, y1, x2, y2, dir

	if nl then

		x1, y1, x2, y2, dir = nl[1], nl[2], nl[3], nl[4], nl[5]
		tableRemove(self.nextLines, 1)

	elseif pattern then

		x1, y1, x2, y2, dir = pattern:calcNextLine()
	end
	
	if pattern and pattern.phase ~= "complete" or nl then
		self:addNewLine(x1, y1, x2, y2, dir)
	elseif pattern and pattern.phase == "complete" then
		self.level:update()
	end
end


function lineManager:nextLine() -- adds next line to the screen

	local accelerationManager = self.level.accelerationManager

	self:addNextLine()

	if accelerationManager then
		accelerationManager:update()
	end

	self:updateDebugInfoGroupText()
end


function lineManager:destroy()

	print("destroy line manager")

	self.isActive = false
	self.lastLine.isPaused = true

	self.view:removeSelf( )
	self.debugInfoGroup:removeSelf()

	local freezeTimerHandle = self.freezeTimer

	if freezeTimerHandle then
		timer.cancel( freezeTimerHandle )
	end

	Runtime:removeEventListener( "gamePaused", self )
	Runtime:removeEventListener( "gameResumed", self )
	Runtime:removeEventListener( "powerUpCollected", self )

	self.linesTable = nil
	self = nil
end


return lineManager
