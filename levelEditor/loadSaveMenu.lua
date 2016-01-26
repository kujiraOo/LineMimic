---------------------------------------------------------------------------------
-- Init load save menu
-- Menu should contain 3 buttons save, load and export
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local widget = require("widget")
local saveMenu = require("levelEditor.saveMenu")
local loadMenu = require("levelEditor.loadMenu")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local loadSaveMenu = class("levelEditor.loadSaveMenu")

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local SAVE_DEFAULT_FILE = "gfx/mainMenu/saveDefault.png"
local SAVE_OVER_FILE = "gfx/mainMenu/saveOver.png"
local LOAD_DEFAULT_FILE = "gfx/mainMenu/loadDefault.png"
local LOAD_OVER_FILE = "gfx/mainMenu/loadOver.png"

local OFFSET = 5
local BUTTON_SIZE = 32
local WIDTH = 2 * OFFSET + BUTTON_SIZE
local HEIGHT = 5 * OFFSET + 3 * BUTTON_SIZE
local SAVE_MENU_X = -100
local SAVE_MENU_Y = -200

local LOAD_MENU_X = -160


---------------------------------------------------------------------------------
-- Class constructor
---------------------------------------------------------------------------------
function loadSaveMenu:init(levelEditor, parentView, x, y)

	self.levelEditor = levelEditor
	
	local view = display.newGroup( )
	view.x, view.y = x, y
	view.isVisible = false
	self.view = view

	local bg = display.newRect( view, 0, 0, WIDTH, HEIGHT )
	bg.anchorX, bg.anchorY = 0, 0
	bg:setFillColor( 0, 0.5 )

	self:initSubMenus()
	self:initButtons()

	parentView:insert(view)
end

---------------------------------------------------------------------------------
-- Init menus
---------------------------------------------------------------------------------
function loadSaveMenu:initSubMenus()
	self.saveMenu = saveMenu:new(self.levelEditor, self.view, SAVE_MENU_X, SAVE_MENU_Y)
	self.loadMenu = loadMenu:new(self.saveMenu, self.view, LOAD_MENU_X, SAVE_MENU_Y)
	self.exportMenu = nil
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function loadSaveMenu:hideAll()
	self.saveMenu:hide()
	self.loadMenu:hide()
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
local function buttonReleased(event)

	local subMenu = event.target.params.subMenu
	local menu = event.target.params.menu

	if subMenu.view.isVisible then

		subMenu:hide()
	else

		menu:hideAll()
		subMenu:show()
	end
end

---------------------------------------------------------------------------------
-- Init buttons
---------------------------------------------------------------------------------
function loadSaveMenu:initButtons()

	local saveX, saveY = 0.5 * BUTTON_SIZE + OFFSET, 0.5 * BUTTON_SIZE + OFFSET
	local loadX, loadY = 0.5 * BUTTON_SIZE + OFFSET, 1.5 * BUTTON_SIZE + 2 * OFFSET
	local exportX, exportY = 0.5 * BUTTON_SIZE + OFFSET, 2.5 * BUTTON_SIZE + 3 * OFFSET
	local view = self.view

	local saveButton = widget.newButton{
		x = saveX,
		y = saveY,
		defaultFile = SAVE_DEFAULT_FILE,
		overFile = SAVE_OVER_FILE,
		onRelease = buttonReleased
	}
	saveButton.params = {subMenu = self.saveMenu, menu = self}
	view:insert(saveButton)

	local loadButton = widget.newButton{
		x = loadX,
		y = loadY,
		defaultFile = LOAD_DEFAULT_FILE,
		overFile = LOAD_OVER_FILE,
		onRelease = buttonReleased
	}
	loadButton.params = {subMenu = self.loadMenu, menu = self}
	view:insert(loadButton)


	self.exportButton = nil
end

---------------------------------------------------------------------------------
-- Ensure that the native text field will be hidden
---------------------------------------------------------------------------------
function loadSaveMenu:hide()
	self.view.isVisible = false
	self.saveMenu:hide()
end

return loadSaveMenu