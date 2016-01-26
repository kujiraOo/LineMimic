---------------------------------------------------------------------------------
-- Shows a small window on the bottom of the screen.
-- The window disappears after few moments. The time can be set
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local menuBackground = require("levelEditor.menuBackground")
local elColor = require("levelEditor.color").elColor

local popUp = {}


---------------------------------------------------------------------------------
-- Local functions
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Init pop up's background and text, it is hidden by default
---------------------------------------------------------------------------------
local function initPopUpWindow()

	local W = 100
	local H = 30
	local Y = 300
	local X = 0.5*(display.contentWidth - W)

	local window = display.newGroup( )
	window.x = X
	window.y = Y

	local bg = menuBackground.new(window, 0, 0, W, H)

	local text = display.newText( window, "", 0.5 * W, 0.5 * H, "Helvetica", 14 )
	text:setTextColor( elColor.r, elColor.g, elColor.b )

	window.isVisible = false

	window.textObj = text

	return window
end

---------------------------------------------------------------------------------
-- Local vars
---------------------------------------------------------------------------------
local popUpWindow = initPopUpWindow()

---------------------------------------------------------------------------------
-- Shows small window the time and text should be specified
---------------------------------------------------------------------------------
function popUp.show(text, delay)

	local DELAY = 1000

	-- Update text
	print("popUp.show() text:", text)
	popUpWindow.textObj.text = text

	-- Show the window
	popUpWindow.isVisible = true
	popUpWindow:toFront( )

	-- Set up timer for hide window
	local delay = delay or DELAY
	timer.performWithDelay( delay, function() popUpWindow.isVisible = false end)
end



return popUp