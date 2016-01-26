---------------------------------------------------------------------------------
-- Element gui class is parent class for all element's guis
-- The instance of this class is represented by a hide/show menu button,
-- and gui itself
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local elDeleteButton = require("levelEditor.patternEditGUI.elGUI.elButton.elDeleteButton")
local elGUIButton = require("levelEditor.patternEditGUI.elGUI.elButton.elGUIButton")
local moveButton = require("levelEditor.patternEditGUI.button.moveButton")
local connectedLineSubMenu = require("levelEditor.patternEditGUI.elGUI.elSubMenu.connectedLine")
local separatedLineSubMenu = require("levelEditor.patternEditGUI.elGUI.elSubMenu.separatedLine")
local touchElSubMenu = require("levelEditor.patternEditGUI.elGUI.elSubMenu.touchEl")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local elGUI = class("levelEditor.elGUI")

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local OFFSET = 10
local BUTTONS_VIEW_X = 25

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function elGUI:init(patternEditGUI, el, pattern)

	print(pattern)

	self.el = el
	self.patternEditGUI = patternEditGUI
	self.pattern = pattern

	self:initView()
	self:createButtons()
	self:createSubMenu()

	el.elGUI = self
end

---------------------------------------------------------------------------------
-- Create elGUI's view
-- A display group object
---------------------------------------------------------------------------------
function elGUI:initView()

	local el = self.el
	local patternEditGUIView = self.patternEditGUI.view
	
	local view = display.newGroup( )
	patternEditGUIView:insert(view)

	view.id = "elGUI"

	view.x = el.view.contentBounds.xMin - view.x + OFFSET
	view.y = el.view.contentBounds.yMin - view.y + OFFSET

	self.view = view
	view.obj = self
end

---------------------------------------------------------------------------------
-- Create buttons of the GUI
-- elGUI button
-- moveButton, for el move button create a listener to update pattern move button
-- deleteButton
---------------------------------------------------------------------------------
function elGUI:createButtons()
	
	local elView = self.el.view
	local el = self.el
	local patternEditGUI = self.patternEditGUI
	local editGUIName = patternEditGUI.name

	local GUIButtonX

	local buttonsView = display.newGroup( )
	self.view:insert(buttonsView)
	self.buttonsView = buttonsView
	buttonsView.isVisible = false
	buttonsView.x = BUTTONS_VIEW_X

	if editGUIName == "levelEditor.separatedLineEditGUI" or
		editGUIName == "levelEditor.touchElEditGUI" then

		self.deleteButton = elDeleteButton:new(buttonsView, patternEditGUI, el)
		self:createMoveButton()
	end

	elGUIButton:new(patternEditGUI, self, el, OFFSET)
end

---------------------------------------------------------------------------------
-- Create move button
-- for el move button create a listener to update pattern move button
---------------------------------------------------------------------------------
function elGUI:createMoveButton()

	local elView = self.el.view
	local buttonsView = self.buttonsView

	local mbListenerTable = {
		{moveButton.updateViewPosition, self.patternEditGUI.moveButton},
		{elGUI.checkBoundsExceed, self},
	}

	self.moveButton = moveButton:new(buttonsView, elView, self.view, _, _, mbListenerTable)
end

---------------------------------------------------------------------------------
-- Create submenu depending on type of the pattern edit gui
---------------------------------------------------------------------------------
function elGUI:createSubMenu()

	local editGUIName = self.patternEditGUI.name
	local patternEditGUI = self.patternEditGUI
	local el = self.el
	local pattern = self.pattern
	
	if editGUIName == "levelEditor.separatedLineEditGUI" then

		self.subMenu = separatedLineSubMenu:new(patternEditGUI, self, el)

	elseif editGUIName == "levelEditor.connectedLineEditGUI" then

		self.subMenu = connectedLineSubMenu:new(patternEditGUI, self, el, pattern)

	elseif editGUIName == "levelEditor.touchElEditGUI" then

		self.subMenu = touchElSubMenu:new(patternEditGUI, self, el)
	end
end

---------------------------------------------------------------------------------
-- If the el's gui exceeds the bound of the screen then move the view
-- inside the bounds
---------------------------------------------------------------------------------
function elGUI:checkBoundsExceed()
	
	local view = self.view

	local deltaL = view.contentBounds.xMin - OFFSET
	local deltaR = display.contentWidth - OFFSET - view.contentBounds.xMax
	local deltaU = view.contentBounds.yMin - OFFSET
	local deltaD = display.contentHeight - OFFSET - view.contentBounds.yMax

	if deltaL < 0 then

		view.x = view.x - deltaL

	elseif deltaR < 0 then

		view.x = view.x + deltaR
	end

	if deltaU < 0 then

		view.y = view.y - deltaU

	elseif deltaD < 0 then

		view.y = view.y + deltaD
	end
end

return elGUI