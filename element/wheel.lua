-- File wheel.lua

------------------------------------------------------------------------------------
-- This elements consists of 5 circle segments.
-- Player have to touch the element 5 times to check it.
-- Each time player touches the element one of it segments changes its color
-- to checked.
-- The element has rotation animation as it represents a wheel.
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local touchElement = require("element.touchElement")
local shape = require("shape")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local wheel = touchElement:extend("wheel")

------------------------------------------------------------------------------------
-- Cache native
------------------------------------------------------------------------------------
local pi = math.pi
local sin = math.sin
local cos = math.cos

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function wheel:init(parentView, x, y, size, time)

	self.super.init(self)

	self.x = x
	self.y = y

	self:initGraphics(x, y, parentView)
	self:initDrawingAnimation(size, time)
	self:initRotationAnimation()

	self.alpha = 1
	self.hits = 0
	self.maxHits = 5
end

function wheel:initGraphics(x, y, parentView)

	self.view = shape.wheel()

	self:setUpView (x, y, parentView)
end


------------------------------------------------------------------------------------
-- Infinte rotation about anchor point
------------------------------------------------------------------------------------
function wheel:initRotationAnimation(size, time)

	local view = self.view

	transition.to(view, {time = 7000, rotation = -360, iterations = -1})
end

------------------------------------------------------------------------------------
-- Check element. Receives check color as argument
-- If all segments are checked then whole elemnt is checked
------------------------------------------------------------------------------------
function wheel:check(cc)
	
	self.hits = self.hits + 1

	local hits = self.hits
	local maxHits = self.maxHits

	self.view[hits]:setFillColor(cc.r, cc.g, cc.b)

	if hits == maxHits then

		self.isChecked = true
	end
end

return wheel