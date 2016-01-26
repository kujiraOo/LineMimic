---------------------------------------------------------------------------------
-- Edit gui super class
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local patternEditGUI = class("levelEditor.patternEditGUI")
local moveButton = require("levelEditor.patternEditGUI.button.moveButton")
local elGUI = require("levelEditor.patternEditGUI.elGUI.elGUI")

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local SUB_MENU_BUTTON_X = 70

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function patternEditGUI:init(pattern)

	self.pattern = pattern

	self:initView()
	self:initPatternMoveButton()
end


---------------------------------------------------------------------------------
-- Init view 
---------------------------------------------------------------------------------
function patternEditGUI:initView()

	local levelEditGUIView = self.pattern.levelEditor.level.editGUIView
	local view = display.newGroup( )

	levelEditGUIView:insert(view)
	self.view = view

	self.view.isVisible = false
end

---------------------------------------------------------------------------------
-- Init pattern move button
---------------------------------------------------------------------------------
function patternEditGUI:initPatternMoveButton()

	local editGUIView = self.view
	local patternView = self.pattern.view
	
	local mbListenerTable = {
		{self.checkElGUIsExceedBounds, self},
	}

	local moveButton = moveButton:new(editGUIView, patternView, editGUIView, 0.5, 0.5, mbListenerTable)

	self.moveButton = moveButton
end

---------------------------------------------------------------------------------
-- Show edit gui
---------------------------------------------------------------------------------
function patternEditGUI:show()

	self.view.isVisible = true
end

---------------------------------------------------------------------------------
-- Remove element
---------------------------------------------------------------------------------
function patternEditGUI:remove(el)

	local elGUI = el.elGUI
	elGUI.view:removeSelf( )
	elGUI = nil
end

---------------------------------------------------------------------------------
-- Add element's buttons
---------------------------------------------------------------------------------
function patternEditGUI:addEl(el)
	
	local moveButton = self.moveButton
	moveButton:updateViewPosition()

	local elGUI = elGUI:new(self, el, self.pattern)
	elGUI:checkBoundsExceed()
end

---------------------------------------------------------------------------------
-- Hide all element submenus
---------------------------------------------------------------------------------
function  patternEditGUI:showElGUIs(isVisible)

	local view = self.view

	for i = 1, view.numChildren do

		if view[i].id == "elGUI" then 

			view[i].isVisible = isVisible
		end
	end
end

---------------------------------------------------------------------------------
-- Check that none of the el guis exceed the bound fo the screen
---------------------------------------------------------------------------------
function patternEditGUI:checkElGUIsExceedBounds()
	
	local view = self.view

	for i = 1, view.numChildren do

		if view[i].id == "elGUI" then 

			local elGUI = view[i].obj

			elGUI:checkBoundsExceed()
		end
	end
end

return patternEditGUI