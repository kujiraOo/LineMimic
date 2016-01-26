---------------------------------------------------------------------------------
-- Module for yes/no window
-- Creates a window with graphical yes/no buttons
-- Needs to listener tables, one for each button
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local menuBackground = require("levelEditor.menuBackground")
local elColor = require("levelEditor.color").elColor
local textButton = require("levelEditor.button.textButton")

local yesNoWindow = {}

---------------------------------------------------------------------------------
-- Local functions declaration
---------------------------------------------------------------------------------
local hideWindow, updateButtonsListeners, handlePosition



function yesNoWindow.new(params)

	local DEFAULT_LABEL = "yesNoWindow"
	local W = 150
	local H = 100
	local X = 0.5 * (display.contentWidth - W)
	local Y = 0.5 * (display.contentHeight - H)
	local BUTTON_W = 50
	local BUTTON_H = 30

	local parentView = params.parentView
	local w = params.w or W
	local h = params.h or H
	local x, y

	-- Handle situation where x is not specified
	if params.x and params.y then
		x, y = params.x, params.y
	else
		if parentView then
			x, y = parentView:localToContent( X, Y )
		else
			x, y = X, Y
		end
	end

	local label = params.label or DEFAULT_LABEL

	-- Create window's group and insert it in parentView
	local yesNoW = display.newGroup( )
	if parentView then
		parentView:insert(yesNoW)
	end

	-- Set position
	yesNoW.x = x
	yesNoW.y = y
	
	-- Initialize window's background
	menuBackground.new(yesNoW, 0, 0, w, h)

	-- Initilaize window's label
	local text = display.newText( yesNoW, label, 0.5 * w, 0.33 * h, "Helvetica", "18" )
	text:setTextColor( elColor.r, elColor.g, elColor.b )

	local yListenerT = params.yListenerT or {}
	local nListenerT = params.nListenerT or {}

	-- If window must be hidden after yes or no button are pressed
	-- then the listener tables of the buttons must be updated
	if params.hide then

		updateButtonsListeners(yesNoW, yListenerT, nListenerT)
	end

	-- Init yes and no buttons
	textButton.new(yesNoW, 0.33 * w, 0.66 * h, BUTTON_W, BUTTON_H, "yes", yListenerT)
	textButton.new(yesNoW, 0.66 * w, 0.66 * h, BUTTON_W, BUTTON_H, "no", nListenerT)

	return yesNoW
end

---------------------------------------------------------------------------------
-- Hide yes no window
---------------------------------------------------------------------------------
function hideWindow(yesNoW)
	
	yesNoW.isVisible = false
end

---------------------------------------------------------------------------------
-- Update listeners of the yes and no buttons, so the window will be hidden
-- after one of those buttons is released
---------------------------------------------------------------------------------
function updateButtonsListeners(yesNoW, yListenerT, nListenerT)

	-- Hide listener
	local hideListener = {
		hideWindow,
		yesNoW,
	}
	
	table.insert(yListenerT, hideListener)
	table.insert(nListenerT, hideListener)
end


return yesNoWindow