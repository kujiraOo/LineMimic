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
local lenStepper = require("levelEditor.patternEditGUI.elGUI.elSubMenu.stepper.lenStepper")

---------------------------------------------------------------------------------
-- Class delcaration
---------------------------------------------------------------------------------
local separatedLineSubMenu = elSubMenu:extend("levelEditor.separatedLineSubMenu")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function separatedLineSubMenu:init(editGUI, elGUI, el)

	self.super.init(self, editGUI, elGUI, el)

	lenStepper:new(self, self.el, 3)
end

return separatedLineSubMenu