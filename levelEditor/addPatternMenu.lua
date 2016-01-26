---------------------------------------------------------------------------------
-- Add pattern menu
-- Provides different patterns and elements to create a pattern object to edit
-- Connected line pattern
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")
local color = require("color")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local addPatternMenu = class("levelEditor.addPatternMenu")

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local WIDTH = 200
local HEIGHT = 300
local BUTTON_SPACING = WIDTH / 5

local BUTTON_INACTIVE_ALPHA = 0.5

---------------------------------------------------------------------------------
-- Local functions
---------------------------------------------------------------------------------
local newColorButton, initColorButtons, colorButtonReleased

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function addPatternMenu:init(levelEditor)
	
	self.levelEditor = levelEditor

	local view = display.newGroup()
	view.x = 0.5 * (display.contentWidth - WIDTH)
	view.y = 0.5 * (display.contentHeight - HEIGHT)
	self.view = view

	self.color = color.checked[1]

	self:initBackground()
	self:initLineSection()

	initColorButtonsGroup(self)

	view.isVisible = false
end

---------------------------------------------------------------------------------
-- Background is transparent black rect
---------------------------------------------------------------------------------
function addPatternMenu:initBackground( )
	
	local bg = display.newRect( self.view, 0, 0, WIDTH, HEIGHT )
	bg:setFillColor( 0, 0.5 )
	bg.anchorX = 0
	bg.anchorY = 0

	bg:addEventListener( "touch", self )
end

---------------------------------------------------------------------------------
-- Separate or connected line
---------------------------------------------------------------------------------
function addPatternMenu:initLineSection( )
	
	self:initButton("connectedLine", 1, 1)
	self:initButton("separatedLine", 1, 2)
	self:initTouchElementButton("flower", 3, 1)
	self:initTouchElementButton("reactionBar", 3, 2)
	self:initTouchElementButton("icecream", 3, 3)
	self:initTouchElementButton("wheel", 3, 4)
end

---------------------------------------------------------------------------------
-- Listener for overlay hitbox
---------------------------------------------------------------------------------
function addPatternMenu:touch(event)
	
	return true
end

---------------------------------------------------------------------------------
-- Listener for buttons
---------------------------------------------------------------------------------
function addPatternMenu:tap(event)

	local button = event.target
	local patternName = button.id
	local patternClass = require("levelEditor.pattern."..patternName)
	local levelEditor = self.levelEditor
	local level = self.levelEditor.level
	local mainMenu = levelEditor.mainMenu
	local patternMenu = self.levelEditor.patternMenu
	local touchElType = button.touchElType

	self.view.isVisible = false

	local pattern

	print("touch element", touchElType)

	-- handle two different constructors of different types of patterns
	if touchElType then

		pattern = patternClass:new(self.levelEditor, touchElType, self.color)

	else

		pattern = patternClass:new(self.levelEditor, self.color)
	end

	mainMenu:setToDrawMode()
	
	level:addPattern(pattern)
	patternMenu:addPatternButton(pattern) 
	levelEditor:setPatternNameBarText(pattern.name)

	return true
end

---------------------------------------------------------------------------------
-- Create new button
---------------------------------------------------------------------------------
function addPatternMenu:initButton(pattern, row, col)
	
	local button = widget.newButton( {

		id = pattern,
		x = col * BUTTON_SPACING,
		y = row * BUTTON_SPACING,
		defaultFile = "gfx/addPatternMenu/"..pattern.."Default.png",
		overFile = "gfx/addPatternMenu/"..pattern.."Over.png",
	} )

	button:addEventListener( "tap", self )

	self.view:insert(button)

	return button
end

---------------------------------------------------------------------------------
-- Create new button
---------------------------------------------------------------------------------
function addPatternMenu:initTouchElementButton(touchElType, row, col)
	
	local button = widget.newButton( {

		id = "touchElement",
		x = col * BUTTON_SPACING,
		y = row * BUTTON_SPACING,
		defaultFile = "gfx/addPatternMenu/"..touchElType.."Default.png",
		overFile = "gfx/addPatternMenu/"..touchElType.."Over.png",
	} )

	button.touchElType = touchElType

	button:addEventListener( "tap", self )

	self.view:insert(button)

	return button
end

return addPatternMenu