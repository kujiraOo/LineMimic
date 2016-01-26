------------------------------------------------------------------------------------
-- File checkManager.lua
-- This class checks line if user input was correct 
-- It uses common table for both element and line objects
-- It also updates their color and alpha
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local color = require("color")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local checkManager = class("checkManager")

------------------------------------------------------------------------------------
-- Cache native functions
------------------------------------------------------------------------------------
local tableRemove = table.remove

------------------------------------------------------------------------------------
-- Local constatns
------------------------------------------------------------------------------------
local hitBoxRad = 50

------------------------------------------------------------------------------------
-- Local functions
------------------------------------------------------------------------------------
local function calcDistanceSqr(x1, y1, x2, y2 )
	
	return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
end

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function checkManager:init(level)
	
	self.elementsToCheck = {} 
	self.level = level
end

------------------------------------------------------------------------------------
-- Add element to elementsToCheck table
------------------------------------------------------------------------------------
function checkManager:addElement(el)
	
	local elementsToCheck = self.elementsToCheck
	local maxNumEls = self.level.maxNumEls

	elementsToCheck[#elementsToCheck + 1] = el

	if #elementsToCheck > maxNumEls then

		self.level:gameOver()
	end
end

------------------------------------------------------------------------------------
-- Checks if the direction of last line is the same as the direction of layer's 
-- input
-- Checks elements that with "touchEnd" check condition
------------------------------------------------------------------------------------
function checkManager:checkTouchEndEl(dir, x1, y1, x2, y2) 

	local elementsToCheck = self.elementsToCheck
	local el = elementsToCheck[1]
	
	if el and el.checkType == "touchEnd" then

		if el.name == "animatedLineSegment" then

			self:checkAnimatedLineSegment(dir, el)

		else 

			self:checkSwipeElement(dir, x1, y1, el)
		end


		if el.isChecked then

			tableRemove(elementsToCheck, 1)

			self.level.alphaManager:onElChecked()
		end
	end
end


function checkManager:checkAnimatedLineSegment(dir, el)
	
	if dir == el.dir then -- If input is correct then mark the line
			
		el:setColor(color.standard.checked)
		el.isChecked = true
	end
end

local function isHit(touchX, touchY, elX, elY)
	
	return calcDistanceSqr(touchX, touchY, elX, elY) <= hitBoxRad * hitBoxRad
end

function checkManager:checkSwipeElement(dir, touchX, touchY, el)
	
	if isHit(touchX, touchY, el.x, el.y) and el.dir == dir then

		el:check(color.standard.checked)
	end
end

------------------------------------------------------------------------------------
-- Gets x and y from touchController and checks if next element to check is
-- a touch element at this coordinate 
------------------------------------------------------------------------------------
function checkManager:checkTouchBeginEl(x, y)
	
	local elementsToCheck = self.elementsToCheck
	local el = elementsToCheck[1]

	if el and el.super and el.super.name == "touchElement" then

		if isHit(x, y, el.x, el.y) then

			el:check(color.standard.checked)

			if el.isChecked then
				tableRemove(elementsToCheck, 1)
				self.level.alphaManager:onElChecked()
			end
		end
	end
end

return checkManager