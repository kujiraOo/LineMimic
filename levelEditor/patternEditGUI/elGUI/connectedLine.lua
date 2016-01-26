---------------------------------------------------------------------------------
-- Import
---------------------------------------------------------------------------------
local elGUI = require("levelEditor.patternEditGUI.elGUI.elGUI")
local connectedLineSubMenu = require("levelEditor.patternEditGUI.elGUI.elSubMenu.connectedLine")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local connectedLine = elGUI:extend("connectedLine")

---------------------------------------------------------------------------------
-- Overwrite the parent method, need only sub menu button
---------------------------------------------------------------------------------
function elGUI:createButtons()
	
	elSubMenuButton:new(self, elGUI, el, elGUI.SUB_MENU_BUTTON_X)
end

---------------------------------------------------------------------------------
-- Create submenu
---------------------------------------------------------------------------------
function elGUI:createSubMenu()

	connectedLineSubMenu:new(self.patternEditGUI, self, self.el, self.pattern)
end

return connectedLine