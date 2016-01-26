---------------------------------------------------------------------------------
-- Line segment element 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local element = require("levelEditor.element.element")
local color = require("color")
local lineMath = require("lineMath")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local lineSegment = element:extend("levelEditor.element.lineSegment")

---------------------------------------------------------------------------------
-- Cache functions
---------------------------------------------------------------------------------
local calcDir = lineMath.calcDir
local calcLen = lineMath.calcLen
local calcFinalPoint = lineMath.calcFinalPoint

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function lineSegment:init(view, x, y, color)
	
	self.super.init(self, view, x, y, color)
end

---------------------------------------------------------------------------------
-- Draw line segment
---------------------------------------------------------------------------------
function lineSegment:draw(x2, y2)

	if self.line then
		self.line:removeSelf()
	end

	local view = self.view
	local x1 = self.x
	local y1 = self.y
	local x2, y2 = calcFinalPoint(x1, y1, x2, y2)

	local line = display.newLine( view, x1, y1, x2, y2)
	line.strokeWidth = 4
	line:setStrokeColor(self.color.r, self.color.g, self.color.b)
	line.alpha = 0.5
	self.line = line
end

---------------------------------------------------------------------------------
-- Fix the line, calc its dir and length
---------------------------------------------------------------------------------
function lineSegment:fix(x2, y2)

	local x1 = self.x
	local y1 = self.y
	
	self:draw(x2, y2)

	self.dir = calcDir(x1, y1, x2, y2)
	self.len = calcLen(x1, y1, x2, y2)
	self.x2, self.y2 = calcFinalPoint(x1, y1, x2, y2)
end

return lineSegment