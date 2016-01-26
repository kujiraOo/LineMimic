---------------------------------------------------------------------------------
-- This button shows and hides the GUI of the element
-- If GUI of the element is shown then it hides all GUIs of other elements
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local elGUIButton = class("levelEditor.elGUIButton")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function elGUIButton:init(editGUI, elGUI, el, x)

	self.editGUI = editGUI
	self.pattern = editGUI.pattern
	self.elGUI = elGUI
	self.el = el
	self.x = x
	
	self:initGraphics()
	
	self.view:addEventListener( "touch", self )
end

---------------------------------------------------------------------------------
-- Init graphics
---------------------------------------------------------------------------------
function elGUIButton:initGraphics()

	self:initView()
end

---------------------------------------------------------------------------------
-- Init button's view
-- Buttons view is widget library button object
---------------------------------------------------------------------------------
function elGUIButton:initView()
	
	local parentView = self.elGUI.view

	local view = widget.newButton{

		width = 24,
		height = 24,
		defaultFile = "gfx/editGUI/subMenuDefault.png",
		overFile = "gfx/editGUI/subMenuOver.png",
		onEvent = deleteButtonTouched,
	}

	self.view = view
	view.obj = self

	parentView:insert(view)
	self:adjustPosition(true)
end

---------------------------------------------------------------------------------
-- Touch listener
---------------------------------------------------------------------------------
function elGUIButton:touch(event)
	
	local phase = event.phase

	if phase == "ended" then

		self.editGUI:showElGUIs(false)
		self:showElGUI()
	end 

	return true
end

---------------------------------------------------------------------------------
-- Shows or hides submenu depending on its visibility
---------------------------------------------------------------------------------
function elGUIButton:showElGUI( )
	
	local subMenuView = self.elGUI.subMenu.view
	local buttonsView = self.elGUI.buttonsView

	self.elGUI.view.isVisible = true

	if subMenuView.isVisible then

		subMenuView.isVisible = false
		buttonsView.isVisible = false

		self.editGUI:showElGUIs(true)

		self:adjustPosition(true)

	else

		subMenuView.isVisible = true
		buttonsView.isVisible = true
		self:adjustPosition(false)
	end
end

function  elGUIButton:adjustPosition(stickToEl)

	local view = self.view
	
	if stickToEl then

		local elView = self.el.view

		view.x, view.y = view:contentToLocal(elView.contentBounds.xMin + 0.5*elView.width, elView.contentBounds.yMin + 0.5*elView.height)

	else

		view.x, view.y = self.x, 0.5*self.view.height
	end
end

return elGUIButton