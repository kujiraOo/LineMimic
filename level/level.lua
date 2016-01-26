-- File: level/level.lua

-- Level class contains some basic functions for all levels

-- Imports
local touchController = require("touchController")
local alphaManager = require("alphaManager")
local checkManager = require("checkManager")
local drawManager = require("drawManager")
local accelManager = require("accelManager")
local composer = require("composer")

local level = class("level")

function level:init()

	print("init level")

	self.view = display.newGroup( )

	self.elView = display.newGroup( )
	self.view:insert(self.elView)

	self:initManagers()
end

function level:initManagers()
	
	print("initManagers")

	local checkManager = checkManager:new(self)
	self.checkManager = checkManager

	self.alphaManager = alphaManager:new(self)

	self.accelManager = accelManager:new(self)

	self.drawManager = drawManager:new(self)

	self.touchController = touchController:new(checkManager)
end

function level:start( )
	
	self.drawManager:nextEl()
end

-- Restart
function level:reset( )

	self:destroy()

	self.elView = display.newGroup( )
	self.view:insert(self.elView)

	self:initManagers()
end

function level:onLevelCompleteTimer( )

	self:destroy()
	composer.gotoScene( "scenes.levelComplete", {effect = "fromTop"} )
end

function level:timer( )

	self:onLevelCompleteTimer()
end

function level:complete( )

	Runtime:dispatchEvent( {name = "levelComplete"} )

	self.alphaManager:onLevelComplete()

	self.completionTimer = timer.performWithDelay( 3500, self )
end

function level:gameOver()

	self:destroy()

	composer.gotoScene( "scenes.gameOver", {effect = "fromTop"} )
end

function level:destroy( )

	if self.completionTimer then
		timer.cancel( self.completionTimer )
	end

	self.touchController:disable()

	self.drawManager:destroy()
	self.elView:removeSelf()
end

return level