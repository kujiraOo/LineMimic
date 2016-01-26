-- File: powerUpManager.lua

-- Imports
local powerUp = require("powerUp")

-- Class declaration
local powerUpManager = class("powerUpManager")

-- Local constants
local powerUpRad = 35
local powerUpOffset = 20 + powerUpRad

local hOffset = 0.5 * (display.actualContentWidth - display.contentWidth)
local vOffset = 0.5 * (display.actualContentHeight - display.contentHeight)
local leftEdge = -hOffset
local rightEdge = display.contentWidth + hOffset
local topEdge = -vOffset
local bottomEdge = display.contentHeight + vOffset

-- Local functions
local rnd = math.random

-- Chose randomly power up's type
local function randomizeKind( )

	local d = rnd(1, 3)

	if d == 1 then
		return "speedDown"
	elseif d == 2 then
		return "freeze"
	else
		return "fill"
	end
end

-- Randomize power up's direction
local function randomizeDir( ... )

	local d = rnd(1, 3)

	if d == 1 then
		return "down"
	elseif d == 2 then
		return "left"
	else
		return "right"
	end
end

-- Randomize starting position of the power up
local function randomizeCoordinate( dir )

	local x, y

	if dir == "down" then

		x = rnd (leftEdge + powerUpOffset, rightEdge - powerUpOffset)
		y = topEdge - powerUpRad

	elseif dir == "left" then

		x = rightEdge + powerUpRad
		y = rnd(topEdge + powerUpOffset, bottomEdge - powerUpOffset)

	elseif dir == "right" then

		x = leftEdge - powerUpRad
		y = rnd(topEdge + powerUpOffset, bottomEdge - powerUpOffset)
	end

	return x, y
end


-- Public functons

-- Class constructor
function powerUpManager:init(time)

	self.view = display.newGroup( )

	self.timerObject = timer.performWithDelay( 1000*time, self, 0 )

	Runtime:addEventListener( "gamePaused", self)
	Runtime:addEventListener( "gameResumed", self)
	Runtime:addEventListener( "gameOver", self )
end

-- Spawn new power up
function powerUpManager:spawnNewPowerUp( )

	local view = self.view

	local kind = randomizeKind()
	local dir = randomizeDir()
	local x, y = randomizeCoordinate(dir)

	powerUp.new(kind, view, x, y, dir, powerUpRad)
end

-- On powerUpManager's timer 
function powerUpManager:timer( )
	
	self:spawnNewPowerUp()
end

-- On game paused
function powerUpManager:gamePaused(  )

	local view = self.view
	
	for i = 1, view.numChildren do

		local powerUp = view[i]
		transition.pause( powerUp )
	end

	timer.pause( self.timerObject )
end

-- On game resumed
function powerUpManager:gameResumed(  )

	local view = self.view
	
	for i = 1, view.numChildren do

		local powerUp = view[i]
		transition.resume( powerUp )
	end

	timer.resume( self.timerObject )
end

-- When game is over
function powerUpManager:gameOver()
	
	self:destroy()
end

function powerUpManager:destroy( )

	timer.cancel( self.timerObject )
	Runtime:removeEventListener( "gamePaused", self)
	Runtime:removeEventListener( "gameResumed", self)
	Runtime:removeEventListener( "gameOver", self )
end

return powerUpManager