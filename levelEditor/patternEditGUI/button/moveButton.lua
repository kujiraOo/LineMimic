---------------------------------------------------------------------------------
-- Button allows to drag view of an element and its GUI's view
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")
local patternDimensions = require("levelEditor.patternDimensions")

local padding = patternDimensions.padding
local contentWidth = patternDimensions.contentWidth
local contentHeight = patternDimensions.contentHeight

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local moveButton = class("levelEditor.moveButton")

---------------------------------------------------------------------------------
-- Class constructor
-- els -- elements to move, they should have view
-- Listener table include function and params for it, it is called when
-- object is moved and released
---------------------------------------------------------------------------------
function moveButton:init(parentView, elView, elGUIView, anchorX, anchorY, listenerTable)

	self.parentView = parentView
	self.elView = elView
	self.elGUIView = elGUIView
	self.anchorX = anchorX
	self.anchorY = anchorY
	self.listenerTable = listenerTable
	
	self:initView()
	
	self.view:addEventListener( "touch", self )
end

---------------------------------------------------------------------------------
-- Init button's view
-- Buttons view is widget library button object
---------------------------------------------------------------------------------
function moveButton:initView()
	
	local parentView = self.parentView

	local view = widget.newButton{

		width = 24,
		height = 24,
		defaultFile = "gfx/editGUI/moveDefault.png",
		overFile = "gfx/editGUI/moveOver.png",
		onEvent = deleteButtonTouched,
	}

	self.view = view
	view.obj = self

	parentView:insert(view)
end


---------------------------------------------------------------------------------
-- Touch listener
---------------------------------------------------------------------------------
function moveButton:touch(event)
	
	local phase = event.phase

	if phase == "began" then

		self:touchBegan(event)

	elseif phase == "moved" then

		self:touchMoved(event)

	elseif phase == "ended" then

		self:touchEnded(event)
	end 

	return true
end

---------------------------------------------------------------------------------
-- Set focus to stage and and mark element's position
---------------------------------------------------------------------------------
function moveButton:touchBegan(event)

	local elView = self.elView
	local elGUIView = self.elGUIView
	
	display.currentStage:setFocus(self.view, event.id)

	self.markElViewX = elView.x
	self.markElViewY = elView.y

	self.markElViewGUIX = elGUIView.x
	self.markElViewGUIY = elGUIView.y
end

---------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------
function moveButton:touchMoved(event)

	local elView = self.elView
	local elGUIView = self.elGUIView
	
	local deltaX = event.x - event.xStart
	local deltaY = event.y - event.yStart

	elView.x = self.markElViewX + deltaX
	elView.y = self.markElViewY + deltaY

	elGUIView.x = self.markElViewGUIX + deltaX
	elGUIView.y = self.markElViewGUIY + deltaY
end

function moveButton:touchEnded(event)
	
	local elView = self.elView
	local elGUIView = self.elGUIView

	display.currentStage:setFocus(nil)

	local deltaL = elView.contentBounds.xMin - padding
	local deltaR = contentWidth - padding - elView.contentBounds.xMax
	local deltaU = elView.contentBounds.yMin - padding
	local deltaD = contentHeight - padding - elView.contentBounds.yMax

	if deltaL < 0 then

		elView.x = elView.x - deltaL
		elGUIView.x = elGUIView.x - deltaL

	elseif deltaR < 0 then

		elView.x = elView.x + deltaR
		elGUIView.x = elGUIView.x + deltaR
	end

	if deltaU < 0 then

		elView.y = elView.y - deltaU
		elGUIView.y = elGUIView.y - deltaU

	elseif deltaD < 0 then

		elView.y = elView.y + deltaD
		elGUIView.y = elGUIView.y + deltaD
	end

	self:callListener()
end

---------------------------------------------------------------------------------
-- Call function from listener table and pass parameters to it
---------------------------------------------------------------------------------
function moveButton:callListener()

	local listenerTable = self.listenerTable

	if listenerTable then

		for i = 1, #listenerTable do

			local listenerFunction = listenerTable[i][1]
			local arg1 = listenerTable[i][2]
			local arg2 = listenerTable[i][3]

			listenerFunction(arg1, arg2)
		end
	end
end

---------------------------------------------------------------------------------
-- Update button's parent view's position in accordance to position of all sub elements
-- of element's view
-- Use anchor ratio
---------------------------------------------------------------------------------
function moveButton:updateViewPosition()
	
	local elView = self.elView
	local view = self.view
	local anchorX = self.anchorX
	local anchorY = self.anchorY
	local parentView = self.parentView

	local xMin = elView.contentBounds.xMin
	local xMax = elView.contentBounds.xMax
	local yMin = elView.contentBounds.yMin
	local yMax = elView.contentBounds.yMax

	local x = xMin + anchorX * (xMax - xMin) - parentView.x
	local y = yMin + anchorY * (yMax - yMin) - parentView.y

	view.x = x
	view.y = y
end

return moveButton