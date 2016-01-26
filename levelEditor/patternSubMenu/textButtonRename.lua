---------------------------------------------------------------------------------
-- Pattern sub menu text button class
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local textButton = require("levelEditor.patternSubMenu.textButton")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local textButtonRename = textButton:extend("levelEditor.patternSubMenuTextButtonRename")

---------------------------------------------------------------------------------
-- Rename button released
---------------------------------------------------------------------------------
local function onRelease(event)
	
	local renameButton = event.target.object
	local label = renameButton.patternSubMenu.patternMenuButton.label
	local textField = renameButton.textField
	local patternSubMenuView = renameButton.patternSubMenu.view

	patternSubMenuView.isVisible = false
	label.isVisible = false

	textField.isVisible = true
	textField.text = label.text

	native.setKeyboardFocus(textField)
end

---------------------------------------------------------------------------------
-- Text input listener for rename textfield
---------------------------------------------------------------------------------
local function textListener(event)
	
	local textField = event.target
	local label = textField.patternMenuButtonLabel
	local phase = event.phase

	if phase == "submitted" then

		label.text = textField.text
		textField.pattern.name = textField.text
	end

	if phase == "ended" or phase == "submitted" then

		textField.isVisible = false
		label.isVisible = true
	end
end

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function textButtonRename:init(patternSubMenu, y)
	
	self.super.init(self, patternSubMenu, "rename", onRelease, y)

	self:initRenameTextField()
end

---------------------------------------------------------------------------------
-- Init rename text field
---------------------------------------------------------------------------------
function textButtonRename:initRenameTextField()

	local ptm = self.patternSubMenu.patternMenuButton
	local label = ptm.label

	local textField = native.newTextField( label.x, label.y, label.width, label.height )
	textField.anchorX = 0
	textField.isVisible = false

	textField.patternMenuButtonLabel = label
	textField.pattern = self.patternSubMenu.patternMenuButton.pattern

	textField:addEventListener( "userInput", textListener )

	ptm:insert(textField)

	self.textField = textField
end


return textButtonRename