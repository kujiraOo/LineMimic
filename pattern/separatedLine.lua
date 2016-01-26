------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local animatedLineSegment = require("element.animatedLineSegment")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local separatedLine = class("separatedLine")

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
-- [1]x, [2]y, [3]dir, [4]len
------------------------------------------------------------------------------------
function separatedLine:init(params, view, superPattern)
	
	self.elId = 1
	self.x, self.y, self.params, self.view = x, y, params, view
	self.isComplete = false
	self.elsData = params

	self.superPattern = superPattern
end

------------------------------------------------------------------------------------
-- This method return an instance of animatedLineSegment
-- Each time this method is called elId var is increased, so next time a new
-- segment from elsData table will be added to the screen
------------------------------------------------------------------------------------
function separatedLine:nextEl(speed)

	local elsData = self.elsData
	local elId = self.elId
	local elData = elsData[elId]

	local parentView = self.view

	local x, y = elData[1], elData[2]

	if elId == #elsData then
		self:complete()
	end

	local dir = elData[3]
	local length = elData[4]

	self.elId = self.elId + 1
	self.lastX, self.lastY, self.lastDir, self.lastLength = x, y, dir, length

	return animatedLineSegment:new(parentView, x, y, dir, length, speed)
end


------------------------------------------------------------------------------------
-- Set self complete
-- Set parent pattern complete
------------------------------------------------------------------------------------
function separatedLine:complete( )

	self.isComplete = true

	if self.superPattern then
		self.superPattern:onSubPatternComplete()
	end
end

------------------------------------------------------------------------------------
-- This method calculates the starting point of first or next sement from the
-- elsData table
-- It takes into account direction of the current segment and of the last segment
-- to assure proper connection of both segments
------------------------------------------------------------------------------------


return separatedLine