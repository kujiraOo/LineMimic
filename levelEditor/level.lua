---------------------------------------------------------------------------------
-- This object provides view for patterns
-- Saves information about them in a table
-- And exports in a valid format
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local level = class("levelEditor.level")

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function level:init(levelEditor)

	self.levelEditor = levelEditor
	
	self.view = display.newGroup( )

	self.view.object = self

	self:initEditGUIView()

	self.maxNumEls = 10
end

---------------------------------------------------------------------------------
-- This group contains edit guis for patterns
---------------------------------------------------------------------------------
function level:initEditGUIView()
	
	local GUIView = display.newGroup( )

	self.editGUIView = GUIView
end

---------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------
function level:touch(event)
	
	local currentPattern = self.currentPattern
	local controlMode = self.levelEditor.controlMode

	if controlMode == "draw" and currentPattern then

		currentPattern:touch(event)
	end
end

---------------------------------------------------------------------------------
-- Add new pattern
---------------------------------------------------------------------------------
function level:addPattern(pattern)
	
	local view = self.view

	self:handleNameIteration(pattern)

	view:insert(pattern.view)

	pattern.view.zIndex = view.numChildren

	self.currentPattern = pattern

	pattern.level = self -- reference to level
end

---------------------------------------------------------------------------------
-- Add number index to pattern name to exclude the possibility of names'
-- iteration
---------------------------------------------------------------------------------
function level:handleNameIteration(pattern)
	
	local newPatternName = pattern.name
	local view = self.view

	local nIterations = 0

	for i = 1, view.numChildren do

		local name = view[i].object.name

		if name:match("%a+") == newPatternName then

			nIterations = nIterations + 1
		end
	end

	if nIterations > 0 then

		pattern.name = newPatternName..nIterations
	end
end

---------------------------------------------------------------------------------
-- Swith z index of current pattern with previous pattern
---------------------------------------------------------------------------------
function level:patternUp(pattern)

	local view = self.view
	local patternView = pattern.view
	local prevPatternView = view[patternView.zIndex - 1]

	view:insert(patternView.zIndex - 1, patternView)

	prevPatternView.zIndex = patternView.zIndex
	patternView.zIndex = patternView.zIndex - 1
end

---------------------------------------------------------------------------------
-- Swith z index of current pattern with next pattern
---------------------------------------------------------------------------------
function level:patternDown(pattern)
	
	local view = self.view
	local patternView = pattern.view
	local nextPatternView = view[patternView.zIndex + 1]

	view:insert(patternView.zIndex, nextPatternView)

	nextPatternView.zIndex = patternView.zIndex
	patternView.zIndex = patternView.zIndex + 1
end


---------------------------------------------------------------------------------
-- Set current pattern
---------------------------------------------------------------------------------
function level:setCurrentPattern(pattern)

	local controlMode = self.levelEditor.controlMode
	local prevPattern = self.currentPattern

	if prevPattern then

		prevPattern.editGUI.view.isVisible = false
	end

	self.currentPattern = pattern

	if controlMode == "select" then

		pattern.editGUI.view.isVisible = true
	end
end

---------------------------------------------------------------------------------
-- Show current pattern's edit gui
---------------------------------------------------------------------------------
function level:showPatternEditGUI()
	
	local currentPattern = self.currentPattern

	if currentPattern then 

		currentPattern.editGUI:show()
	end
end

---------------------------------------------------------------------------------
-- Export string table
---------------------------------------------------------------------------------
function level:exportString()

	local str = "\nreturn\n{"
	local levelView = self.view
	local nPatterns = self.view.numChildren

	for i = 1, nPatterns do

		local pattern = levelView[i].object
		local patternStr = pattern:exportString()

		str = str.."\n"..patternStr
	end

	str = str.."\n}"

	print(str)
	
	native.showPopup( "mail", {

		to = "kotbegemotoo@gmail.com",
		body = str,
		subject = "level table",
	} )
end

---------------------------------------------------------------------------------
-- Export table
---------------------------------------------------------------------------------
function level:exportTab()
	
	local levelView = self.view
	local nPatterns = self.view.numChildren
	local tab = {}

	tab.maxNumEls = self.maxNumEls

	for i = 1, nPatterns do

		local pattern = levelView[i].object
		local patternTab = pattern:exportTab()
		
		if pattern.view.isVisible then

			table.insert( tab, patternTab )
		end
	end
	
	return tab
end

---------------------------------------------------------------------------------
-- Export for saving
---------------------------------------------------------------------------------
function level:exportSaveTab()
	
	local levelView = self.view
	local nPatterns = self.view.numChildren
	local t = {}

	t.maxNumEls = self.maxNumEls 
	t.patterns = {}

	for i = 1, nPatterns do

		local pattern = levelView[i].object
		local patternT = pattern:exportSaveTab()

		table.insert(t.patterns, patternT)
	end

	return t
end

------------------------------------------------------------------------------------
-- Returns true if level has behaviours
-- Get first pattern and check if it has at least one element
------------------------------------------------------------------------------------
function level:hasBehaviours( )
	
	local firstPatternView = self.view[1]

	if firstPatternView then

		local firstPattern = self.view[1].object

		return firstPattern.els[1]

	else 

		return false
	end
end

------------------------------------------------------------------------------------
-- Copy a pattern
------------------------------------------------------------------------------------
function level:copyPattern(pattern)
	
	local patternCopy = pattern:copy()
end

return level