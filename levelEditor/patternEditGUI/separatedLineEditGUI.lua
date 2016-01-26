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
local separatedLineEditGUI = patternEditGUI:extend("levelEditor.separatedLineEditGUI")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function separatedLineEditGUI:init(pattern)
	
	self.super.init(self, pattern)
end


return separatedLineEditGUI