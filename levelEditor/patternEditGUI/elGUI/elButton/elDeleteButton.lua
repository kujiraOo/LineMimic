---------------------------------------------------------------------------------
-- Button that sticks to pattern element and allows to drag the element
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local elDeleteButton = class("levelEditor.elDeleteButton")

local offset = 40

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function elDeleteButton:init(parentView, editGUI, el)

	self.editGUI = editGUI
	self.pattern = editGUI.pattern
	self.parentView = parentView
	self.el = el
	
	self:initGraphics()
	
	self.view:addEventListener( "touch", self )
end

---------------------------------------------------------------------------------
-- Init graphics
---------------------------------------------------------------------------------
function elDeleteButton:initGraphics()

	self:initView()
end


---------------------------------------------------------------------------------
-- Init button's view
-- Buttons view is widget library button object
---------------------------------------------------------------------------------
function elDeleteButton:initView()
	
	local parentView = self.parentView

	local view = widget.newButton{

		width = 24,
		height = 24,
		defaultFile = "gfx/editGUI/deleteDefault.png",
		overFile = "gfx/editGUI/deleteOver.png",
		onEvent = deleteButtonTouched,
	}

	view.x = offset

	self.view = view
	view.obj = self

	parentView:insert(view)
end

---------------------------------------------------------------------------------
-- Touch listener
---------------------------------------------------------------------------------
function elDeleteButton:touch(event)
	
	local phase = event.phase

	if phase == "ended" then

		self:deleteEl()
	end 

	return true
end

---------------------------------------------------------------------------------
-- Delete element
-- Remove it from its group
-- Remove its buttons from editGUI layer
---------------------------------------------------------------------------------
function elDeleteButton:deleteEl()
	
	local editGUI = self.editGUI
	local pattern = self.pattern
	local el = self.el

	pattern:remove(el)
	editGUI:remove(el)
	editGUI:showElGUIs(true)
end

return elDeleteButton