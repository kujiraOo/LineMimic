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
local textButtonCopy = textButton:extend("levelEditor.patternSubMenutextButtonCopy")

---------------------------------------------------------------------------------
-- Rename button released
---------------------------------------------------------------------------------
local function onRelease(event)

	local copyButton = event.target.object
	local pattern = copyButton.patternSubMenu.patternMenuButton.pattern
	local level = pattern.view.parent.object
	local patternSubMenuView = copyButton.patternSubMenu.view

	patternSubMenuView.isVisible = false
	level:copyPattern(pattern)
end


---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function textButtonCopy:init(patternSubMenu, y)
	
	self.super.init(self, patternSubMenu, "copy", onRelease, y)
end

return textButtonCopy