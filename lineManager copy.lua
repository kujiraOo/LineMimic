-- File: lineManager.lua

-- This static class adds new animated lines to screen. 
-- Saves this lines to table and provides methods to access this lines.

-- Imports
local animatedLineSegment = require("animatedLineSegment")
local lineColorManager = require("lineColorManager")
local composer = require("composer")
local playerDataManager = require("playerDataManager")
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

local MAX_N_BRIGHT_LINES = 10

local PENALTY_SPEED = 3

-- Game over constants
local GO_N_ADDITIONAL_LINES = 30 -- number of additional lines for the game over effect
local GO_MAX_LINES = 1200 -- maximum number of lines for the game over effect
local GO_LINE_SPEED1 = 15
local GO_LINE_SPEED2 = 0.5 -- line speed when game over screen animation ends


-- Functions
local rnd = math.random
local floor = math.floor

local function roundUp( n, dp )
	return floor(n * 10 ^ dp) / 10 ^ dp
end

local function isSuccessfulRoll(chance)

	chance = chance / 100

	return rnd() < chance
end


local function initDebugInfoGroup(speed, acceleration, speedUpMoves, nLines, isSpeedUpPhase, variableLengthMode )
	local fontSize = 15

	local group = display.newGroup( )

	group.speed = display.newText(  group, "s: "..speed, 10, 10 , native.systemFont, fontSize)
	group.speed.anchorX = 0
	group.speed:setFillColor( 0 )

	group.acceleration = display.newText(  group, "a: "..acceleration, 10, 40, native.systemFont, fontSize )
	group.acceleration.anchorX = 0
	group.acceleration:setFillColor( 0 )

	group.speedUpMoves = display.newText(  group, speedUpMoves, 10, 70, native.systemFont, fontSize )
	group.speedUpMoves.anchorX = 0
	group.speedUpMoves:setFillColor( 0 )

	group.nLines = display.newText( group, nLines, 10, 100, native.systemFont, fontSize)
	group.nLines.anchorX = 0
	group.nLines:setFillColor( 0 )

	group.isSpeedUpPhase = display.newText( group, "su:"..tostring(isSpeedUpPhase), 10, 130, native.systemFont, fontSize)
	group.isSpeedUpPhase.anchorX = 0
	group.isSpeedUpPhase:setFillColor( 0 )

	group.varLengthMode = display.newText( group, "vm:"..tostring(variableLengthMode), 10, 160, native.systemFont, fontSize)
	group.varLengthMode.anchorX = 0
	group.varLengthMode:setFillColor( 0 )

	return group
end

function lineManager:updateDebugInfoGroupText()

	local group = self.debugInfoGroup
	local speed = self.speed
	local acceleration = self.acceleration
	local speedUpMoves = self.speedUpMoves
	local nLines = #self.linesTable
	local isSpeedUpPhase = self.isSpeedUpPhase
	local variableLengthMode = self.variableLengthMode

	group.speed.text = "s: "..roundUp(speed, 2)
	group.acceleration.text = "a: "..roundUp(acceleration, 3)
	group.speedUpMoves.text = speedUpMoves
	group.nLines.text = nLines
	group.isSpeedUpPhase.text = "su: "..tostring(isSpeedUpPhase)
	group.varLengthMode.text = "vm: "..variableLengthMode
end


-- Methods
function lineManager:init(config)

	self.linesTable = {} -- Here new lines are saved. 
	self.linesToCheck = {}

	self.config = config

	self.speed = self.config.startSpeed
	self.acceleration = self.config.baseAcceleration
	self.phase = "warmUp"
	self.sessionMaxSpeed = self.speed
	
	self.view = display.newGroup( )

	self.newLineAlpha = lineColorManager.NEW_LINE_ALPHA

	self.speedUpMoves = 0
	self.isSpeedUpPhase = false
	self.isAccelerationHelpOn = false
	self.variableLengthMode = "normal"
	self.nVarLengthLines = 0
	self.isActive = true

	self.debugInfoGroup = initDebugInfoGroup(self.speed, self.acceleration, self.speedUpMoves, #self.linesTable, self.isSpeedUpPhase, self.variableLengthMode)

	self:initAccelerationTimer()

	self.pattern = randomPattern:new(self)

	Runtime:addEventListener( "gamePaused", self)
	Runtime:addEventListener( "gameResumed", self)
	Runtime:addEventListener( "powerUpCollected", self )
	
	self:nextLine()
end

local function onAccelerationTimer(event)

	local lineManager = event.source.params.lineManager
	local speed = lineManager.speed
	local acceleration = lineManager.config.baseAcceleration
	local phase = lineManager.phase
	local timerHandle = lineManager.accelerationTimerHandle
	local normalSpeed = lineManager.config.normalSpeed

	if phase == "gameOver" then
		timer.cancel( timerHandle )
	else
		speed = speed + acceleration
		lineManager.speed = speed

		if phase ~= "main" and speed > normalSpeed then
			lineManager.phase = "main"
		end
	end
end

-- Create acceleration timer if acceleration depends on time
function lineManager:initAccelerationTimer()

	local accelerationType = self.config.accelerationType
	local delay = 1000 * self.config.accelerationDelay

	if accelerationType == "time" then
	
		local timerHandle = timer.performWithDelay( delay, onAccelerationTimer, 0 )
		timerHandle.params = {lineManager = self}

		self.accelerationTimerHandle = timerHandle
	end
end

-- On game paused
function lineManager:gamePaused( )
	print("pause game")

	local lastLine = self.linesTable[#self.linesTable]
	local freezeTimer = self.freezeTimer

	lastLine.isPaused = true

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
			line:setColor(lineColorManager.CHECKED_LINE_COLOR)
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
	local nLinesToCheck = #self.linesToCheck

	local line = animatedLineSegment:new(self.view, x1, y1, x2, y2)
	line.dir = dir
	
	-- Set action after animation for the line. Action is to call a function that
	-- creates next line, this creating a loop of functions adding new lines.
	if isLineManagerActive then
		line:setActionAfterAnimation(lineManager.nextLine, self)
	end
	
	line:setSpeed(self.speed)
	line:setColor(lineColorManager.UNCHECKED_LINE_COLOR)
	
	-- If it's game over phase set all lines alpha to LINE_ALPHA1 (30% transparent)
	if phase == "gameOver" then

		line.alpha = lineColorManager.LINE_ALPHA1
	else
		if nLinesToCheck >= MAX_N_BRIGHT_LINES / 2 then 
			line.alpha = lineColorManager.LINE_ALPHA2
		else
			line.alpha = self.newLineAlpha
		end
	end

	self.lastLine = line
	table.insert(self.linesTable, line)
	table.insert(self.linesToCheck, line)
end


function lineManager:addNextLine()

	local pattern = self.pattern

	local x1, y1, x2, y2, dir = pattern:calcNextLine()
	
	self:addNewLine(x1, y1, x2, y2, dir)
end

function lineManager:addFirstLine()

	local x1 = WIDTH / 2
	local y1 = HEIGHT / 2
	local x2 = x1
	local y2 = y1 - 50
	local dir = 1

	self:addNewLine(x1, y1, x2, y2, dir)
end


function lineManager:nextLine() -- adds next line to the screen

	local maxNumLines = self.config.maxNumLines
	local accelerationType = self.config.accelerationType

	local nLines = #self.linesTable
	local nUncheckedLines = #self.linesToCheck
	local phase = self.phase

	if nLines > 0 then -- Create new line starting from the end of the previous line
		self:addNextLine()
	else -- Otherwise create new line at a random position
		self:addFirstLine()
	end
	
	if phase == "gameOver" then
		self:manageSpeedOnGameOver()
	else
		self:manageSpeedOnNextLine()
		self:manageModesOnNextLine()
		self:manageLinesAlphaOnNextLine()

		-- If player falls too far behind then game is over
		if nUncheckedLines >= maxNumLines then
			self:gameOver()
		end
	end
	

	self:updateDebugInfoGroupText()
end

-- Manage mode and phases on next line
function lineManager:manageModesOnNextLine( )

	local phase = self.phase

	if phase == "main" then

		local speedUpEnableType = self.config.speedUpEnableType
		local speedUpDisableType = self.config.speedUpDisableType
		local isVariableLengthEnabled = self.config.enableVariableLength
		local variableLengthChance = self.config.variableLengthChance

		local variableLengthMode = self.variableLengthMode

		if speedUpEnableType == "auto" and variableLengthMode ~= "short" then
			self:initSpeedUpPhase()
		end

		if speedUpDisableType == "auto" then
			self:countSpeedUpMoves()
		end

		--[[
		if isAccelerationHelpEnabled and nLinesToCheck >= linesToEnableAccHelp then
			self.isAccelerationHelpOn = true
		end]]


		if variableLengthMode == "normal" and isVariableLengthEnabled and isSuccessfulRoll(variableLengthChance) then
			self:initVariableLengthMode()
		end

		if variableLengthMode == "short" or variableLengthMode == "long" then
			self:countVarLengthLines()
		end

		local patternId = self.pattern.id

		if patternId == "random" and isSuccessfulRoll(20) then

			if rnd() > 0.5 then
				self.pattern = chainPattern:new(self)
			else

				if rnd() > 0.5 then
					self.pattern = spiralPattern:new(self)
				else
					self.pattern = edgePattern:new(self)
				end
			end
		end

		print(self.pattern.id)
	end
end

function lineManager:manageLinesAlphaOnNextLine()

	local maxNumLines = self.config.maxNumLines

	local nLines = #self.linesTable
	local linesTable = self.linesTable

	local oldLine = linesTable[nLines - maxNumLines]

	if oldLine then
		oldLine:setAlpha(lineColorManager.INACTIVE_LINE_ALPHA)
	end
end


-- Decrease acceleration based on normal acceleration type
function lineManager:updateAcceleration( )

	local normAccelerationMult = self.config.normAccelerationMult
	local baseAcceleration = self.config.baseAcceleration
	local normAccelerationType = self.config.normAccelerationType

	local speed = self.speed
	local isAccelerationHelpOn = self.isAccelerationHelpOn

	if isAccelerationHelpOn then
		acceleration = 0
	else
		if normAccelerationType == "linear" then
			acceleration = baseAcceleration / (normAccelerationMult * speed)
		elseif normAccelerationType == "quadratic" then
			acceleration = baseAcceleration / (normAccelerationMult * speed * speed)
		end
	end

	self.acceleration = acceleration

	return acceleration
end

function lineManager:manageSpeedOnNextLine()

	local accelerationType = self.config.accelerationType

	if accelerationType == "nextLine" then

		local isNormAccelerationEnabled = self.config.enableNormAcceleration
		local normalSpeed = self.config.normalSpeed
		local speedIncrementRate = self.config.speedIncrementRate

		local isSpeedUpPhase = self.isSpeedUpPhase
		local nLines = #self.linesTable
		local debugInfoGroup = self.debugInfoGroup
		local speedUpMoves = self.speedUpMoves

		local sessionMaxSpeed = self.sessionMaxSpeed
		local acceleration = self.acceleration
		local phase = self.phase
		local speed = self.speed

		local variableLengthMode = self.variableLengthMode

		if phase == "warmUp" then -- If normal speed is reached 

			if isNormAccelerationEnabled and not isSpeedUpPhase and speed > normalSpeed then

				-- Decrease acceleration based on normal acceleration type
				self:updateAcceleration()
				phase = "main" -- Change game's phase, now line's acceleration depends on player's actions
			end

			if not isSpeedUpPhase and nLines % speedIncrementRate == 0 then
				speed = speed + acceleration
			end
		elseif phase == "main" then

			if not isSpeedUpPhase and nLines % speedIncrementRate == 0 then -- Increment line's speed on specified interval
				
				-- Decrease acceleration based on normal acceleration type
				acceleration = self:updateAcceleration()
				speed = speed + acceleration
			end
		end

		if speed > sessionMaxSpeed then
			sessionMaxSpeed = speed
		end

		self.speed = speed
		self.sessionMaxSpeed = sessionMaxSpeed
		self.phase = phase
	end
end


function lineManager:manageSpeedOnGameOver( )
	
	local isGameOverAnimationFinished = self.isGameOverAnimationFinished
	local nLines = #self.linesTable
	
	-- When game over animation is finished then dispatch event
	if not isGameOverAnimationFinished and nLines > GO_MAX_LINES then
		self.speed = GO_LINE_SPEED2
		self.acceleration = 0

		self.isGameOverAnimationFinished = true

		Runtime:dispatchEvent( {name = "gameOverAnimationFinished"} )
	end
end


function lineManager:gameOver( )
	local nLines = #self.linesTable
	local sessionMaxSpeed = roundUp(self.sessionMaxSpeed, 2)

	self.phase = "gameOver"

	-- Reset display background color
	display.setDefault( "background", 1 )

	-- Update score
    if nLines > playerDataManager.bestScore then
    	playerDataManager.bestScore = nLines
    end

    if sessionMaxSpeed > playerDataManager.bestSpeed then
    	playerDataManager.bestSpeed = sessionMaxSpeed
    end

    playerDataManager.save()

    -- Show game over overlay screen
	composer.showOverlay( "scenes.gameOverScreen", {isModal = true, 
						params = {speed = sessionMaxSpeed, score = nLines, config = self.config}})

	-- Create game over visual effect
	self.speed = GO_LINE_SPEED1

    for i = 1, GO_N_ADDITIONAL_LINES do 
       self:nextLine()
    end

    Runtime:dispatchEvent({name = "gameOver"})
end

-- Touch controller accesses this method to validate player's unput
function lineManager:checkLine(inputDir) 
	
	local canSpeedUp = self.config.canSpeedUp
	local speedUpDisableType = self.config.speedUpDisableType
	local speedUpEnableType = self.config.speedUpEnableType
	local linesToEnableAccHelp = self.config.linesToEnableAccHelp
	local isAccelerationHelpEnabled = self.config.enableAccelerationHelp

	local nLinesToCheck = #self.linesToCheck
	local linesToCheck = self.linesToCheck

	if nLinesToCheck > 0 then
		local line = linesToCheck[1]
		
		if inputDir == line.dir then -- If input is correct then mark the line
			line:setColor(lineColorManager.CHECKED_LINE_COLOR)
			self:manageLinesAlphaOnCheck()
			table.remove(linesToCheck, 1)

			if speedUpDisableType == "playerInput" then
				self:countSpeedUpMoves()
			end

			if isAccelerationHelpEnabled and nLinesToCheck < linesToEnableAccHelp then
				self.isAccelerationHelpOn = false
			end

		elseif speedUpEnableType == "playerInput" then

			self:initSpeedUpPhase()
		end
	end
end

function lineManager:manageLinesAlphaOnCheck()
	local nextUncheckedLine = self.linesToCheck[MAX_N_BRIGHT_LINES / 2 + 1]
	if nextUncheckedLine then
		nextUncheckedLine:setAlpha(self.newLineAlpha)
	end
	
	local oldCheckedLine = self.linesTable[#self.linesTable - #self.linesToCheck - MAX_N_BRIGHT_LINES / 2] 
	if oldCheckedLine and oldCheckedLine.alpha > lineColorManager.LINE_ALPHA2 then
		oldCheckedLine:setAlpha(lineColorManager.LINE_ALPHA2)
	end
end


function lineManager:speedUp( )

	local isMovesRandomInterval = self.config.enableMovesRandomInterval
	local movesRandomInterval = self.config.movesRandomInterval
	local movesToDisableSpeedUp = self.config.movesToDisableSpeedUp

	self.isSpeedUpPhase = true
	self.speed = self.speed + PENALTY_SPEED

	if isMovesRandomInterval then
		self.movesToDisableSpeedUp = rnd(movesToDisableSpeedUp, 
										movesToDisableSpeedUp + movesRandomInterval)
	else
		self.movesToDisableSpeedUp = movesToDisableSpeedUp
	end
	
end

function lineManager:initSpeedUpPhase()

	local canSpeedUp = self.config.canSpeedUp
	local isSpeedUpPhase = self.isSpeedUpPhase

	if canSpeedUp and not isSpeedUpPhase then

		local speedUpEnableType = self.config.speedUpEnableType

		-- Activate speed up phase
		if speedUpEnableType == "playerInput" then
			
			display.setDefault( "background", 1, 0.87, 0.87 )
			self:speedUp()

		-- In auto mode activation has a certain chance
		elseif speedUpEnableType == "auto" then

			local speedUpEnableChance = self.config.speedUpEnableChance

			if isSuccessfulRoll(speedUpEnableChance) then

				self:speedUp()
			end
		end
	end
end

function lineManager:countSpeedUpMoves()
	
	local isSpeedUpPhase = self.isSpeedUpPhase

	if isSpeedUpPhase then

		local movesToDisableSpeedUp = self.movesToDisableSpeedUp

		self.speedUpMoves = self.speedUpMoves + 1
		
		if self.speedUpMoves > movesToDisableSpeedUp then
			self:disableSpeedUpPhase()
		end
	end
end

function lineManager:disableSpeedUpPhase( )

	local speed = self.speed
	local normalSpeed = self.config.normalSpeed

	speed = speed - PENALTY_SPEED

	if speed < normalSpeed then
		speed = normalSpeed
	end

	self.speed = speed
	self.speedUpMoves = 0
	self.isSpeedUpPhase = false
	display.setDefault( "background", 1 )
end

function lineManager:initVariableLengthMode( )

	local isSpeedUpPhase = self.isSpeedUpPhase

	local d = rnd()
	print(d)
	
	if not isSpeedUpPhase and d > 0.5 then
		self.variableLengthMode = "short"
	else
		self.variableLengthMode = "long"
	end
end

function lineManager:countVarLengthLines(  )
	
	local nVarLengthLines = self.nVarLengthLines
	local nLinesToDisableVarLength = self.config.linesToDisableVarLength

	nVarLengthLines = nVarLengthLines + 1

	if nVarLengthLines >= nLinesToDisableVarLength then

		self.variableLengthMode = "normal"
		nVarLengthLines = 0
	end

	self.nVarLengthLines = nVarLengthLines
end

function lineManager:stop()

	local accelerationTimerHandle = self.accelerationTimerHandle
	local freezeTimerHandle = self.freezeTimer

	for i = 1, #self.linesTable do
		self.linesTable[i].isPaused = true
	end

	if freezeTimerHandle then
		timer.cancel( freezeTimerHandle )
	end
	
	timer.cancel( accelerationTimerHandle )

	Runtime:removeEventListener( "gamePaused", self )
	Runtime:removeEventListener( "gameResumed", self )
	Runtime:removeEventListener( "powerUpCollected", self )

	self.linesTable = nil
	self = nil
end


return lineManager
