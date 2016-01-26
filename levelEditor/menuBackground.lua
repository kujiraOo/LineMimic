---------------------------------------------------------------------------------
-- Menu background module, returns a rect display object of specified width
---------------------------------------------------------------------------------

local menuBackground = {}

---------------------------------------------------------------------------------
-- Constructor
---------------------------------------------------------------------------------
function menuBackground.new(parentView, x, y, width, height)

	local bg

	if parentView then
		bg = display.newRect( parentView, x, y, width, height )
	else
		bg = display.newRect( x, y, width, height )
	end

	bg.anchorX, bg.anchorY = 0, 0
	bg:setFillColor( 0, 0.5 )

	return bg
end

return menuBackground