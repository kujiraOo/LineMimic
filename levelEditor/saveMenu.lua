---------------------------------------------------------------------------------
-- Save menu contains a text field to input the name of the level
-- and a submit/save button that calls level's save function
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local loadsave = require("loadsave")
local textButton = require("levelEditor.button.textButton")
local yesNoWindow = require("levelEditor.yesNoWindow")
local popUp = require("levelEditor.popUp")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local saveMenu = class("levelEditor.saveMenu")

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local WIDTH = 100
local HEIGHT = 100
local TEXTFIELD_WIDTH = 0.8 * WIDTH
local TEXTFIELD_HEIGHT = 20
local TEXTFIELD_X = 0.5 * WIDTH
local TEXTFIELD_Y = 0.3 * HEIGHT

local SAVE_BUTTON_X = 0.5 * WIDTH
local SAVE_BUTTON_Y = 0.7 * HEIGHT
local SAVE_BUTTON_WIDTH = 0.5 * WIDTH 
local SAVE_BUTTON_HEIGHT = 0.3 * HEIGHT


---------------------------------------------------------------------------------
-- Class constructor 
---------------------------------------------------------------------------------
function saveMenu:init(levelEditor, parentView, x, y)

	self.levelEditor = levelEditor

	local view = display.newGroup( )
	view.x, view.y = x, y
	view.isVisible = false
	self.view = view

	local bg = display.newRect( view, 0, 0, WIDTH, HEIGHT )
	bg.anchorX, bg.anchorY = 0, 0
	bg:setFillColor( 0, 0.5 )

	self:initLevelNameTextField()
	self:initOverwriteWindow()
	self:initSaveButton()

	-- Move alert window to front
	self.overwriteWindow:toFront( )

	parentView:insert(view)
end

---------------------------------------------------------------------------------
-- Checks if the table contains the name of the level
---------------------------------------------------------------------------------
local function containsLevelName(t, levelName)
	
	for i = 1, #t do

		if t[i] == levelName then

			return true
		end
	end

	return false
end

---------------------------------------------------------------------------------
-- Update level list file or create it if it doesn't exist
---------------------------------------------------------------------------------
local function updateLevelList(levelName)
	
	local levels = loadsave.loadTable("levelsList") or {}

	if not containsLevelName(levels, levelName) then

		table.insert(levels, levelName)
		loadsave.saveTable(levels, "levelsList")
	end

	for i = 1, #levels do
		print (levels[i])
	end
end

---------------------------------------------------------------------------------
-- Save level to a to a file
---------------------------------------------------------------------------------
local function save(levelNameTextField, levelEditor)

	local level = levelEditor.level
	
	local levelTable = level:exportSaveTab()
	local levelName = levelNameTextField.text

	-- new name is reserved for new level button
	if levelName ~= "new" then

		loadsave.saveTable(levelTable, levelName)
		print("saving to", levelName)

		popUp.show("level saved")

		updateLevelList(levelName)
	end
end

---------------------------------------------------------------------------------
-- Overwrite window appears when trying to save to file that already exists
---------------------------------------------------------------------------------
function saveMenu:initOverwriteWindow()

	local W = 150
	local X = 0.5 * (display.contentWidth - W)
	local Y = 210


	local overwriteWindow = yesNoWindow.new{

		label = "overwrite file?",
		hide = true,
		w = W,
		x = X,
		y = Y,

		yListenerT = {
			{
				save,
				self.textField,
				self.levelEditor,
			}
		},
	}

	-- Create reference for menu
	self.overwriteWindow = overwriteWindow

	-- Hide window
	overwriteWindow.isVisible = false
end

---------------------------------------------------------------------------------
-- Text field to give level a name
---------------------------------------------------------------------------------
function saveMenu:initLevelNameTextField()
	
	local textField = native.newTextField( TEXTFIELD_X, TEXTFIELD_Y, TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT)
	textField.text = "newLevel"
	textField.size = nil
	textField:resizeHeightToFitFont()
	textField.isVisible = false
	self.view:insert(textField)
	self.textField = textField

	self.view.nativeDisplayObjects = {textField} -- omg cant think about anything cuter
end



---------------------------------------------------------------------------------
-- Save level's table to file, using export tab method of the level
-- the name of the file will be the same as the name of the level
-- Add level name to list of saved levels
---------------------------------------------------------------------------------
local function saveButtonReleased(params)

	local levelNameTextField = params.levelNameTextField
	local levelName = levelNameTextField.text
	local levelEditor = params.levelEditor
	local overwriteWindow = params.overwriteWindow

	local path = system.pathForFile( levelName, system.DocumentsDirectory )
	local file = io.open(path)

	if not file then

		save(levelNameTextField, levelEditor)
	else 

		print("file already exists")
		overwriteWindow.isVisible = true
		file:close()
	end
end

---------------------------------------------------------------------------------
-- Save button will pass level and its name set by textfield to save library
---------------------------------------------------------------------------------
function saveMenu:initSaveButton()

	local listenersTable = {
		{
			saveButtonReleased,
			{
				levelEditor = self.levelEditor, 
				levelNameTextField = self.textField,
				overwriteWindow = self.overwriteWindow,
			}
		}
	}

	textButton.new(self.view, SAVE_BUTTON_X, SAVE_BUTTON_Y, 
					SAVE_BUTTON_WIDTH, SAVE_BUTTON_HEIGHT, 
					"save", listenersTable)
end

function saveMenu:show()
	
	self.view.isVisible = true
	self.textField.isVisible = true
end

function saveMenu:hide()
	
	self.view.isVisible = false
	self.textField.isVisible = false
end

return saveMenu

