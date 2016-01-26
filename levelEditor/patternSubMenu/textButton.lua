---------------------------------------------------------------------------------
-- Pattern sub menu text button class
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local textButton = class("levelEditor.patternSubMenuTextButton")
local elColor = require("levelEditor.color").elColor

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function textButton:init(patternSubMenu, label, onRelease, y)

	self.pattern = patternSubMenu.patternMenuButton.pattern

	self.patternSubMenu = patternSubMenu
	
	self:initView(label, onRelease, y)
end

---------------------------------------------------------------------------------
-- Init button's widget
---------------------------------------------------------------------------------
function textButton:initView(label, onRelease, y)

	local width = self.patternSubMenu.width
	local height = self.patternSubMenu.height
	local patternSubMenu = self.patternSubMenu
	
	local view = widget.newButton{

		x = 0.5 * width,
		y = y,
		label = label,
		labelColor = {default = {elColor.r, elColor.g, elColor.b}, over = {elColor.r, elColor.g, elColor.b}},
		font = "Helvetica",
		fontSize = 12,
		onRelease = onRelease,
		shape = "roundedRect",
		width = 60,
		height = 30,
		cornerRadius = 4,
		fillColor = {default = {0, 0}, over = {0, 0}},
		strokeColor = {default = {elColor.r, elColor.g, elColor.b}, over = {elColor.r, elColor.g, elColor.b}},
		strokeWidth = 2,
	}

	self.view = view

	view.object = self

	patternSubMenu.view:insert(view)
	patternSubMenu.renameButton = self
end


return textButton