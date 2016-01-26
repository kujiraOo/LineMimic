------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local simpleTouchElement = class("simpleTouchElement")

------------------------------------------------------------------------------------
-- Pattern consists from touch elements that appear on the screen according
-- to params table
-- x, y - starting point of the pattern
-- params - this table contains coordinates of each element
-- The elemnts from the params table will appear on the screen one after another
-- in an order accroding to their indecies in the table.
-- [1]x, [2]y, [3]size
------------------------------------------------------------------------------------
function simpleTouchElement:init(params, view)
	
	self.elId = 1
	self.x, self.y, self.params, self.view = x, y, params, view
	self.touchElement = require("element."..params.touchElement)
	self.isComplete = false
	self.elsData = params
end

------------------------------------------------------------------------------------
-- This method return an instance of touchElement provided by subclass 
-- Each time this method is called elId var is increased, so next time a new
-- element from elsData table will be added to the screen
------------------------------------------------------------------------------------
function simpleTouchElement:nextEl(speed)

	local elsData = self.elsData
	local elId = self.elId
	local elData = elsData[elId]

	local parentView = self.view

	local x = elData[1]
	local y = elData[2]
	local size = elData[3]
	local time = size / speed * 60

	if elId == #elsData then

		self.isComplete = true
	end

	self.elId = self.elId + 1

	return self.touchElement:new(parentView, x, y, size, time)
end

return simpleTouchElement