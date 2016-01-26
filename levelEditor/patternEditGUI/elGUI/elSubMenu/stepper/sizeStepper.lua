---------------------------------------------------------------------------------
--Parent class for steppers of element's submenu
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local stepper = require("levelEditor.patternEditGUI.elGUI.elSubMenu.stepper.stepper")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local elSubMenuStepperSize = stepper:extend("levelEditor.elSubMenuStepperSize")

---------------------------------------------------------------------------------
-- What when x stepper is pressed
---------------------------------------------------------------------------------
local function onPress(event)

	local phase = event.phase
	local el = event.target.params.el
	local text = event.target.params.text
	local buttonsGroup = event.target.params.subMenu.view.parent

	if event.phase == "increment" then

		el:resize(el.size + 1)

	elseif event.phase == "decrement" then

		el:resize(el.size - 1)
	end

	text.text = "size: "..(el.size)
end

---------------------------------------------------------------------------------
-- Class constructor
-- subMenu - subMenu of the element
-- el - element
-- key - string of the value to change
-- pos - position in the subMenu
---------------------------------------------------------------------------------
function elSubMenuStepperSize:init(subMenu, el, pos)

	self.super.init(self, subMenu, el, "size", pos, onPress)
end

return elSubMenuStepperSize