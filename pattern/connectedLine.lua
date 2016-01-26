------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local animatedLineSegment = require("element.animatedLineSegment")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local connectedLine = class("connectedLine")

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
-- params - this table contains length and direction of each line of the pattern
-- The segments from the params table will appear on the screen one after another
-- in an order accroding to their indecies in the table.
-- [1]Odd index is line's direction, [2]even line's length
------------------------------------------------------------------------------------
function connectedLine:init(params, view, superPattern)
	
	self.segmentId = 1
	self.x, self.y, self.params, self.view = params.x, params.y, params, view
	self.isComplete = false
	self.segmentsData = params

	self.superPattern = superPattern
end

------------------------------------------------------------------------------------
-- This method return an instance of animatedLineSegment
-- Each time this method is called segmentId var is increased, so next time a new
-- segment from segmentsData table will be added to the screen
------------------------------------------------------------------------------------
function connectedLine:nextEl(speed)

	local segmentsData = self.segmentsData
	local segmentId = self.segmentId

	local parentView = self.view
	local x, y = self:calcStartPoint()

	if segmentId == #segmentsData then
		self:complete()
	end

	local segmentData = segmentsData[segmentId]
	local dir = segmentData[1]
	local length = segmentData[2]

	self.segmentId = self.segmentId + 1
	self.lastX, self.lastY, self.lastDir, self.lastLength = x, y, dir, length

	return animatedLineSegment:new(parentView, x, y, dir, length, speed)
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function connectedLine:calcStartPoint( )

	if self.segmentId == 1 then

		return self.x, self.y
	else

		return self:calcNextStartPoint()
	end
end


------------------------------------------------------------------------------------
-- Set self complete
-- Set parent pattern complete
------------------------------------------------------------------------------------
function connectedLine:complete( )

	self.isComplete = true

	if self.superPattern then
		
		self.superPattern:onSubPatternComplete()
	end
end

------------------------------------------------------------------------------------
-- This method calculates the starting point of first or next sement from the
-- segmentsData table
-- It takes into account direction of the current segment and of the last segment
-- to assure proper connection of both segments
------------------------------------------------------------------------------------
function connectedLine:calcNextStartPoint( )

	local currentDir = self.segmentsData[self.segmentId][1]
	local lastX, lastY, lastDir, lastLength = self.lastX, self.lastY, self.lastDir, self.lastLength

	local x, y

	if lastDir == up then -- to avoid line start and end points intersection
		
		y = lastY - lastLength + halfWidth
	elseif lastDir == down then

		y = lastY + lastLength - halfWidth
	elseif lastDir == left then

		x = lastX - lastLength + halfWidth
	elseif lastDir == right then

		x = lastX + lastLength - halfWidth
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

			y = lastY + halfWidth
		end
	end

	return x, y
end

return connectedLine