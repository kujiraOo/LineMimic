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
local connectedLineEditGUI = require("levelEditor.patternEditGUI.connectedLineEditGUI")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local connectedLine = pattern:extend("levelEditor.connectedLine")

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
function connectedLine:init(levelEditor, color)
	
	self.super.init(self, levelEditor, color)
	self.name = "connectedLine"
	self.type = "connectedLine"

	self.editGUI = connectedLineEditGUI(self)

	print("connected line got color", self.color)
end

---------------------------------------------------------------------------------
-- Register touch events
---------------------------------------------------------------------------------
function connectedLine:touch(event)

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
function connectedLine:touchBegan(x, y)
	
	local nEls = #self.els
	local levelEditor = self.levelEditor

	levelEditor:hideMenus()

	if nEls == 0 then

		self:createFirstLine(x, y)

	else

		self:createNextLine(x, y)
	end
end

---------------------------------------------------------------------------------
-- On touch moved
---------------------------------------------------------------------------------
function connectedLine:touchMoved(x, y)

	if self.currentLine then
	
		local nEls = #self.els

		if nEls == 0 then

			self.currentLine:draw(x, y)
		else

			self:drawNextLine(x, y)
		end
	end
end


---------------------------------------------------------------------------------
-- On touch ended
---------------------------------------------------------------------------------
function connectedLine:touchEnded(x, y)

	local currentLine = self.currentLine

	if currentLine then

		self:finishLineEdit(x, y)
	end
end

---------------------------------------------------------------------------------
-- When touch ends then fix the line and save it or delete it if its length
-- is too short
---------------------------------------------------------------------------------
function connectedLine:finishLineEdit(x, y)

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
-- Create first line, save it coordinates
-- And save starting coorinate of the pattern
---------------------------------------------------------------------------------
function connectedLine:createFirstLine(x, y)

	self.currentLine = lineSegment:new(self.view, x, y, self.color)
end

---------------------------------------------------------------------------------
-- Create next line
---------------------------------------------------------------------------------
function connectedLine:createNextLine(x, y)

	local currentLine = lineSegment:new(self.view, _, _, self.color)
	currentLine.x = self.lastEl.x2
	currentLine.y = self.lastEl.y2
	self.currentLine = currentLine

	self:drawNextLine(x, y)
end

---------------------------------------------------------------------------------
-- Adjust start point of the next line when moving across the end point of 
-- the last line
---------------------------------------------------------------------------------
function connectedLine:adjustCurrentLineStartPoint(x2, y2)
	
	local lastEl = self.lastEl
	
	local x1, y1 = lineMath.adjustStartPoint(lastEl.x2, lastEl.y2, x2, y2, lastEl.dir)

	self.currentLine.x = x1
	self.currentLine.y = y1
end

---------------------------------------------------------------------------------
-- The orientation of the next line depends on the orientation of the last one
---------------------------------------------------------------------------------
function connectedLine:drawNextLine(x, y)

	local lastDir = self.lastEl.dir
	local currentLine = self.currentLine

	if lastDir == up or lastDir == down then

		self:adjustCurrentLineStartPoint(x, currentLine.y)
		currentLine:draw(x, currentLine.y)

	elseif lastDir == left or lastDir == right then

		self:adjustCurrentLineStartPoint(currentLine.x, y)
		currentLine:draw(currentLine.x, y)
	end
end

---------------------------------------------------------------------------------
-- Save current line
---------------------------------------------------------------------------------
function connectedLine:saveCurrentLine( )

	local els = self.els
	local currentLine = self.currentLine
	
	table.insert(els, currentLine)

	self.editGUI:addEl(currentLine)

	self.lastEl = currentLine
	self.currentLine = nil
end

---------------------------------------------------------------------------------
-- Delete current line
---------------------------------------------------------------------------------
function connectedLine:deleteCurrentLine( )

	self.currentLine.view:removeSelf( )
	self.currentLine = nil
end

---------------------------------------------------------------------------------
-- On touch ended fix current line
---------------------------------------------------------------------------------
function connectedLine:fixCurrentLine(x, y)
	
	local nEls = #self.els

	if nEls == 0 then

		self:fixFirstLine(x, y)

	else

		self:fixNextLine(x, y)
	end
end

---------------------------------------------------------------------------------
-- Fix first line
---------------------------------------------------------------------------------
function connectedLine:fixFirstLine(x, y)

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
-- The orientation of the next line depends on the orientation of the last one
---------------------------------------------------------------------------------
function connectedLine:fixNextLine(x, y)
	
	local lastDir = self.lastEl.dir
	local currentLine = self.currentLine

	if lastDir == up or lastDir == down then

		self:fixNextHorizontalLine(x)

	elseif lastDir == left or lastDir == right then

		self:fixNextVerticalLine(y)
	end
end

---------------------------------------------------------------------------------
-- Fix next horizontal line, make sure that it does not exeed the boundaries
-- of the pattern
---------------------------------------------------------------------------------
function connectedLine:fixNextHorizontalLine(x)

	local currentLine = self.currentLine
	local padding = self.padding
	local width = self.contentWidth - padding

	local contentX = self.view:localToContent(x, 0)

	if contentX > width then

		contentX = width

	elseif contentX < padding then

		contentX = padding
	end

	x = self.view:contentToLocal(contentX)

	currentLine:fix(x, currentLine.y)
end

---------------------------------------------------------------------------------
-- Fix next vertical line, make sure that it does not exeed the boundaries
-- of the pattern
---------------------------------------------------------------------------------
function connectedLine:fixNextVerticalLine(y)
	
	local currentLine = self.currentLine
	local padding = self.padding
	local height = self.contentHeight - padding

	local _, contentY = self.view:localToContent(0, y)

	if contentY > height then

		contentY = height

	elseif contentY < padding then

		contentY = padding
	end

	_, y = self.view:contentToLocal( 0, contentY )

	currentLine:fix(currentLine.x, y)
end

---------------------------------------------------------------------------------
-- This method is called when gui button is pressed
-- The last segment gets deleted
---------------------------------------------------------------------------------
function connectedLine:deleteLastSegment()
	
	local lastEl = self.lastEl
	local els = self.els

	lastEl.view:removeSelf( )
	lastEl = nil

	els[#els] = nil

	self.lastEl = els[#els]
end

------------------------------------------------------------------------------------
-- Copy element
------------------------------------------------------------------------------------
function connectedLine.copyEl(lineSegment, patternCopy, index)

	local x1, y1 = lineSegment.x, lineSegment.y
	local x2, y2 = lineSegment.x2, lineSegment.y2

	if index == 1 then

		patternCopy:createFirstLine(x1, y1)

	else

		patternCopy:createNextLine(x1, y1)
	end

	return patternCopy:finishLineEdit(x2, y2)
end

------------------------------------------------------------------------------------
-- d shows the change in stepper value; +1 or -1
-- Change position of or elements after the element that was changed
------------------------------------------------------------------------------------
function connectedLine:updateElsOnLenChange(el, d)
	
	local els = self.els
	local changedElIndex = self:getElIndex(el)

	for i = changedElIndex + 1, #els do

		if el.dir == left or el.dir == right then

			els[i].view.x = els[i].view.x + d
			els[i].elGUI.view.x = els[i].elGUI.view.x + d

		elseif el.dir == up or el.dir == down then

			els[i].view.y = els[i].view.y + d
			els[i].elGUI.view.y = els[i].elGUI.view.y + d
		end
	end

	self.editGUI.moveButton:updateViewPosition()
end

------------------------------------------------------------------------------------
-- Get element's index
------------------------------------------------------------------------------------
function connectedLine:getElIndex(el)

	local els = self.els
	
	for i = 1, #els do

		if els[i] == el then

			return i
		end
	end
end

---------------------------------------------------------------------------------
-- Export table for drawManager
---------------------------------------------------------------------------------
function connectedLine:exportTab( )

	if self.els[1] then

		local x, y = self.view:localToContent( self.els[1].x, self.els[1].y )
		local speed = self.speed
		local acc = self.acc
		
		local tab = {
			speed = speed, 
			acc = acc,
			pattern = "connectedLine",
			params = {x = x, y = y}
		}

		for i = 1, #self.els do

			local elTab = {}

			local el = self.els[i]

			tab.params[i] = {el.dir, el.len}
		end
		
		return tab
	else

		return {}
	end
end



------------------------------------------------------------------------------------
-- Load elements from table
------------------------------------------------------------------------------------
function connectedLine:loadFromTable(t)

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


return connectedLine