------------------------------------------------------------------------------------
-- File: element.swipeElement.lua
-- Super class for all swipe elements
-- Consists of two parts: head and body
-- To check the element the head must be swiped in direction to body
-- The element has 4 directions: up, down, left, right
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local touchElement = require("element.touchElement")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local swipeElement = touchElement:extend("swipeElement")

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function swipeElement:init(x, y)

	self.x = x
	self.y = y
	self.checkType = "touchEnd"
end


------------------------------------------------------------------------------------
-- Check method for touch elements that are to touch only one time
------------------------------------------------------------------------------------
function swipeElement:check(cc)
	
	self.isChecked = true

	self:setColor(cc)
end


------------------------------------------------------------------------------------
-- On drawing animation comlete listener
------------------------------------------------------------------------------------
local function onDrawingAnimationComplete(view)

	local foo = view.foo
	local arg = view.arg

	if foo then
		foo(arg)
	end
end

------------------------------------------------------------------------------------
-- Drawing antimation scales the element from 10% scale to target scale within
-- set time
------------------------------------------------------------------------------------
function swipeElement:initDrawingAnimation(size, time)

	local view = self.view
	view.obj = self

	local xScale = size / 100
	local yScale = size / 100

	transition.scaleTo( view,  {xScale = xScale, yScale = yScale, time = time, onComplete = onDrawingAnimationComplete})
end

------------------------------------------------------------------------------------
-- Set function and arg that will be called when the drawing animtion will be
-- completed
------------------------------------------------------------------------------------
function swipeElement:setOnCompleteAction(foo, arg)

	self.view.foo = foo
	self.view.arg = arg
end

return swipeElement