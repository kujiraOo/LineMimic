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
local posStepper = stepper:extend("levelEditor.posStepper")

---------------------------------------------------------------------------------
-- What when x stepper is pressed
---------------------------------------------------------------------------------
local function onPress(event)

	local phase = event.phase
	local el = event.target.params.el
	local text = event.target.params.text
	local buttonsGroup = event.target.params.subMenu.view.parent
	local coordinate = event.target.params.coordinate

	if event.phase == "increment" then

		el.view[coordinate] = el.view[coordinate] + 1
		buttonsGroup[coordinate] = buttonsGroup[coordinate] + 1

	elseif event.phase == "decrement" then

		el.view[coordinate] = el.view[coordinate] - 1
		buttonsGroup[coordinate] = buttonsGroup[coordinate] - 1
	end

	text.text = coordinate..": "..(el[coordinate] + el.view[coordinate])
end

---------------------------------------------------------------------------------
-- Class constructor
-- subMenu - subMenu of the element
-- el - element
-- key - string of the value to change
-- pos - position in the subMenu
-- coordinate x or y
---------------------------------------------------------------------------------
function posStepper:init(subMenu, el, pos, coordinate)

	self.super.init(self, subMenu, el, coordinate, pos, onPress)

	self.stepperWidget.params.coordinate = coordinate
end

---------------------------------------------------------------------------------
-- Init graphics
---------------------------------------------------------------------------------
function posStepper:initGraphics()

	self:initView()
	self:initText()
	self:initStepper()
end


return posStepper