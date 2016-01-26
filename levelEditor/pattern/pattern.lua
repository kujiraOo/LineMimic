---------------------------------------------------------------------------------
-- Super class for all patterns
-- All patterns have
-- name
-- view
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local pattern = class("levelEditor.pattern")

---------------------------------------------------------------------------------
-- Class constatns
---------------------------------------------------------------------------------
pattern.contentWidth = 320
pattern.contentHeight = 480
pattern.padding = 10

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function pattern:init(levelEditor, color)

	self.levelEditor = levelEditor
	self.color = color
	self.els = {}
	
	local view = display.newGroup( )
	self.view = view
	self.view.object = self

	self.name = "pattern"
	self.speed = 1
	self.acc = 0
end

function pattern:touch(event)
	
	print(event.phase, event.x, event.y)

end

---------------------------------------------------------------------------------
-- Remove pattern's view from screen and remove pattern from patternMenu
---------------------------------------------------------------------------------
function pattern:removeSelf()
	
	local view = self.view

	local levelView = self.view.parent
	local level = levelView.object
	local editGUIView = self.editGUI.view

	view:removeSelf( )
	editGUIView:removeSelf( )

	print("num children of level view", levelView.numChildren)

	local patternMenu = self.patternMenu
	patternMenu:removePatternButton(self)

	if level.currentPattern == self then

		level.currentPattern = nil
	end
end

------------------------------------------------------------------------------------
-- Copy pattern
-- Create new pattern of the same class
------------------------------------------------------------------------------------
function pattern:copy()

	local levelEditor = self.levelEditor
	local patternMenu = levelEditor.patternMenu
	local level = self.level

	local patternClass = require("levelEditor.pattern."..self.type)

	local patternCopy = patternClass:new(levelEditor)

	level:addPattern(patternCopy)
	patternMenu:addPatternButton(patternCopy)

	local els = self.els

	for i = 1, #els do

		local el = els[i]

		local elCopy = self.copyEl(el, patternCopy, i)

		elCopy.view.x = el.view.x
		elCopy.view.y = el.view.y
	end

	self.editGUI.view.isVisible = false

	levelEditor:setPatternNameBarText(patternCopy.name)
end

------------------------------------------------------------------------------------
-- Export pattern for saving
------------------------------------------------------------------------------------
function pattern:exportSaveTab()

	local els = self.els

	local t = {}

	t.x, t.y = self.view.x, self.view.y
	t.speed = self.speed
	t.acc = self.acc
	t.els = {}
	t.patternType = self.type

	-- For touch Element
	t.elType = self.elType
	
	for i = 1, #els do

		local el = {}

		-- Position of touch elements and line elements are handled differently
		if self.type == "touchElement" then

			el.x = els[i].view.x
			el.y = els[i].view.y

		-- For pattern using lines
		else

			el.x = els[i].x + els[i].view.x
			el.y = els[i].y + els[i].view.y

			el.x2 = els[i].x2 + els[i].view.x
			el.y2 = els[i].y2 + els[i].view.y
		end

		-- For touch element pattern
		el.size = els[i].size

		t.els[i] = el
	end

	return t
end

return pattern