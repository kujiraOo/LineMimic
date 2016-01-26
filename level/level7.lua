-- File level/level7.lua

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local level = require ("level.level")
local accelManager = require("accelManager")
local color = require("color")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local level7 = level:extend("level7")

------------------------------------------------------------------------------------
-- Native cache
------------------------------------------------------------------------------------
local tableInsert = table.insert

------------------------------------------------------------------------------------
-- Local constatnts
------------------------------------------------------------------------------------
local centerX = 0.5 * display.contentWidth
local centerY = 0.5 * display.contentHeight

local up = 1
local down = 2
local left = 3
local right = 4

local padding = 10

------------------------------------------------------------------------------------
-- Table of behaviours for level
-- Format:
-- pattern name, x, y, params
-- speed field
------------------------------------------------------------------------------------
level7.behaviours = {
	{
		pattern = "randomConnectedLine", 
		params = {
			x = 200, 
			y = 200, 
			numSegments = 100,	
			lenChangeRate = 20,
			normChance = 100,
			shortChance = 0,
		}, 
		speed = 1.5
	}
}

level7.accel = 0.1
level7.speedIncRate = 3
level7.completionSpeed = 5.2

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function level7:init()

	self.super.init(self)

	self.accelManager = accelManager:new(self)

	self.id = 7

	self.maxNumEls = 10

	self:initGUI()
end

function level7:initGUI( )

	local uc = color.standard.unchecked
	local cc = color.standard.checked
	
	local GUIview = display.newGroup( )
	self.view:insert(GUIview)

	local speedText =  display.newText( GUIview, self.drawManager.speed, centerX, 0, "Helvetica", 24 )
	speedText:setTextColor( uc.r, uc.g,  uc.b)
	speedText.anchorY = 0

	self.speedText = speedText

	local objectiveText =  display.newText (GUIview, "reach speed "..level7.completionSpeed, centerX, centerY, "Helvetica", 24)
	objectiveText:setTextColor( cc.r, cc.g,  cc.b)

	self.textTimer = timer.performWithDelay( 3000, function ( )
		objectiveText:removeSelf()
	end)
end

function level7:GUIonCompletion( )

	local cc = color.standard.checked

	local speedText = self.speedText
	
	--speedText:setTextColor( cc.r, cc.g, cc.b )
	--transition.to( speedText, {time = 200, size = 100, y = 50} )
end

function level7:destroy(  )
	
	self.super.destroy(self)

	timer.cancel( self.textTimer )
end


return level7