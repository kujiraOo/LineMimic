---------------------------------------------------------------------------------
-- This is submenu for an element
-- For now submenu will contain
-- size
-- x
-- y
-- parameters that you are able to adjust
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
-------------------------q-------------------------------------------------------
local elSubMenu = require("levelEditor.patternEditGUI.elGUI.elSubMenu.subMenu")
local sizeStepper = require("levelEditor.patternEditGUI.elGUI.elSubMenu.stepper.sizeStepper")

---------------------------------------------------------------------------------
-- Class delcaration
---------------------------------------------------------------------------------
local elSubMenuTouchEl = elSubMenu:extend("levelEditor.elSubMenuTouchEl")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function elSubMenuTouchEl:init(editGUI, buttonsGroup, el)

	self.super.init(self, editGUI, buttonsGroup, el)

	sizeStepper:new(self, self.el, 3)
end

return elSubMenuTouchEl