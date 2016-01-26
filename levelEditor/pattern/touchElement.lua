---------------------------------------------------------------------------------
-- Universal pattern class for all touch elements
-- 
-- In this file element class touch element is named touchElementEl, to avoid
-- confusion with pattern class
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local pattern = require("levelEditor.pattern.pattern")
local touchElementEl = require("levelEditor.element.touchElement")
local touchElEditGUI = require("levelEditor.patternEditGUI.touchElEditGUI")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local touchElement = pattern:extend("levelEditor.touchElement")

---------------------------------------------------------------------------------
-- Function cache
---------------------------------------------------------------------------------
local abs = math.abs

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local minSize = 10

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function touchElement:init(levelEditor, elementType, color)
	
	self.super.init(self, levelEditor, color)
	self.name = "touchElement"
	self.type = "touchElement"
	self.elType = elementType

	self.editGUI = touchElEditGUI(self)
end

---------------------------------------------------------------------------------
-- Register touch events
---------------------------------------------------------------------------------
function touchElement:touch(event)

	local phase = event.phase

	local x, y = self.view:contentToLocal( event.x, event.y )

	if phase == "began" then

		self:touchBegan()

	elseif phase == "ended" then

		self:createEl(x, y)
	end
end

---------------------------------------------------------------------------------
-- Hide menus
---------------------------------------------------------------------------------
function touchElement:touchBegan( )
	
	local levelEditor = self.levelEditor

	levelEditor:hideMenus()
end

---------------------------------------------------------------------------------
-- Create new element
---------------------------------------------------------------------------------
function touchElement:createEl(x, y, size)
	
	local defaultSize = self.levelEditor.defaultSize

	local size = size or defaultSize

	local el = touchElementEl:new(self.view, x, y, size, self.elType, self.color)

	el.view.x = x
	el.view.y = y

	local els = self.els
	
	table.insert(els, el)

	self.levelEditor.mainMenu.view.isVisible = true

	self.editGUI:addEl(el)

	return el
end

---------------------------------------------------------------------------------
-- Remove segment
---------------------------------------------------------------------------------
function touchElement:remove(el)
	
	local i = self:findEl(el)

	table.remove(self.els, i)

	el.view:removeSelf( )

	el = nil
end

---------------------------------------------------------------------------------
-- Returns index of the submitted el
---------------------------------------------------------------------------------
function touchElement:findEl(el)

	local els = self.els
	
	for i = 1, #els do

		if els[i] == el then

			return i
		end
	end
end

------------------------------------------------------------------------------------
-- Copy pattern
-- Create new pattern of the same class
------------------------------------------------------------------------------------
function touchElement:copy()
	
	local levelEditor = self.levelEditor
	local patternMenu = levelEditor.patternMenu
	local level = self.level

	local patternCopy = touchElement:new(levelEditor, self.elType)

	level:addPattern(patternCopy)
	patternMenu:addPatternButton(patternCopy)

	local els = self.els

	for i = 1, #els do

		local el = els[i]

		local elCopy = self.copyEl(el, patternCopy, i)

		elCopy.view.x = el.view.x
		elCopy.view.y = el.view.y
	end
end


------------------------------------------------------------------------------------
-- Copy element
------------------------------------------------------------------------------------
function touchElement.copyEl(el, patternCopy)

	local x, y = el.x, el.y

	return patternCopy:createEl(x, y)
end

------------------------------------------------------------------------------------
-- Load from table
------------------------------------------------------------------------------------
function touchElement:loadFromTable(t)

	local view = self.view

	view.x, view.y = t.x, t.y
	self.speed = t.speed
	self.acc = t.acc

	for i = 1, #t.els do

		local el = t.els[i]

		self:createEl(el.x, el.y, el.size)
	end
end

---------------------------------------------------------------------------------
-- Export table
---------------------------------------------------------------------------------
function touchElement:exportTab( )

	if self.els[1] then

		local speed = self.speed
		local acc = self.acc
		
		local tab = {
			speed = speed, 
			acc = acc,
			pattern = "simpleTouchElement",
			params = {touchElement = self.elType}
		}

		for i = 1, #self.els do

			local elTab = {}

			local el = self.els[i]

			tab.params[i] = {el.view.x + self.view.x, el.view.y + self.view.y, el.size}
		end
		
		return tab
	else

		return {}
	end
end

return touchElement