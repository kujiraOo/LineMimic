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
local textButtonColor = textButton:extend("levelEditor.patternSubMenuTextButtonColor")

---------------------------------------------------------------------------------
-- Rename button released
-- Show hide patternSubMenu color window
---------------------------------------------------------------------------------
local function onRelease(event)
	
	
end



---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function textButtonColor:init(patternSubMenu, y)
	
	self.super.init(self, patternSubMenu, "color", onRelease, y)
end




return textButtonColor