---------------------------------------------------------------------------------
-- Main menu object
--
-- Main menu is bar menu that is located on the right of the screen
-- It contains folowing buttons:
--
-- Draw mode
-- Select mode
-- Order mode 
-- Default size of element
-- Add pattern 
-- Patterns' order and options menu
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")
local showButton = require("levelEditor.button.showButton")
local stepperSheet = require("levelEditor.textureManager").stepperSheet
local composer = require("composer")
local loadSaveMenu = require("levelEditor.loadSaveMenu")

---------------------------------------------------------------------------------
-- Local constatnts
---------------------------------------------------------------------------------
local buttonSpacing = 45
local barViewWidth = 50
local barViewHeight = 400
local elColor = {r = 0.6, g = 0.9, b = 1}
local LOAD_SAVE_MENU = {
	X = -55,
	Y = 260,
	BUTTON_OVER_FILE = "gfx/mainMenu/loadSaveOver.png",
	BUTTON_DEFAULT_FILE = "gfx/mainMenu/loadSaveDefault.png",
}

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local mainMenu = class("levelEditor.mainMenu")

---------------------------------------------------------------------------------
-- Class construtctor
---------------------------------------------------------------------------------
function mainMenu:init(levelEditor)

	self.levelEditor = levelEditor
	self:initGraphics()
end

---------------------------------------------------------------------------------
-- Init menu bar, buttons and show hide button
---------------------------------------------------------------------------------
function mainMenu:initGraphics( )


	local view = display.newGroup( )

	view.x = 320 - barViewWidth
	view.y = 0.5 * (480 - barViewHeight)

	self.view = view

	self:initBar()
	self.loadSaveMenu = loadSaveMenu:new(self.levelEditor, view, LOAD_SAVE_MENU.X, LOAD_SAVE_MENU.Y)
	self:initButtons()
end

---------------------------------------------------------------------------------
-- Init menu's bar, transparent gray rect object
---------------------------------------------------------------------------------
function mainMenu:initBar( )
	
	local view = self.view
	local barView = display.newGroup( )

	view:insert(barView)
	self.barView = barView

	local bar = display.newRect( barView, 0, 0, barViewWidth, barViewHeight )
	bar.anchorX = 0
	bar.anchorY = 0
	bar:setFillColor(0, 0.5 )
end

---------------------------------------------------------------------------------
-- Call methods that create instrument button group and 3 other buttons
---------------------------------------------------------------------------------
function mainMenu:initButtons()

	self:initTestLevelButton()
	
	self:initInstrumentGroup()

	self:initDefaultSizeButton()
	self:initDefaultSizeWindow()

	self:initAddPatternButton()
	self:initPatternMenuButton()

	self:initShowButton()

	self.loadSaveButton = self:initLoadSaveButton()
end


---------------------------------------------------------------------------------
-- Create instument buttons group
-- There are 3 instruments
-- draw
-- select
-- order
---------------------------------------------------------------------------------
function mainMenu:initInstrumentGroup( )

	local barView = self.barView
	
	self.instrumentGroup = display.newGroup( )

	local drawButton = self:initInstrumentButton("draw")
	drawButton.x = 0.5 * barViewWidth
	drawButton.y = (barView.numChildren - 1) * buttonSpacing
	self.drawButton = drawButton

	local selectButton = self:initInstrumentButton("select")
	selectButton.alpha = 0.3
	selectButton.x = 0.5 * barViewWidth
	selectButton.y = (barView.numChildren - 1) * buttonSpacing
	self.selectButton = selectButton

	--[[local orderButton = self:initInstrumentButton("order")
	orderButton.alpha = 0.3
	orderButton.x = 0.5 * barViewWidth
	orderButton.y = (barView.numChildren - 1) * buttonSpacing
	self.orderButton = orderButton]]
end

---------------------------------------------------------------------------------
-- Init instrument button
---------------------------------------------------------------------------------
function mainMenu:initInstrumentButton(id)

	local button = widget.newButton({

		defaultFile = "gfx/mainMenu/"..id.."ButtonDefault.png",
		overFile = "gfx/mainMenu/"..id.."ButtonOver.png",
		onRelease = function ( )

			self:instrumentButtonPressed(id)
		end
	})

	self.barView:insert(button)

	return button
end

---------------------------------------------------------------------------------
-- When button from instrument group is pressed
---------------------------------------------------------------------------------
function mainMenu:instrumentButtonPressed(id)

	self:instrumentGroupResetAlpha()

	local levelEditor = self.levelEditor
	levelEditor.controlMode = id

	self[id.."Button"].alpha = 1

	if id == "select" then

		levelEditor.level:showPatternEditGUI()

	elseif id == "draw" then

		if levelEditor.level.currentPattern then
			levelEditor.level.currentPattern.editGUI.view.isVisible = false
		end
	end
end

---------------------------------------------------------------------------------
-- Set alpha of all buttons of instrument group to inactive
---------------------------------------------------------------------------------
function mainMenu:instrumentGroupResetAlpha( )
	
	self.drawButton.alpha = 0.3
	self.selectButton.alpha = 0.3
--	self.orderButton.alpha = 0.3
end

---------------------------------------------------------------------------------
-- Set main menu and level editor to draw mode
---------------------------------------------------------------------------------
function mainMenu:setToDrawMode()

	local levelEditor = self.levelEditor
	local currentPattern = self.levelEditor.level.currentPattern

	levelEditor.controlMode = "draw"

	if currentPattern then
		currentPattern.editGUI.view.isVisible = false
	end

	self:instrumentGroupResetAlpha()
	self.drawButton.alpha = 1
end

---------------------------------------------------------------------------------
-- Create default size button
---------------------------------------------------------------------------------
function mainMenu:initDefaultSizeButton( )

	local barView = self.barView

	local button = widget.newButton( {

		label = self.levelEditor.defaultSize,
		labelColor = { default = {0.6, 0.9, 1}},
		x = 0.5 * barViewWidth,
		y = barView.numChildren * buttonSpacing,
		defaultFile = "gfx/mainMenu/sizeButtonDefault.png",
		overFile = "gfx/mainMenu/sizeButtonOver.png",

		onRelease = function ( )
			
			self.levelEditor.patternMenu:hide()
			self.levelEditor.addPatternMenu.view.isVisible = false
			self.defaultSizeWindow.isVisible = not self.defaultSizeWindow.isVisible
		end
	} )

	self.defaultSizeButton = button
	barView:insert(button)
end

---------------------------------------------------------------------------------
-- Default size window contains a stepper that controls levelEditor.defaultSize
-- variable
---------------------------------------------------------------------------------
function mainMenu:initDefaultSizeWindow( )
	
	local window = display.newGroup( )
	window.x = -40
	window.y = 4 * buttonSpacing
	window.isVisible = false

	local bg = display.newRect( window, 0, 0, 60, 40 )
	bg:setFillColor( 0, 0.5 )

	local stepper = widget.newStepper( {

		initialValue = self.levelEditor.defaultSize,
		minimumValue = 10,
		maximumValue = 200,
		width = 48,
		heigth = 24,
		sheet = stepperSheet,
		defaultFrame = 1,
		noMinusFrame = 2,
		noPlusFrame = 3,
		minusActiveFrame = 4,
		plusActiveFrame = 5,

		onPress = function ( event )

			local defaultSize = self.levelEditor.defaultSize

			if event.phase == "increment" then

				defaultSize = defaultSize + 1
			elseif event.phase == "decrement" then

				defaultSize = defaultSize - 1
			end

			self.levelEditor.defaultSize = defaultSize
			self.defaultSizeButton:setLabel( defaultSize )
		end
	} )

	stepper.anchorX = 0.5
	stepper.x = 0
	stepper.y = 0
	window:insert(stepper)

	self.view:insert(window)
	self.defaultSizeWindow = window
end

---------------------------------------------------------------------------------
-- Create add pattern button
---------------------------------------------------------------------------------
function  mainMenu:initAddPatternButton( )

	local barView = self.barView
	
	local button = widget.newButton( {

		x = 0.5 * barViewWidth,
		y = barView.numChildren * buttonSpacing,
		defaultFile = "gfx/mainMenu/addPatternButtonDefault.png",
		overFile = "gfx/mainMenu/addPatternButtonOver.png",
		onRelease = function ( )
			
			self.defaultSizeWindow.isVisible = false
			self.levelEditor.patternMenu:hide()
			self.levelEditor.addPatternMenu.view.isVisible = not self.levelEditor.addPatternMenu.view.isVisible
		end
	} )

	barView:insert(button)
end

---------------------------------------------------------------------------------
-- Create pattern menu button
---------------------------------------------------------------------------------
function mainMenu:initPatternMenuButton( )

	local barView = self.barView
	
	local button = widget.newButton( {

		x = 0.5 * barViewWidth,
		y = barView.numChildren * buttonSpacing,
		defaultFile = "gfx/mainMenu/patternMenuButtonDefault.png",
		overFile = "gfx/mainMenu/patternMenuButtonOver.png",
		onRelease = function ( )
			
			self.defaultSizeWindow.isVisible = false
			self.levelEditor.addPatternMenu.view.isVisible = false

			local menuView = self.levelEditor.patternMenu.view
			menuView.isVisible = not menuView.isVisible
		end
	} )

	barView:insert(button)
end

---------------------------------------------------------------------------------
-- On test level button pressed
-- Go to game screen and load level with table from editor
---------------------------------------------------------------------------------
local function testLevelButtonTouched(event)
	
	local phase = event.phase

	if phase == "ended" then
		
		local level = event.target.levelEditor.level

		if level:hasBehaviours() then

			composer.gotoScene("scenes.gameScreen", {

				params = {

					levelFromEditor = true,
					behaviours = level:exportTab(),
				}
			})
		end
	end

	return true
end

---------------------------------------------------------------------------------
-- Create export button
-- This button changes to gameScreen scene, with testLevel
---------------------------------------------------------------------------------
function mainMenu:initTestLevelButton()

	local barView = self.barView
	
	local button = widget.newButton{

		x = 0.5 * barViewWidth,
		y = barView.numChildren * buttonSpacing,
		defaultFile = "gfx/mainMenu/testLevelDefault.png",
		overFile = "gfx/mainMenu/testLevelOver.png",
		onEvent = testLevelButtonTouched
	}

	button.levelEditor = self.levelEditor

	barView:insert(button)
end

function mainMenu:initLoadSaveButton()

	local barView = self.barView
	
	local button = widget.newButton{

		x = 0.5 * barViewWidth,
		y = barView.numChildren * buttonSpacing,
		defaultFile = LOAD_SAVE_MENU.BUTTON_DEFAULT_FILE,
		overFile = LOAD_SAVE_MENU.BUTTON_OVER_FILE,

		onRelease = function ()

			local loadSaveMenu = self.loadSaveMenu

			if loadSaveMenu.view.isVisible then

				loadSaveMenu:hide()
			else

				loadSaveMenu.view.isVisible = true
			end
		end
	}

	button.level = self.levelEditor.level

	barView:insert(button)
end

---------------------------------------------------------------------------------
-- This function shows and hides bar's view
---------------------------------------------------------------------------------
local function showMainMenu(event)
	
	local mainMenu = event.target.params.mainMenu
	local barView = mainMenu.barView
	local loadSaveMenu = mainMenu.loadSaveMenu

	barView.isVisible = not barView.isVisible
	loadSaveMenu.view.isVisible = false
end

---------------------------------------------------------------------------------
-- Init show button
-- Show button show and hides the main menu
---------------------------------------------------------------------------------
function mainMenu:initShowButton()

	local button = widget.newButton{

		x = 0.5 * barViewWidth,
		y = 12,
		defaultFile = "gfx/patternMenu/hideDefault.png",
		overFile = "gfx/patternMenu/hideOver.png",
		onRelease = showMainMenu,
	}

	button.params = {mainMenu = self}

	self.view:insert(button)
end


return mainMenu