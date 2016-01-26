---------------------------------------------------------------------------------
-- Extends from pattern super class
-- Draw connected lines
-- User must make drag motion to draw first line
-- The other lines are drawn buy touching and moving the finger and then 
-- releasing. The direction of the lines is chosen automaticaly.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local pattern = require("levelEditor.pattern.pattern")
local lineSegment = require("levelEditor.element.lineSegment")
local lineMath = require("lineMath")
local separatedLineEditGUI = require("levelEditor.patternEditGUI.separatedLineEditGUI")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local separatedLine = pattern:extend("levelEditor.separatedLine")

---------------------------------------------------------------------------------
-- Function cache
---------------------------------------------------------------------------------
local abs = math.abs

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4
local halfWidth = 2
local minLen = 10

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function separatedLine:init(levelEditor, color)
	
	self.super.init(self, levelEditor, color)
	self.name = "separatedLine"
	self.type = "separatedLine"


	self.editGUI = separatedLineEditGUI:new(self)
end

---------------------------------------------------------------------------------
-- Register touch events
---------------------------------------------------------------------------------
function separatedLine:touch(event)

	local phase = event.phase

	local x, y = self.view:contentToLocal( event.x, event.y )

	if phase == "began" then

		self:touchBegan(x, y)

	elseif phase == "moved" then

		self:touchMoved(x, y)

	elseif phase == "ended" then

		self:touchEnded(x, y)
	end
end

---------------------------------------------------------------------------------
-- When touch began
---------------------------------------------------------------------------------
function separatedLine:touchBegan(x, y)
	
	local levelEditor = self.levelEditor

	levelEditor:hideMenus()

	self:createLine(x, y)
end

---------------------------------------------------------------------------------
-- On touch moved
---------------------------------------------------------------------------------
function separatedLine:touchMoved(x, y)

	if self.currentLine then
	
		self.currentLine:draw(x, y)
	end
end


---------------------------------------------------------------------------------
-- On touch ended
---------------------------------------------------------------------------------
function separatedLine:touchEnded(x, y)

	local currentLine = self.currentLine

	if currentLine then

		self:finishLineDrawing(x, y)
	end
end

---------------------------------------------------------------------------------
-- When touch ends then fix the line and save it or delete it if its length
-- is too short
---------------------------------------------------------------------------------
function separatedLine:finishLineDrawing(x, y)

	local currentLine = self.currentLine

	self:fixCurrentLine(x, y)

	if currentLine.len and currentLine.len > minLen then

		self:saveCurrentLine()

	else

		self:deleteCurrentLine()
	end

	self.levelEditor.mainMenu.view.isVisible = true

	return currentLine
end



---------------------------------------------------------------------------------
-- Export table
---------------------------------------------------------------------------------
function separatedLine:exportTab( )

	if self.els[1] then

		local speed = self.speed
		local acc = self.acc
		
		local tab = {
			speed = speed, 
			acc = acc,
			pattern = "separatedLine",
			params = {}
		}

		for i = 1, #self.els do

			local elTab = {}

			local el = self.els[i]

			tab.params[i] = {el.x + self.view.x + el.view.x, el.y + self.view.y + el.view.y, el.dir, el.len}
		end
		
		return tab
	else

		return {}
	end
end

---------------------------------------------------------------------------------
-- Create first line, save it coordinates
-- And save starting coorinate of the pattern
---------------------------------------------------------------------------------
function separatedLine:createLine(x, y)

	self.currentLine = lineSegment:new(self.view, x, y, self.color)
end


---------------------------------------------------------------------------------
-- Save current line
---------------------------------------------------------------------------------
function separatedLine:saveCurrentLine( )

	local els = self.els
	local currentLine = self.currentLine
	local editGUI = self.editGUI
	
	table.insert(els, currentLine)

	print("current line", currentLine)

	editGUI:addEl(currentLine)

	self.lastEl = currentLine
	self.currentLine = nil
end

---------------------------------------------------------------------------------
-- Delete current line
---------------------------------------------------------------------------------
function separatedLine:deleteCurrentLine( )

	self.currentLine.view:removeSelf( )
	self.currentLine = nil
end

---------------------------------------------------------------------------------
-- On touch ended fix current line
-- Make sure that line segment doesn't exeed the bounds of the game field
---------------------------------------------------------------------------------
function separatedLine:fixCurrentLine(x, y)

	local currentLine = self.currentLine
	local padding = self.padding
	local width = self.contentWidth - padding 
	local height = self.contentHeight - padding

	local contentX, contentY = self.view:localToContent( x, y )

	if contentX > width then

		contentX = width

	elseif contentX < padding then

		contentX = padding
	end

	if contentY > height then

		contentY = height

	elseif contentY < padding then

		contentY = padding
	end

	x, y = self.view:contentToLocal( contentX, contentY )

	currentLine:fix(x, y)
end

---------------------------------------------------------------------------------
-- Remove segment
---------------------------------------------------------------------------------
function separatedLine:remove(segment)
	
	local i = self:findSegment(segment)

	table.remove(self.els, i)

	segment.view:removeSelf( )

	segment = nil
end

---------------------------------------------------------------------------------
-- Returns index of the submitted segment
---------------------------------------------------------------------------------
function separatedLine:findSegment(segment)

	local els = self.els
	
	for i = 1, #els do

		if els[i] == segment then

			return i
		end
	end
end

------------------------------------------------------------------------------------
-- Copy element
------------------------------------------------------------------------------------
function separatedLine.copyEl(lineSegment, patternCopy)

	local x1, y1 = lineSegment.x, lineSegment.y
	local x2, y2 = lineSegment.x2, lineSegment.y2

	patternCopy:createLine(x1, y1)
	
	return patternCopy:finishLineDrawing(x2, y2)
end

------------------------------------------------------------------------------------
-- Load elements from table
------------------------------------------------------------------------------------
function separatedLine:loadFromTable(t)

	local view = self.view

	view.x, view.y = t.x, t.y
	self.speed = t.speed
	self.acc = t.acc

	for i = 1, #t.els do

		local el = t.els[i]

		local currentLine = lineSegment:new(view, el.x, el.y, self.color)
		currentLine:draw(el.x2, el.y2)
		currentLine:fix(el.x2, el.y2)

		self.currentLine = currentLine
		self:saveCurrentLine()
	end
end


return separatedLine