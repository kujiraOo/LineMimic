------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local icecream = require("element.icecream")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local simpleIcecream = class("simpleIcecream")

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
-- Pattern consists if icecream elements
------------------------------------------------------------------------------------
function simpleIcecream:init(x, y, params, view)
	
	self.elId = 1
	self.x, self.y, self.params, self.view = x, y, params, view
	self.isComplete = false
	self.elsData = params
end

------------------------------------------------------------------------------------
-- This method return an instance of animatedLineSegment
-- Each time this method is called segmentId var is increased, so next time a new
-- segment from segmentsData table will be added to the screen
------------------------------------------------------------------------------------
function simpleIcecream:nextEl(speed)

	local elsData = self.elsData
	local elId = self.elId

	local parentView = self.view

	local x = elsData[elId]
	local y = elsData[elId + 1]
	local size = elsData[elId + 2]
	local time = size / speed * 60

	if elId == #elsData - 2 then
		self.isComplete = true
	end

	self.elId = self.elId + 3

	return icecream:new(parentView, x, y, size, time)
end


return simpleIcecream