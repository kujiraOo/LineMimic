---------------------------------------------------------------------------------
--Parent class for steppers of element's submenu
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local stepper = require("levelEditor.patternEditGUI.elGUI.elSubMenu.stepper.stepper")
local lineMath = require("lineMath")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local elSubMenuStepperLen = stepper:extend("levelEditor.elSubMenuStepperLen")

---------------------------------------------------------------------------------
-- Calc coordinate difference
---------------------------------------------------------------------------------
local function calcDifference(el, lenChangeDir)

	local dir = el.dir
	
	local d

	if dir == lineMath.up or dir == lineMath.left then

		d = -1

	elseif dir == lineMath.down or dir == lineMath.right then

		d = 1
	end

	return d * lenChangeDir -- If the change is negative then inverse
end

---------------------------------------------------------------------------------
-- Increase the length of the line segment
-- Change the x2 or y2
-- fix
---------------------------------------------------------------------------------
local function changeLength(el, d)

	local dir = el.dir

	local x2, y2 = el.x2, el.y2

	if dir == lineMath.right or dir == lineMath.left then

		x2 = x2 + d

	elseif dir == lineMath.down or dir == lineMath.up then

		y2 = y2 + d
	end

	el:fix(x2, y2)
end


---------------------------------------------------------------------------------
-- Call listener function of the stepper widget
---------------------------------------------------------------------------------
local function callListener(d, listenerTable)

	if listenerTable then

		local listenerFunction = listenerTable.listenerFunction
		local arg1 = listenerTable.arg1
		local arg2 = listenerTable.arg2

		listenerFunction(arg1, arg2, d)
	end
end

---------------------------------------------------------------------------------
-- What when x stepper is pressed
---------------------------------------------------------------------------------
local function onPress(event)

	local phase = event.phase
	local el = event.target.params.el
	local text = event.target.params.text
	local buttonsGroup = event.target.params.subMenu.view.parent

	local listenerTable = event.target.params.listenerTable

	local d

	if event.phase == "increment" then

		d = calcDifference(el, 1)

	elseif event.phase == "decrement" then

		d = calcDifference(el, -1)
	end

	changeLength(el, d)
	callListener(d, listenerTable)

	text.text = "len: "..(el.len)
end

---------------------------------------------------------------------------------
-- Class constructor
-- subMenu - subMenu of the element
-- el - element
-- key - string of the value to change
-- pos - position in the subMenu
--
---------------------------------------------------------------------------------
function elSubMenuStepperLen:init(subMenu, el, pos, listenerTable)

	self.super.init(self, subMenu, el, "len", pos, onPress)
	self.stepperWidget.params.listenerTable = listenerTable
end

return elSubMenuStepperLen