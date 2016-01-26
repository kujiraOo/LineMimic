---------------------------------------------------------------------------------
--Parent class for steppers of element's submenu
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")
local color = require("levelEditor.color")
local stepperSheet = require("levelEditor.textureManager").stepperSheet

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local elSubMenuStepper = class("levelEditor.elSubMenuStepper")

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local offset = 20
local spacing = 40
local width = 100

---------------------------------------------------------------------------------
-- Class constructor
-- subMenu - subMenu of the element
-- el - element
-- key - string of the value to change
-- pos - position in the subMenu
---------------------------------------------------------------------------------
function elSubMenuStepper:init(subMenu, el, key, pos, onPress)

	self.subMenu = subMenu
	self.el = el
	self.key = key
	self.pos = pos
	self.onPress = onPress
	
	self:initGraphics()
end

---------------------------------------------------------------------------------
-- Init graphics
---------------------------------------------------------------------------------
function elSubMenuStepper:initGraphics()

	self:initView()
	self:initText()
	self:initStepper()
end


---------------------------------------------------------------------------------
-- View is displayGroupt object that is inserted into subMenu view
-- Set view's y according to its position in the subMenu
---------------------------------------------------------------------------------
function elSubMenuStepper:initView()
	
	local subMenuView = self.subMenu.view
	local pos = self.pos

	local view = display.newGroup( )
	subMenuView:insert(view)

	view.y = offset + spacing * (pos - 1)

	self.view = view
end

---------------------------------------------------------------------------------
-- Init text of the stepper
-- Text contains name of the value to change and the value itself
---------------------------------------------------------------------------------
function elSubMenuStepper:initText()

	local view = self.view
	local key = self.key
	local c = color.elColor
	
	local text = display.newText( view, key..":", 0, 0, "Helvetica", 15)
	text:setTextColor( c.r, c.g, c.b )
	text.anchorX = 0

	self.text = text
end

---------------------------------------------------------------------------------
-- The default function for stepper when it's pressed
-- It changes the specified value of the element using the key
-- Updates text
---------------------------------------------------------------------------------
local function stepperPressedDefault(event)

	local phase = event.phase
	local key = event.target.params.key
	local el = event.target.params.el
	local text = event.target.params.text

	if event.phase == "increment" then

		el[key] = el[key] + 1

	elseif event.phase == "decrement" then

		el[key] = el[key] - 1
	end

	text.text = key..": "..el[key]
end

function elSubMenuStepper:initStepper()

	local view = self.view
	
	local stepper = widget.newStepper{

		width = 48,
		heigth = 24,
		minimumValue = -math.huge,
		sheet = stepperSheet,
		defaultFrame = 1,
		noMinusFrame = 2,
		noPlusFrame = 3,
		minusActiveFrame = 4,
		plusActiveFrame = 5,
		onPress = self.onPress or stepperPressedDefault,
	}

	stepper.params = {
		key = self.key,
		el = self.el,
		text = self.text,
		subMenu = self.subMenu,
	}

	stepper.anchorY = 1
	stepper.anchorX = 1
	stepper.x = width

	self.stepperWidget = stepper

	view:insert(stepper)
end

return elSubMenuStepper