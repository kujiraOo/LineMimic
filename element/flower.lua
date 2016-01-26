-- File flower.lua

-- Class draws animated flower
-- Gets bigger after it appears
-- Player must touch it to check it
-- When initial animation is complete then elements manager
-- spawns new element

-- Imports
local touchElement = require("element.touchElement")
local shape = require("shape")

-- Class declaration
local flower = touchElement:extend("flower")

-- Class constructor
function flower:init(parentView, x, y, size, time)

	self.super.init(self)

	self.x = x
	self.y = y

	self:initGraphics(x, y, parentView)
	self:initDrawingAnimation(size, time)
	self:initRotationAnimation()

	self.alpha = 1
end

function flower:initGraphics(x, y, parentView)

	self.view = shape.flower()
	
	self:setUpView(x, y, parentView)
end


function flower:initRotationAnimation()

	local view = self.view

	transition.to(view, {time = 5000, rotation = -360, iterations = -1})
end


return flower