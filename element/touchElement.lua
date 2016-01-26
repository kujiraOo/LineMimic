-- File touchElement.lua

------------------------------------------------------------------------------------
-- Super class for graphics obecjts that can be touched
-- Gets bigger after it appears
-- Player must touch it one or several times to check it
-- When initial animation is complete then elements manager
-- spawns new element
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local shape = require("shape")

local touchElement = class("touchElement")

function touchElement:init(x, y)

	self.checkType = "touchBegin"

	self.x = x
	self.y = y
	self.alpha = 1
end


function touchElement:setAlpha(alpha )
	
	local view = self.view

	self.alpha = alpha

	self.view.alpha = alpha
end

function touchElement:setColor(color)
	
	local view = self.view

	shape.setColor(view, color)
end


------------------------------------------------------------------------------------
-- Check method for touch elements that are to touch only one time
------------------------------------------------------------------------------------
function touchElement:check(cc)
	
	self.isChecked = true

	self:setColor(cc)
end

------------------------------------------------------------------------------------
-- Prepare view to appear on the screen
------------------------------------------------------------------------------------
function touchElement:setUpView(x, y, parentView)

	local view = self.view

	view.x = x
	view.y = y
	view.anchorX = 0.5
	view.anchorY = 0.5
	view.xScale = 0.1 
	view.yScale = 0.1 

	parentView:insert(view)
	self.view = view
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
------------------------------------------------------------------------------------
function touchElement:initDrawingAnimation(size, time)

	local view = self.view
	view.obj = self

	local xScale = size / 100
	local yScale = size / 100

	transition.scaleTo( view,  {xScale = xScale, yScale = yScale, time = time, onComplete = onDrawingAnimationComplete})
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function touchElement:setOnCompleteAction(foo, arg)

	self.view.foo = foo
	self.view.arg = arg
end

return touchElement