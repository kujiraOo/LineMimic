------------------------------------------------------------------------------------
-- File reactionBar.lua
-- Class draws animated reactionBar
-- Gets bigger after it appears
-- Player must touch it to check it
-- When initial animation is complete then elements manager
-- spawns new element
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local touchElement = require("element.touchElement")
local shape = require("shape")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local reactionBar = touchElement:extend("reactionBar")

------------------------------------------------------------------------------------
-- Function cache
------------------------------------------------------------------------------------
local rnd = math.random

------------------------------------------------------------------------------------
-- Local constants
------------------------------------------------------------------------------------
local checkZone = 20
local barHeight = 8
local barWidth = 150
local strokeWidth = 2
local radius = 8
local cursorAnimTime = 1000

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function reactionBar:init(parentView, x, y, size, time)

	self.super.init(self, x, y)

	self:initGraphics(x, y, parentView)
	self:initDrawingAnimation(size, time)
	self:initCursorAnimation()
end

------------------------------------------------------------------------------------
-- Init view, cursor and bar
------------------------------------------------------------------------------------
function reactionBar:initGraphics(x, y, parentView)

	self:initBar()
	self:initCursor()

	self:setUpView(x, y, parentView)
end

------------------------------------------------------------------------------------
-- Bar consists from rect object and 2 lines that mark the check zone
------------------------------------------------------------------------------------
function reactionBar:initBar( )
	
	self.view = shape.reactionBar()

	self.barOutline = self.view.barOutline
	self.checkZoneL = self.view.checkZoneL
	self.checkZoneR = self.view.checkZoneR
end

------------------------------------------------------------------------------------
-- Cursor is circle object
------------------------------------------------------------------------------------
function reactionBar:initCursor( )

	local view = self.view

	local xCenter = -0.5 * barWidth + radius
	local yCenter = 0

	local cursor = display.newCircle( view, xCenter, yCenter, radius )

	self.cursor = cursor
end


------------------------------------------------------------------------------------
-- Set element's color
------------------------------------------------------------------------------------
function reactionBar:setColor(c)
	
	local barOutline = self.barOutline
	local checkZoneL = self.checkZoneL
	local checkZoneR = self.checkZoneR
	local cursor = self.cursor

	shape.setColor(self.view, c)
	cursor:setFillColor( c.r, c.g, c.b )
end

------------------------------------------------------------------------------------
-- Everytime animation step is complete init new animation with reversed toX
------------------------------------------------------------------------------------
local function onCursorAnimStepComplete(cursor)

	print("anim comp")

	local reactionBarObj = cursor.reactionBarObj
	
	cursor.toX = -cursor.toX

	reactionBarObj:newCursorTransition()
end

------------------------------------------------------------------------------------
-- Init animation of the cursor
-- Cursor moves along the bar back and forth
------------------------------------------------------------------------------------
function reactionBar:initCursorAnimation()

	local cursor = self.cursor
	local toX = 0.5 * barWidth - radius

	cursor.toX = toX
	cursor.reactionBarObj = self

	self:newCursorTransition()
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function reactionBar:newCursorTransition()

	local cursor = self.cursor
	
	local animParams = {
		x = cursor.toX, 
		time = cursorAnimTime, 
		onComplete = onCursorAnimStepComplete,
		transition = easing.inOutQuad,
	}

	self.cursorAnim = transition.to(cursor, animParams)
end

------------------------------------------------------------------------------------
-- The reaction bar object becomes checked if player touches the bar when
-- the cursor is in bar's check zone
------------------------------------------------------------------------------------
function reactionBar:check(cc)
	
	if self:isCursorInCheckZone() then

		self:onChecked(cc)
	end
end

------------------------------------------------------------------------------------
-- Checks if cursor is check zone
------------------------------------------------------------------------------------
function reactionBar:isCursorInCheckZone( )
	
	local cursorX = self.cursor.x
	local checkZoneLX = -0.5 * checkZone
	local checkZoneRX = 0.5 * checkZone

	return cursorX > checkZoneLX and cursorX < checkZoneRX
end

------------------------------------------------------------------------------------
-- Things to do after reactionBar is checked
-- Fill the bar outline
-- Cancel cursor anim
-- Make cursor bigger and center it
-- Init rotation animation
------------------------------------------------------------------------------------
function reactionBar:onChecked(cc)
	
	local barOutline = self.barOutline
	local cursor = self.cursor
	local view = self.view

	transition.cancel(self.cursorAnim)
	transition.to(cursor, {x = 0, xScale = 1.5, yScale = 1.5, time = 300})

	transition.to(view, {rotation = 360, time = 4000, iterations = -1})

	barOutline:setFillColor( cc.r, cc.g, cc.b )

	self:setColor(cc)
	self.isChecked = true
end

return reactionBar