---------------------------------------------------------------------------------
-- This is connectedLine for connectedLine pattern
-- It fill contain only len stepper
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
-------------------------q-------------------------------------------------------
local elSubMenu = require("levelEditor.patternEditGUI.elGUI.elSubMenu.subMenu")
local lenStepper = require("levelEditor.patternEditGUI.elGUI.elSubMenu.stepper.lenStepper")

---------------------------------------------------------------------------------
-- Class delcaration
---------------------------------------------------------------------------------
local connectedLine = elSubMenu:extend("levelEditor.connectedLine")

---------------------------------------------------------------------------------
-- local constants
---------------------------------------------------------------------------------
local offset = 40
local bgWidth = 110
local bgHeight = 50

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function connectedLine:init(editGUI, elGUI, el, pattern)

	self.super.init(self, editGUI, elGUI, el, bgHeight)

	self.pattern = pattern

	self:addLenStepper()
end


---------------------------------------------------------------------------------
-- Overwrite method of connectedLine, because this connectedLine doesn't need any
-- x y steppers
---------------------------------------------------------------------------------
function connectedLine:addPosSteppers()
end


function connectedLine:addLenStepper( )

	local listenerTable = {
		
		listenerFunction = self.pattern.updateElsOnLenChange,
		arg1 = self.pattern,
		arg2 = self.el,
	}

	lenStepper:new(self, self.el, 1, listenerTable)
end


return connectedLine