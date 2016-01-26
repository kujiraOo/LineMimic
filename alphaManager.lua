-- File: alphaManager.lua

-- Manages alpha of line segments and touchElements

-- Imports
local color = require("color")

local alphaManager = class("alphaManager")

local maxActiveLines = 30
local maxBrightLines = 10

function alphaManager:init(level)

	self.isActive = true
	
	self.elementsTable = {}
	self.level = level
end

function alphaManager:onElChecked()

	if self.isActive then

		local elsToCheck = self.level.checkManager.elementsToCheck
		local nextUncheckedEl = elsToCheck[0.5 * maxBrightLines]

		if nextUncheckedEl then
			nextUncheckedEl:setAlpha(1)
		end
		
		local prevCheckedEl = self.elementsTable[#self.elementsTable - #elsToCheck - 0.5 * maxBrightLines] 

		if prevCheckedEl and prevCheckedEl.alpha > color.alpha2 then
			prevCheckedEl:setAlpha(color.alpha2)
		end
	end
end

function alphaManager:addElement(el)

	local elementsTable = self.elementsTable

	elementsTable[#elementsTable + 1] = el

	local numElsToCheck = #self.level.checkManager.elementsToCheck

	if numElsToCheck >= 0.5 * maxBrightLines + 1 then 
		el:setAlpha(color.alpha2)
	else
		el:setAlpha(1)
	end

	local nEls = #self.elementsTable
	local oldEl = elementsTable[nEls - maxActiveLines]

	if oldEl then
		--oldEl:setAlpha(color.inactiveAlpha)
	end
end

function alphaManager:onLevelComplete( )

	self.isActive = false

	local elsTable = self.elementsTable

	for i = 1, #elsTable do

		local el = elsTable[i]

		el:setAlpha(1)
	end

end


return alphaManager