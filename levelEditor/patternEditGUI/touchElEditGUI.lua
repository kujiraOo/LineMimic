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

---------------------------------------------------------------------------------
-- Class delcaration
---------------------------------------------------------------------------------
local touchElEditGUI = patternEditGUI:extend("levelEditor.touchElEditGUI")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function touchElEditGUI:init(pattern)
	
	self.super.init(self, pattern)
end


---------------------------------------------------------------------------------
-- Init view 
---------------------------------------------------------------------------------
function touchElEditGUI:initView()

	local levelEditGUIView = self.pattern.levelEditor.level.editGUIView
	local view = display.newGroup( )

	levelEditGUIView:insert(view)
	self.view = view

	self.view.isVisible = false
end




return touchElEditGUI