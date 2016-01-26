---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local color = require("color")

local colorButtonGroup = {}

function colorButtonGroup.new(x, y)

	local N_COLORS = #color.checked -- number of checked colors in color module
	local WIDTH = 200
	local X_STEP = WIDTH / (N_COLORS + 1)

	-- create separate group for buttons to manage their alpha more easily 
	local group = display.newGroup( )
	group.x, group.y = x, y
	menu.view:insert(group)

	-- create buttons for every available color 
	for i = 1, N_COLORS do

		local button = newColorButton(menu, X_STEP * i, 0, i)
		group:insert(button)

		-- set alpha of all buttons except of the first one to alpha of inactive button
		if i ~= 1 then

			button.alpha = BUTTON_INACTIVE_ALPHA
		end
	end
end

---------------------------------------------------------------------------------
-- Rect button of specified color, sets color property of the menu
---------------------------------------------------------------------------------
function newColorButton(menu, x, y, c)

	-- get checked color from color module, create new table in format for newButton constructor
	local ct = {color.checked[c].r, color.checked[c].g, color.checked[c].b}

	local button = widget.newButton( {

	    onRelease = colorButtonReleased,
	    shape="roundedRect",
	    width = WIDTH / 6,
	    height = 20,
	    cornerRadius = 2,
	    fillColor = { default=ct, over=ct},
	} )

	button.x = x 
	button.y = y

	button.params = {menu = menu, c = c}

	return button
end

return colorButtonGroup