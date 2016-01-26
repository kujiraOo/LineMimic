------------------------------------------------------------------------------------
-- File: element.icecream.lua
-- Super class for all swipe elements
-- Consists of two parts: head and body
-- To check the element the head must be swiped in direction to body
-- The element has 4 directions: up, down, left, right
-- Inherits from swipe element
-- Looks like icecream with floating head 
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local swipeElement = require("element.swipeElement")
local shape = require("shape")

------------------------------------------------------------------------------------
-- icecream extends swipeElement
------------------------------------------------------------------------------------
local icecream = swipeElement:extend("icecream")

------------------------------------------------------------------------------------
-- Local constants
------------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4

local headRadius = 20
local bodyW = 40
local bodyH = 60
local bodyOffset = 30


------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function icecream:init(parentView, x, y, size, time)

	self.super.init(self, x, y)

	self.dir = down

	self:initGraphics(x, y, parentView)
	self:initDrawingAnimation(size, time)
	self:initFloatingAnimation()

	self.alpha = 1
end

------------------------------------------------------------------------------------
-- Init graphics, x and y of the element are the approximate coordinates of 
-- head's default position
-- Head is circle
-- Body is triangle
------------------------------------------------------------------------------------
function icecream:initGraphics(x, y, parentView)

	self.view = shape.icecream()

	self.head = self.view.head

	self:setUpView(x, y, parentView)
end


------------------------------------------------------------------------------------
-- Switch heads transition from down to up and vise versa to create infinite 
-- animation
------------------------------------------------------------------------------------
local function onFloatAnimStepComplete(head)

	local lastY = head.lastY
	local icecreamObj = head.icecreamObj

	head.lastY = head.y

	icecreamObj.floatingAnim = transition.to(head, {time = 500, y = lastY, onComplete = onFloatAnimStepComplete})
end

------------------------------------------------------------------------------------
-- Init head's floating animation
------------------------------------------------------------------------------------
function icecream:initFloatingAnimation( )
	
	local head = self.head

	head.icecreamObj = self
	head.lastY = head.y

	self.floatingAnim = transition.to(head, {time = 500, y = 0.5 * bodyOffset, onComplete = onFloatAnimStepComplete})
end

function icecream:check(cc)

	transition.cancel(self.floatingAnim)

	self:setColor(cc)

	transition.to(self.head, {time = 200, y = bodyOffset})

	self.isChecked = true
end

return icecream