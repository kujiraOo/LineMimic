---------------------------------------------------------------------------------
-- Line segment element 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local element = require("levelEditor.element.element")
local color = require("color")
local shape = require("shape")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local touchElement = element:extend("levelEditor.element.touchElement")

---------------------------------------------------------------------------------
-- Cache
---------------------------------------------------------------------------------
local pi = math.pi
local sin = math.sin
local cos = math.cos

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function touchElement:init(view, x, y, size, type, color)
	
	self.super.init(self, view, x, y, color)

	self.size = size
	self.type = type

	self:initGraphics()
end

---------------------------------------------------------------------------------
-- This is switch function to pick the right graphics for the element
---------------------------------------------------------------------------------
function touchElement:initGraphics()
	
	local type = self.type

	self.GFXGroup = shape[type]()
	self.view:insert(self.GFXGroup)

	self:adjustSize()
	shape.setColor(self.GFXGroup, self.color)
end

---------------------------------------------------------------------------------
-- Set scale of the GFXGroup according to the set size
---------------------------------------------------------------------------------
function touchElement:adjustSize( )
	
	local GFXGroup = self.GFXGroup
	local size = self.size
	local scale = size * 0.01

	GFXGroup.xScale = scale
	GFXGroup.yScale = scale
end

---------------------------------------------------------------------------------
-- Resize the touch element
---------------------------------------------------------------------------------
function touchElement:resize(size)
	
	self.size = size

	self:adjustSize()
end


return touchElement