-- File: touchElementManager.lua

-- Controlls spawn, speed, acceleration and patterns of touchElements

-- Imports
local color = require("color")

local touchElementManager = class("touchElementManager")

local tableRemove = table.remove

-- Methods
function touchElementManager:init(level, checkManager)

	self.elementsTable = {} -- Here new elements are saved. 
	self.nextElementsTable = {} -- Table of elements to be drawn

	self.config = level.config

	self.speed = 2

	self.level = level

	self.isActive = true
end

function touchElementManager:nextElement() -- adds next element 

	local accelerationManager = self.accelerationManager

	self:addNewElement()

	if accelerationManager then
		accelerationManager:update()
	end
end

function touchElementManager:addNewElement( )

	local nextElementsTable = self.nextElementsTable
	local x, y
	local view = self.level.elementsView
	local pattern = self.pattern
	local size = 30
	local speed = self.speed
	local currentElementClass = self.currentElementClass

	if #nextElementsTable > 0 or pattern then

		if #nextElementsTable > 0 then
			x, y = nextElementsTable[1][1], nextElementsTable[1][2]
			tableRemove(nextElementsTable, 1)
		else
			x, y = self.pattern:calcNextElement()
		end

		local time = size / speed * 60

		local elem = currentElementClass:new(x, y, size, time, view)

		elem:setColor(color.standard.unchecked)
		elem:setOnCompleteAction(self.onElementComplete, self)

		self.level.checkManager:addElement(elem)
		self.level.alphaManager:addElement(elem)
	end
end

function touchElementManager:onElementComplete( )
	self.level:update()
	self:nextElement()
end

return touchElementManager