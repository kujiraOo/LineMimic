------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local connectedLine = require("pattern.connectedLine")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local chainLink = class("chainLink")

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
-- params - this table contains length and direction of each line and each
-- right / left direction -- chainLink link, length
------------------------------------------------------------------------------------
function chainLink:init(x, y, params, view, superPattern)
	
	self.elId = 1
	self.x, self.y, self.params, self.view, self.superPattern = x, y, params, view, superPattern
	self.isComplete = false
	self.elsData = params

	self.dir = params[1]
	self.len = params[2]

	self:initSubPattern()
end

------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
function chainLink:initSubPattern( )
	
	local elId, elsData = self.elId, self.elsData

	local params = self:generateSubPatternParams()

	local view = self.view

	self.subPattern = connectedLine:new(params, view, self)
end

function chainLink:generateSubPatternParams()

	local dir, len = self.dir, self.len
	local halfLen = 0.5 * len
	
	local params = {
		x = self.x, y = self.y,
		{up, halfLen},
		{right, halfLen},
		{down, len},
		{left, halfLen},
		{up, halfLen},
		{right, len},
	}
	
	return params
end

------------------------------------------------------------------------------------
-- This method return an instance of animatedLineSegment generated from 
-- chainLinkLink subpattern
------------------------------------------------------------------------------------
function chainLink:nextEl(speed)

	local subPattern = self.subPattern

	return subPattern:nextEl(speed)
end

function chainLink:onSubPatternComplete( )
	
	self.isComplete = true

	local superPattern = self.superPattern

	if superPattern then
		superPattern:onSubPatternComplete()
	end
end



return chainLink