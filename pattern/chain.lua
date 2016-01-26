------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local chainLink = require("pattern.chainLink")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local chain = class("chain")

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
-- params - this table contains len and direction of each line and each
-- right / left direction -- chain link, len
------------------------------------------------------------------------------------
function chain:init(params, view)
	
	self.elId = 1
	self.x, self.y, self.params, self.view = params.x, params.y, params, view
	self.isComplete = false
	self.elsData = params

	self:initNextSubPattern()
end

------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
function chain:initNextSubPattern( )
	
	local elId, elsData = self.elId, self.elsData

	local x, y

	if elId == 1 then
		x, y = self.x, self.y
	else
		x, y = self:calcStartPoint()
	end

	local elData = elsData[elId]
	local dir = elData[1]
	local len = elData[2]

	local params = {dir, len}

	local view = self.view

	self.subPattern = chainLink:new(x, y, params, view, self)

	self.lastX, self.lastY, self.lastDir, self.lastLen = x, y, dir, len
	self.elId = self.elId + 1
end

------------------------------------------------------------------------------------
-- This method return an instance of animatedLineSegment generated from 
-- chainLink subpattern
------------------------------------------------------------------------------------
function chain:nextEl(speed)

	return self.subPattern:nextEl(speed)
end

function chain:onSubPatternComplete(  )

	local elId = self.elId
	local elsData = self.elsData

	if self.isLastSubPattern then
		self.isComplete = true
	else
		self:initNextSubPattern()
	end

	if elId == #elsData then
		self.isLastSubPattern = true
	end
end

------------------------------------------------------------------------------------
-- This method calculates the starting point of first or next sement from the
-- segmentsData table
-- It takes into account direction of the current segment and of the last segment
-- to assure proper connection of both segments
------------------------------------------------------------------------------------
function chain:calcStartPoint( )

	local currentDir = self.elsData[self.elId][1]
	local lastX, lastY, lastDir, lastLen = self.lastX, self.lastY, self.lastDir, self.lastLen

	local x, y

	if lastDir == up then -- to avoid line start and end points intersection
		
		y = lastY - lastLen + halfWidth
	elseif lastDir == down then

		y = lastY + lastLen - halfWidth
	elseif lastDir == left then

		x = lastX - lastLen + halfWidth
	elseif lastDir == right then

		x = lastX + lastLen
	end

	if lastDir == up or lastDir == down then

		if currentDir == left then

			x = lastX - halfWidth
		else

			x = lastX + halfWidth
		end
	else

		if currentDir == up then

			y = lastY - halfWidth
		else

			y = lastY
		end
	end

	return x, y
end

return chain