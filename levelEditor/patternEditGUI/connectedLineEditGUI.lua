---------------------------------------------------------------------------------
-- This class provides grafical interface for editing connected line pattern
-- It provides 2 buttons
-- Delete last segment
-- Move the entire pattern
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Local imports
---------------------------------------------------------------------------------
local patternEditGUI = require("levelEditor.patternEditGUI.patternEditGUI")
local elGUIButton = require("levelEditor.patternEditGUI.elGUI.elButton.elGUIButton")
local widget = require("widget")

---------------------------------------------------------------------------------
-- Class delcaration
---------------------------------------------------------------------------------
local connectedLineEditGUI = patternEditGUI:extend("levelEditor.connectedLineEditGUI")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function connectedLineEditGUI:init(pattern)
	
	self.super.init(self, pattern)
	self:initDeleteButton()
end


---------------------------------------------------------------------------------
-- Delete last segment button touched
---------------------------------------------------------------------------------
local function deleteButtonTouched(event)

	local phase = event.phase
	local button = event.target
	local pattern = button.params.pattern
	local editGUI = pattern.editGUI
	local moveButton = button.params.moveButton
	
	if phase == "ended" then

		editGUI:remove(pattern.lastEl)
		pattern:deleteLastSegment()

		local lastEl = pattern.lastEl

		if lastEl then

			button.x, button.y = lastEl.x2, lastEl.y2
			moveButton:updateViewPosition()

		else 

			moveButton.isVisible = false
			button.isVisible = false
		end

		editGUI:showElGUIs(true)
	end

	return true
end

---------------------------------------------------------------------------------
-- Init delete last segment button
---------------------------------------------------------------------------------
function connectedLineEditGUI:initDeleteButton()

	local view = self.view
	
	local button = widget.newButton{

		width = 24,
		height = 24,
		defaultFile = "gfx/editGUI/deleteDefault.png",
		overFile = "gfx/editGUI/deleteOver.png",
		onEvent = deleteButtonTouched,
	}

	button.isVisible = false

	view:insert(button)

	button.params = {
		moveButton = self.moveButton,
		pattern = self.pattern,
	}

	self.deleteButton = button
end

---------------------------------------------------------------------------------
-- Show edit gui
---------------------------------------------------------------------------------
function connectedLineEditGUI:show()

	self.view.isVisible = true

	local lastEl = self.pattern.lastEl
	
	if lastEl then

		local deleteButton = self.deleteButton
		
		deleteButton.x, deleteButton.y = lastEl.x2, lastEl.y2
		deleteButton.isVisible = true
	end
end

return connectedLineEditGUI