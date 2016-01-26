---------------------------------------------------------------------------------
-- This button receives displayObject as an argument and shows it or hides it
-- on release
---------------------------------------------------------------------------------

local showButton = {}

---------------------------------------------------------------------------------
-- Improts
---------------------------------------------------------------------------------
local widget = require("widget")

---------------------------------------------------------------------------------
-- Call additional listeners of the button
---------------------------------------------------------------------------------
local function callListeners(listenerTable)
	
	for i = 1, #listenerTable do

		local listenerFunction = listenerTable[i][1]
		local arg1 = listenerTable[i][2]
		local arg2 = listenerTable[i][3]

		listenerFunction(arg1, arg2)
	end
end

---------------------------------------------------------------------------------
-- This function hides and shows native display objects that belongs to viewToSHow
---------------------------------------------------------------------------------
local function showHideNativeDisplayObjects(nativeDisplayObjects, isVisible)

	for i = 1, #nativeDisplayObjects do

		nativeDisplayObjects[i].isVisible = isVisible
	end
end

---------------------------------------------------------------------------------
-- Button listener
---------------------------------------------------------------------------------
local function showHideView(event)
	
	local viewToShow = event.target.params.viewToShow
	local listenersTable = event.target.listenersTable

	viewToShow.isVisible = not viewToShow.isVisible
	viewToShow:toFront()

	if listenersTable then
		callListeners(listenersTable)
	end

	if viewToShow.nativeDisplayObjects then

		showHideNativeDisplayObjects(viewToShow.nativeDisplayObjects, viewToShow.isVisible)
	end
end

---------------------------------------------------------------------------------
-- Button constructor
---------------------------------------------------------------------------------
function showButton.new(parentView, viewToShow, x, y, defaultFile, overFile, listenersTable)

	local button = widget.newButton{

		x = x,
		y = y,
		defaultFile = defaultFile,
		overFile = overFile,
		onRelease = showHideView,
	}

	button.params = {viewToShow = viewToShow}
	button.listenersTable = listenersTable

	parentView:insert(button)
	
	return button
end

---------------------------------------------------------------------------------
-- Add new listener to button's listeners table
---------------------------------------------------------------------------------
function showButton.addListener(button, listenerTable)
	
	table.insert(button.listenersTable, listenerTable)
end

return showButton