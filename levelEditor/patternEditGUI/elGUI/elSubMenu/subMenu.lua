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
local posStepper = require("levelEditor.patternEditGUI.elGUI.elSubMenu.stepper.posStepper")

---------------------------------------------------------------------------------
-- Class delcaration
---------------------------------------------------------------------------------
local subMenu = class("levelEditor.subMenu")

---------------------------------------------------------------------------------
-- local constants
---------------------------------------------------------------------------------
local offset = 40
local bgWidth = 110
local BG_HEIGHT = 130

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function subMenu:init(editGUI, elGUI, el, bgHeight)

	self.editGUI = editGUI
	self.elGUI = elGUI
	self.el = el
	self.bgHeight = bgHeight or BG_HEIGHT

	self:initView()
	self:initBackground()
	self:addPosSteppers()
end

---------------------------------------------------------------------------------
-- Init view
-- View is display group and it's get inserted into elGUI of the element
---------------------------------------------------------------------------------
function subMenu:initView()

	local elGUIView = self.elGUI.view
	local elView = self.el.view
	
	local view = display.newGroup( )
	elGUIView:insert(view)

	view.object = self

	view.y = offset

	view.isVisible = false

	self.view = view
end

---------------------------------------------------------------------------------
-- Background is a semitransparent black rect
---------------------------------------------------------------------------------
function subMenu:initBackground()
	
	local view = self.view 

	local bgHeight = self.bgHeight
	local bg = display.newRect(view, 0, 0, bgWidth, bgHeight )

	bg.anchorX = 0
	bg.anchorY = 0

	bg:setFillColor( 0, 0.5 )
end

---------------------------------------------------------------------------------
-- Testing the stepper
---------------------------------------------------------------------------------
function subMenu:addPosSteppers()
	
	local stepperX = posStepper:new(self, self.el, 1, "x")
	local stepperY = posStepper:new(self, self.el, 2, "y")

	self.stepperX = stepperX
	self.stepperY = stepperY
end

---------------------------------------------------------------------------------
-- Update text of the x and y steppers
---------------------------------------------------------------------------------
function subMenu:updateXYText()

	local textX = self.stepperX.text
	local textY = self.stepperY.text
	local el = self.el
	local x = el.x + el.view.x
	local y = el.y + el.view.y

	textX.text = "x: "..x
	textY.text = "y: "..y
end


return subMenu