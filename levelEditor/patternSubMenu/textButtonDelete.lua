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
local textButtonDelete = textButton:extend("levelEditor.patternSubMenutextButtonDelete")

---------------------------------------------------------------------------------
-- Rename button released
---------------------------------------------------------------------------------
local function onRelease(event)

	local deleteButton = event.target.object
	local patternSubMenu = deleteButton.patternSubMenu
	local pattern = patternSubMenu.patternMenuButton.pattern

	pattern:removeSelf()
	patternSubMenu.view:removeSelf( )
end


---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function textButtonDelete:init(patternSubMenu, y)
	
	self.super.init(self, patternSubMenu, "delete", onRelease, y)
end




return textButtonDelete