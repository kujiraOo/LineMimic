---------------------------------------------------------------------------------
-- This menu is a list of all patterns on the level
-- Pattern has name
-- Pattern can be dragged and swapped with other patterns, that effects the
-- order in which patterns appear while the level runs
-- Pattern has two buttons
-- - Toggle visibility of the pattern
-- - Options 
-- - - speed
-- - - acceleration
-- - - name
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")
local patternSubMenu = require("levelEditor.patternSubMenu")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local patternMenu = class("levelEditor.patternMenu")

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local elColor = {r = 0.6, g = 0.9, b = 1}

local menuX = 10
local menuY = 40
local menuWidth = 250
local menuHeight = 430

local elMargin = 10
local elSpacing = 50
local elWidth = 230
local elHeight = 40

local upX = 180
local downX = 210
local showHideX = 150
local subMenuX = 120
local subButtonY = 0.5 * elHeight

---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function patternMenu:init(levelEditor)

	self.buttons = {}

	self.levelEditor = levelEditor

	self:initScrollView()
end

---------------------------------------------------------------------------------
-- Init menu's scroll view
---------------------------------------------------------------------------------
function patternMenu:initScrollView()
	
	local scrollView = widget.newScrollView{

		left = menuX,
		top = menuY,
		width = menuWidth,
		height = menuHeight,
		horizontalScrollDisabled = true,
		backgroundColor = {0, 0.5}
	}

	self.view = scrollView

	scrollView.isVisible = false
end

---------------------------------------------------------------------------------
-- Calculate button's y based on its id
---------------------------------------------------------------------------------
local function calcButtonY(id)
	
	return (id - 1) * elSpacing + elMargin
end

---------------------------------------------------------------------------------
-- Calc sub menu y
---------------------------------------------------------------------------------
local function calcSubMenuY(buttonY)
	
	return buttonY + elHeight
end

---------------------------------------------------------------------------------
-- Init text of pattern button
---------------------------------------------------------------------------------
local function addLabel(button, name)
	
	local label = display.newText( name, elMargin, 0.5 * elHeight, "Helvetica", 12 )
	label:setTextColor( elColor.r, elColor.g, elColor.b )
	label.anchorX = 0

	button.label = label
	button:insert(label)
end

---------------------------------------------------------------------------------
-- Add background frame to button
---------------------------------------------------------------------------------
local function addBackground(button)
	
	local bg = display.newRoundedRect( button, 0, 0, elWidth, elHeight, 3 )

	bg:setFillColor( 0, 0 )
	bg:setStrokeColor( elColor.r, elColor.g, elColor.b )
	bg.strokeWidth = 2
	bg.anchorX = 0
	bg.anchorY = 0
end

---------------------------------------------------------------------------------
-- Add hit box
---------------------------------------------------------------------------------
local function addHitbox(button)
	
	local hitbox = display.newRect( button, 0, 0, 0.45 * elWidth, elHeight )
	hitbox.anchorX = 0
	hitbox.anchorY = 0
	hitbox.isVisible = false
	hitbox.isHitTestable = true

	button.hitbox = hitbox
end

---------------------------------------------------------------------------------
-- Up button listener
---------------------------------------------------------------------------------
local function upButtonListener(event)

	local button = event.target.parent

	button.menu:hideSubMenuView()

	if button.id > 1 then
	
		local buttons = button.menu.buttons
		local prevButton = buttons[button.id - 1]
		local pattern = button.pattern
		local level = button.menu.levelEditor.level

		button.id = button.id - 1
		button.y = calcButtonY(button.id)
		buttons[button.id] = button

		prevButton.id = prevButton.id + 1
		prevButton.y = calcButtonY(prevButton.id)
		buttons[prevButton.id] = prevButton

		level:patternUp(pattern)
	end

	return true
end

---------------------------------------------------------------------------------
-- Add up button
---------------------------------------------------------------------------------
local function addUpButton(button)
	
	local upButton = widget.newButton{

		x = upX,
		y = subButtonY,
		width = 24,
		height = 24,
		defaultFile = "gfx/patternMenu/upDefault.png",
		overFile = "gfx/patternMenu/upOver.png"
	}

	upButton:addEventListener( "tap", upButtonListener )

	button:insert(upButton)
end

---------------------------------------------------------------------------------
-- Down button listener
---------------------------------------------------------------------------------
local function downButtonListener(event)
	
	local button = event.target.parent
	local buttons = button.menu.buttons

	button.menu:hideSubMenuView()

	if button.id < #buttons then 

		local nextButton = buttons[button.id + 1]
		local pattern = button.pattern
		local level = button.menu.level

		button.id = button.id + 1
		button.y = calcButtonY(button.id)
		buttons[button.id] = button

		nextButton.id = nextButton.id - 1
		nextButton.y = calcButtonY(nextButton.id)
		buttons[nextButton.id] = nextButton

		level:patternDown(pattern)
	end

	return true
end 

---------------------------------------------------------------------------------
-- Add down button
---------------------------------------------------------------------------------
local function addDownButton(button)
	
	local downButton = widget.newButton{

		x = downX,
		y = subButtonY,
		width = 24,
		height = 24,
		defaultFile = "gfx/patternMenu/downDefault.png",
		overFile = "gfx/patternMenu/downOver.png"
	}

	downButton:addEventListener( "tap", downButtonListener )

	button:insert(downButton)
end

---------------------------------------------------------------------------------
-- Show button listener
-- Show pattern's view and hide button, hide show button
---------------------------------------------------------------------------------
local function showButtonListener(event)
	
	local showButton = event.target
	local button = showButton.parent
	local patternView = button.pattern.view
	local hideButton = button.hideButton

	hideButton.isVisible = true
	showButton.isVisible = false
	patternView.isVisible = true

	return true
end

---------------------------------------------------------------------------------
-- Add show button
---------------------------------------------------------------------------------
local function addShowButton(button)
	
	local showButton = widget.newButton{

		x = showHideX, 
		y = subButtonY,
		width = 24,
		height = 24,
		defaultFile = "gfx/patternMenu/showDefault.png",
		overFile = "gfx/patternMenu/showOver.png",
	}

	showButton.button = button
	showButton.isVisible = false

	showButton:addEventListener( "tap", showButtonListener )

	button.showButton = showButton
	button:insert(showButton)
end


---------------------------------------------------------------------------------
-- Show button listener
-- Show pattern's view and hide button, hide show button
---------------------------------------------------------------------------------
local function hideButtonListener(event)
	
	local hideButton = event.target
	local button = hideButton.parent
	local patternView = button.pattern.view
	local showButton = button.showButton

	hideButton.isVisible = false
	showButton.isVisible = true
	patternView.isVisible = false

	return true
end

---------------------------------------------------------------------------------
-- Add hide button
---------------------------------------------------------------------------------
local function addHideButton(button)
	
	local hideButton = widget.newButton{

		x = showHideX, 
		y = subButtonY,
		width = 24,
		height = 24,
		defaultFile = "gfx/patternMenu/hideDefault.png",
		overFile = "gfx/patternMenu/hideOver.png"
	}

	hideButton.button = button

	hideButton:addEventListener( "tap", hideButtonListener )

	button.hideButton = hideButton
	button:insert(hideButton)
end

---------------------------------------------------------------------------------
-- Sub menu button listener
---------------------------------------------------------------------------------
local function subMenuButtonListener(event)

	local button = event.target.parent
	local subMenuView = button.subMenu.view
	local buttons = button.buttons
	local menu = button.menu

	local prevSubMenuView = menu.currentSubMenuView

	subMenuView.y = button.y + elHeight
	subMenuView.isVisible = not subMenuView.isVisible
	subMenuView:toFront()

	menu.currentSubMenuView = subMenuView

	if prevSubMenuView and prevSubMenuView ~= subMenuView then
		prevSubMenuView.isVisible = false
	end
end

---------------------------------------------------------------------------------
-- Add sub menu button
---------------------------------------------------------------------------------
local function addSubMenuButton(button)
	
	local subMenuButton = widget.newButton{
		x = subMenuX,
		y = subButtonY,
		width = 24,
		height = 24,
		defaultFile = "gfx/patternMenu/subMenuDefault.png",
		overFile = "gfx/patternMenu/subMenuOver.png"
	}

	subMenuButton:addEventListener( "tap", subMenuButtonListener )

	button:insert(subMenuButton)
end

---------------------------------------------------------------------------------
-- Button listener
---------------------------------------------------------------------------------
local function buttonOnTap(event)

	local button = event.target.parent
	local menuView = button.menu.view

	local pattern = button.pattern
	local level = button.menu.levelEditor.level
	local levelEditor = button.menu.levelEditor

	level:setCurrentPattern(pattern)
	menuView.isVisible = false

	levelEditor:setPatternNameBarText(pattern.name)
	
	return true
end

---------------------------------------------------------------------------------
-- Add pattern to patterMenu
---------------------------------------------------------------------------------
function patternMenu:addPatternButton(pattern)

	local view = self.view
	local buttons = self.buttons

	local button = display.newGroup( )
	view:insert(button)
	button.x = elMargin
	button.y = #buttons * elSpacing + elMargin
	button.id = #buttons + 1
	button.menu = self
	button.pattern = pattern

	addBackground(button)
	addHitbox(button)
	addLabel(button, pattern.name)
	addUpButton(button)
	addDownButton(button)
	addShowButton(button)
	addHideButton(button)
	addSubMenuButton(button)

	button.subMenu = patternSubMenu:new(button)
	button.subMenu.view.isVisible = false

	button.hitbox:addEventListener( "tap", buttonOnTap )

	table.insert( buttons, button )

	pattern.patternMenu = self
end

---------------------------------------------------------------------------------
-- Remove pattern button from menu
---------------------------------------------------------------------------------
function patternMenu:removePatternButton(pattern)

	local buttons = self.buttons

	for i = 1, #buttons do

		local button = buttons[i]
		local patternFromList = button.pattern

		if patternFromList == pattern then

			button:removeSelf( )
			table.remove(buttons, i )
		end
	end
end

---------------------------------------------------------------------------------
-- Hide pattern menu
---------------------------------------------------------------------------------
function patternMenu:hide()

	self.view.isVisible = false
	self:hideSubMenuView()
end

---------------------------------------------------------------------------------
-- Hide current sub menu's view
---------------------------------------------------------------------------------
function patternMenu:hideSubMenuView()
	
	local currentSubMenuView = self.currentSubMenuView

	if currentSubMenuView then

		currentSubMenuView.isVisible = false
	end
end

return patternMenu