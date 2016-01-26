------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local connectedLine = require("pattern.connectedLine")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local connectedLineRect = class("connectedLineRect")

------------------------------------------------------------------------------------
-- Local constants
------------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4

local width = 4
local halfWidth = 2

------------------------------------------------------------------------------------
-- Pattern consists from line segments that are connected end to end
-- x, y - starting point of the pattern
-- params table contains [1]width and [2]height
------------------------------------------------------------------------------------
function connectedLineRect:init(params, view, superPattern)
	
	self.elId = 1
	self.x, self.y, self.params, self.view, self.superPattern = params.x, params.y, params, view, superPattern
	self.isComplete = false
	self.elsData = params

	self.width = params.w
	self.height = params.h

	self:initSubPattern()
end

------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
function connectedLineRect:initSubPattern( )
	
	local elId, elsData = self.elId, self.elsData

	local params = self:generateSubPatternParams()

	local view = self.view

	self.subPattern = connectedLine:new(params, view, self)
end

function connectedLineRect:generateSubPatternParams( )

	local width, height = self.width, self.height
	
	local params = {
		x = self.x, y = self.y,
		{right, width},
		{down, height},
		{left, width},
		{up, height}
	}
	
	return params
end

------------------------------------------------------------------------------------
-- This method return an instance of animatedLineSegment generated from 
-- connectedLineRectLink subpattern
------------------------------------------------------------------------------------
function connectedLineRect:nextEl(speed)

	local subPattern = self.subPattern

	return subPattern:nextEl(speed)
end

function connectedLineRect:onSubPatternComplete( )
	
	self.isComplete = true

	local superPattern = self.superPattern

	if superPattern then
		superPattern:onSubPatternComplete()
	end
end

return connectedLineRect