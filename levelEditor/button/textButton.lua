---------------------------------------------------------------------------------
-- Text button module, to create buttons with text lables easily 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local elColor = require("levelEditor.color").elColor
local widget = require("widget")

local textButton = {}

---------------------------------------------------------------------------------
-- Call all funtions from listenersTable
---------------------------------------------------------------------------------
local function callListeners(event)
	
	local listenersTable = event.target.listenersTable

	if listenersTable then

		for i = 1, #listenersTable do

			local listenerFunction = listenersTable[i][1]
			local arg1 = listenersTable[i][2]
			local arg2 = listenersTable[i][3]

			listenerFunction(arg1, arg2)
		end
	end
end

---------------------------------------------------------------------------------
-- Constructor
---------------------------------------------------------------------------------
function textButton.new(parentView, x, y, width, height, label, listenersTable)
	
	local r, g, b = elColor.r, elColor.g, elColor.b

	local button = widget.newButton{

		label = label or "button",

	    onRelease = callListeners,
	    shape = "roundedRect",
	    x = x,
	    y = y,
	    width = width,
	    height = height,
	    cornerRadius = 2,
	    strokeColor = { default={ r, g, b, 1 }, over ={ r, g, b, 1 }},
	    fillColor = { default={ r, g, b, 0.1 }, over ={ r, g, b, 0.1 }},
	    labelColor = { default={ r, g, b, 1 }, over ={ r, g, b, 1 }},
	    strokeWidth = 2
	}

	button.listenersTable = listenersTable

	parentView:insert(button)
end

return textButton