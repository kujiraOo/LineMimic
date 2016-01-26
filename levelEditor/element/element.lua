---------------------------------------------------------------------------------
-- Super class for all elements
-- All elements have
-- options button
-- drag button
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local element = class("levelEditor.element.element")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function element:init(parentView, x, y, color)

	self.x = x
	self.y = y
	self.color = color

	local view = display.newGroup( )
	parentView:insert(view)
	self.view = view
end



return element