---------------------------------------------------------------------------------
-- Sub menu for patern menu contains 
-- acceleration stepper
-- speed stepper
-- button for renaming the pattern
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")
local stepperSheet = require("levelEditor.textureManager").stepperSheet
local textButtonRename = require("levelEditor.patternSubMenu.textButtonRename")
local textButtonDelete = require("levelEditor.patternSubMenu.textButtonDelete")
local textButtonCopy = require("levelEditor.patternSubMenu.textButtonCopy")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local patternSubMenu = class("levelEditor.patternSubMenu")

---------------------------------------------------------------------------------
-- Local constatns
---------------------------------------------------------------------------------
local elColor = {r = 0.6, g = 0.9, b = 1}

local width = 130
local height = 200

local elHeight = 30

local margin = 10
local stepperY = 10
local accY = stepperY + elHeight

local renameButtonY = 3 * elHeight
local deleteButtonY = 4 * elHeight
local copyButtonY = 5 * elHeight

---------------------------------------------------------------------------------
-- Public constatns
---------------------------------------------------------------------------------
patternSubMenu.width = width
patternSubMenu.height = height

---------------------------------------------------------------------------------
-- Class constructor
-- Takes pattern menu button as argument and is linked to it
---------------------------------------------------------------------------------
function patternSubMenu:init(patternMenuButton)

	self.patternMenuButton = patternMenuButton

	view = display.newGroup( )
	view.x = margin + 0.5 * (patternMenuButton.width - width)
	view.y = patternMenuButton.y + patternMenuButton.height

	patternMenuButton.parent:insert(view)
	self.view = view

	self:initBackground()

	self:initSpeedStepperGroup()
	self:initAccStepperGroup()
	textButtonRename:new(self, renameButtonY)
	textButtonDelete:new(self, deleteButtonY)
	textButtonCopy:new(self, copyButtonY)
	self:initColorGroup()

	view:addEventListener( "tap", function () return true end ) -- Stop propagation of tap event
end

---------------------------------------------------------------------------------
-- Init background
---------------------------------------------------------------------------------
function patternSubMenu:initBackground()
	
	local rect = display.newRect( self.view, 0, 0, width, height )
	rect:setFillColor( 0, 0.8 )
	rect.anchorX = 0
	rect.anchorY = 0
end

---------------------------------------------------------------------------------
-- Init speed group's text
---------------------------------------------------------------------------------
local function initGroupText(group, defaultText)
	
	local text = display.newText( group, defaultText, 0, 0.5 * elHeight, "Helvetica", 12 )
	text:setTextColor( elColor.r, elColor.g, elColor.b )

	text.anchorX = 0

	group.text = text
end

---------------------------------------------------------------------------------
-- Init speed group's stepper
---------------------------------------------------------------------------------
local function initStepper(params)

	local group = params.group
	local pattern = params.pattern
	
	local stepper = widget.newStepper{

		initialValue = params.initVal,
		minimumValue = params.minVal,
		maximumValue = params.maxVal,
		left = 60,
		width = 48,
		heigth = 24,
		sheet = stepperSheet,
		defaultFrame = 1,
		noMinusFrame = 2,
		noPlusFrame = 3,
		minusActiveFrame = 4,
		plusActiveFrame = 5,
		onPress = params.listener
	}

	stepper.group = group
	stepper.pattern = pattern

	group:insert(stepper)
end

---------------------------------------------------------------------------------
-- Change pattern's speed when stepper is pressed
---------------------------------------------------------------------------------
local function changePatternSpeed(pattern, stepperValue)
	
	pattern.speed = stepperValue * 0.1

	if stepperValue == 0 then

		pattern.speed = nil
	end
end

---------------------------------------------------------------------------------
-- Update speed stepper's text
---------------------------------------------------------------------------------
local function updateSpeedStepperGroupText(patternSpeed, groupText)
	
	if patternSpeed == nil then

		groupText.text = "speed: --"
	else 

		groupText.text = "speed: "..patternSpeed
	end
end

---------------------------------------------------------------------------------
-- Speed stepper pressed
---------------------------------------------------------------------------------
local function speedStepperPressed(event)
	
	local pattern = event.target.pattern
	local groupText = event.target.group.text
	local stepperValue = event.value

	changePatternSpeed(pattern, stepperValue)
	updateSpeedStepperGroupText(pattern.speed, groupText)

	return true
end

---------------------------------------------------------------------------------
-- Add speed stepper
---------------------------------------------------------------------------------
function patternSubMenu:initSpeedStepperGroup()

	local view = self.view
	local pattern = self.patternMenuButton.pattern

	local group = display.newGroup( )
	view:insert(group)
	group.x = margin
	group.y = stepperY
	
	initGroupText(group, "speed: 1")
	initStepper{

		initVal = 10,
		minVal = 0,
		maxVal = 200,
		listener = speedStepperPressed,
		group = group,
		pattern = pattern
	}
end

---------------------------------------------------------------------------------
-- Change pattern's acceleration when stepper is pressed
---------------------------------------------------------------------------------
local function changePatternAcc(pattern, stepperValue)

	pattern.acc = stepperValue * 0.05

	if stepperValue == -1 then

		pattern.acc = nil
	end
end

---------------------------------------------------------------------------------
-- Update text of acceleration stepper's group
---------------------------------------------------------------------------------
local function updateAccStepperGroupText(patternAcc, groupText)

	if patternAcc == nil then

		groupText.text = "acc: --"

	else

		groupText.text = "acc: "..patternAcc
	end
end

---------------------------------------------------------------------------------
-- Acceleration stepper pressed
---------------------------------------------------------------------------------
local function accStepperPressed(event)
	
	local pattern = event.target.pattern
	local groupText = event.target.group.text
	local stepperValue = event.value

	changePatternAcc(pattern, stepperValue)
	updateAccStepperGroupText(pattern.acc, groupText)

	return true
end

---------------------------------------------------------------------------------
-- Add acceleration stepper
---------------------------------------------------------------------------------
function patternSubMenu:initAccStepperGroup()
	
	local view = self.view
	local pattern = self.patternMenuButton.pattern

	local group = display.newGroup( )
	view:insert(group)
	group.x = margin
	group.y = accY

	initGroupText(group, "acc: 0")

	initStepper{

		initVal = 0,
		minVal = -1,
		maxVal = 200,
		listener = accStepperPressed,
		group = group,
		pattern = pattern,
	}
end



return patternSubMenu