---------------------------------------------------------------------------------
-- Save menu contains a text field to input the name of the level
-- and a submit/save button that calls level's save function
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local elColor = require("levelEditor.color").elColor
local loadsave = require("loadsave")
local menuBackground = require("levelEditor.menuBackground")
local textButton = require("levelEditor.button.textButton")
local widget = require("widget")
local composer = require("composer")
local yesNoWindow = require("levelEditor.yesNoWindow")
local popUp = require("levelEditor.popUp")

---------------------------------------------------------------------------------
-- Class declaration
---------------------------------------------------------------------------------
local loadMenu = class("levelEditor.loadMenu")

---------------------------------------------------------------------------------
-- Local functions declaration
---------------------------------------------------------------------------------
local initSaveAlertWindow, openLevel, openButtonReleased, saveAlertNoBtnReleased,
	deleteButtonReleased, deleteLevel, deleteAlertNoBtnReleased, resetLevelsView
	
local initExportButton, exportButtonReleased, exportLevel

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local WIDTH = 150
local HEIGHT = 300

local OPEN_X, OPEN_Y = 0.25 * WIDTH, 0.85 * HEIGHT
local OPEN_DEFAULT_FILE = "gfx/loadMenu/openDefault.png"
local OPEN_OVER_FILE = "gfx/loadMenu/openOver.png"

local DELETE_X, DELETE_Y = 0.5 * WIDTH, 0.85 * HEIGHT
local DELETE_DEFAULT_FILE = "gfx/loadMenu/deleteDefault.png"
local DELETE_OVER_FILE = "gfx/loadMenu/deleteOver.png"

---------------------------------------------------------------------------------
-- Class constructor 
---------------------------------------------------------------------------------
function loadMenu:init(saveMenu, parentView, x, y)

	local view = display.newGroup( )
	view.x, view.y = x, y
	view.isVisible = false
	self.view = view

	local bg = display.newRect( view, 0, 0, WIDTH, HEIGHT )
	bg.anchorX, bg.anchorY = 0, 0
	bg:setFillColor( 0, 0.5 )

	self.saveAlertWindow = initSaveAlertWindow(saveMenu, self)
	self.deleteAlertWindow = initDeleteAlertWindow(self)
	self:initLevelsView()
	self:initButtonsView()

	-- Move alert windows to front
	self.saveAlertWindow:toFront( )
	self.deleteAlertWindow:toFront( )

	parentView:insert(view)
end

---------------------------------------------------------------------------------
-- Render a row of tableView for levels names
---------------------------------------------------------------------------------
local function onRowRender(event)

	local row = event.row
	local levelName = row.params.levelName

	local title = display.newText(row, levelName, 0, 0, "Helvetica", 16 )
	title:setTextColor( elColor.r, elColor.g, elColor.b )
	title.anchorX = 0
	title.anchorY = 0

	row.title = title

	row.levelName = levelName
end


---------------------------------------------------------------------------------
-- Choose current levelName and then perform actions with the level corresponding
-- to it 
---------------------------------------------------------------------------------
local function onRowTouch(event)

	if event.phase == "release" then

		local row = event.row 
		local resetLevelsViewMarkers = row.params.resetLevelsViewMarkers
		local levelsView = row.params.levelsView

		resetLevelsViewMarkers(levelsView)

		row.title:setFillColor(1)

		loadMenu.currentLevelName = row.levelName
	end
end


---------------------------------------------------------------------------------
-- Reset the color of all rows to default
---------------------------------------------------------------------------------
local function resetLevelsViewMarkers(levelsView)
	
	local nRows = levelsView:getNumRows( )

	for i = 1, nRows do

		local row = levelsView:getRowAtIndex( i )

		row.title:setTextColor( elColor.r, elColor.g, elColor.b )
	end
end

---------------------------------------------------------------------------------
-- Scroll view with buttons for each level name from levelsList file,
-- buttons are created using for loop by going through elements of the levels
-- table loaded by loadsave library
---------------------------------------------------------------------------------
function loadMenu:initLevelsView()

	local levels = loadsave.loadTable("levelsList") or {}
	
	local levelsView  = widget.newTableView {

	    left = 0,
	    top = 0,
	    width = WIDTH,
	    height = 0.75 * HEIGHT,
	    onRowRender = onRowRender,
	    onRowTouch = onRowTouch,
	    hideBackground = true,
	}
	self.view:insert(levelsView)

	-- Insert new level row
	levelsView:insertRow{

		rowColor = {default = {0, 0}, over = {0, 0}},
		params = {
			levelName = "new",
			resetLevelsViewMarkers = resetLevelsViewMarkers,
			levelsView = levelsView,
			loadMenu = self,
		}
	}

	for i = 1, #levels do

		local levelName = levels[i]

		levelsView:insertRow{

			rowColor = { default = {0, 0}, over = {0, 0}},
			params = {
				levelName = levelName,
				resetLevelsViewMarkers = resetLevelsViewMarkers,
				levelsView = levelsView,
				loadMenu = self,
			},

		}
	end

	self.levelsView = levelsView
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function loadMenu:updateLevelsView()
	
	self.levelsView:removeSelf( )
	self.levelsView = nil
	self:initLevelsView()
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function loadMenu:show()
	
	self.view.isVisible = true
	self:updateLevelsView()
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function loadMenu:hide()
	self.view.isVisible = false
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function loadMenu:initButtonsView()

	self:initOpenButton()
	self:initDeleteButton()
	initExportButton(self)
end

---------------------------------------------------------------------------------
-- Open button
-- Oppens new level 
---------------------------------------------------------------------------------
function loadMenu:initOpenButton()

	local button = widget.newButton{
		x = OPEN_X,
		y = OPEN_Y,
		defaultFile = OPEN_DEFAULT_FILE,
		overFile = OPEN_OVER_FILE,
		onRelease = openButtonReleased,
	}

	-- Params for listener, openLevel()
	button.params = {
		saveAlertWindow = self.saveAlertWindow,
		loadMenu = self
	}

	self.view:insert(button)
end

---------------------------------------------------------------------------------
-- Open level if button is pressed
---------------------------------------------------------------------------------
function openButtonReleased(event)
	
	-- Get params 
	local params = event.target.params

	local saveAlertWindow = params.saveAlertWindow
	local loadMenu = params.loadMenu

	-- If a level name is selected and button is pressed then show save alert
	if loadMenu.currentLevelName then

		saveAlertWindow.isVisible = true
		loadMenu.view.isVisible = false
	end
end



---------------------------------------------------------------------------------
-- Delete button 
---------------------------------------------------------------------------------
function loadMenu:initDeleteButton()

	local button = widget.newButton{
		x = DELETE_X,
		y = DELETE_Y,
		defaultFile = DELETE_DEFAULT_FILE,
		overFile = DELETE_OVER_FILE,
		onRelease = deleteButtonReleased,
	}

	-- Create params for the button
	button.params = {deleteAlertWindow = self.deleteAlertWindow, loadMenu = self}

	self.view:insert(button)
end

---------------------------------------------------------------------------------
-- Shows yes/no delete window
---------------------------------------------------------------------------------
function deleteButtonReleased(event)
	
	-- Get params
	local params = event.target.params

	local deleteAlertWindow = params.deleteAlertWindow
	local loadMenu = params.loadMenu

	-- If level is selected then show alert delete window
	if loadMenu.currentLevelName then
		deleteAlertWindow.isVisible = true
	end
end

---------------------------------------------------------------------------------
-- Create save alert window, the window is shown when open button is pressed
-- Yes: save menu is opened
-- No: open level
---------------------------------------------------------------------------------
function initSaveAlertWindow(saveMenu, loadMenu)

	local alertW = yesNoWindow.new{

		label = "save current level?",
		hide = true,

		yListenerT = {{saveMenu.show, saveMenu }},

		nListenerT = {{saveAlertNoBtnReleased, loadMenu}},
	}

	-- Hide after initialization
	alertW.isVisible = false

	return alertW
end

---------------------------------------------------------------------------------
-- Open level after no button of save alert window is pressed
---------------------------------------------------------------------------------
function saveAlertNoBtnReleased(loadMenu)

	print("saveAlertNoBtnReleased()")
	
	openLevel(loadMenu.currentLevelName)
end

---------------------------------------------------------------------------------
-- Open new depending on current selectet level
---------------------------------------------------------------------------------
function openLevel(levelName)

	-- Load level table from file
	local levelTable = loadsave.loadTable(levelName)

	local levelEditorParams

	-- Create params for the level editor
	if levelName ~= "new" then

		levelEditorParams = {params = {levelTable = levelTable}}
	end

	-- Go to reset scene, to reinitialize levelEditor with new params
	composer.gotoScene( "levelEditor.levelEditorReset", levelEditorParams )
end

---------------------------------------------------------------------------------
-- Create delete alert window, the window is shown when delete button is pressed
-- Yes: delete selected level
---------------------------------------------------------------------------------
function initDeleteAlertWindow(loadMenu)
	
	local alertW = yesNoWindow.new{
		label = "delete level?",
		hide = true,

		yListenerT = {
			{deleteAlertNoBtnReleased, loadMenu},
			{resetLevelsView, loadMenu},
		},
	}

	-- Hide after initialization
	alertW.isVisible = false

	return alertW
end


---------------------------------------------------------------------------------
-- Call delete level
---------------------------------------------------------------------------------
function deleteAlertNoBtnReleased(loadMenu)

	deleteLevel(loadMenu.currentLevelName)
end

---------------------------------------------------------------------------------
-- Remove current levels table view and create new
---------------------------------------------------------------------------------
function resetLevelsView(loadMenu)
	
	loadMenu.levelsView:removeSelf( )

	loadMenu:initLevelsView()
end

---------------------------------------------------------------------------------
-- Delete level from memory
---------------------------------------------------------------------------------
function deleteLevel(levelName)
	
	-- Remove level name from list of levels
	local levelsList = loadsave.loadTable("levelsList")

	-- Search for the name in the list
	for i = 1, #levelsList do

		-- If name found delete it from the list
		if levelsList[i] == levelName then

			table.remove(levelsList, i)
		end
	end

	-- Save updated table
	loadsave.saveTable(levelsList, "levelsList")

	-- Delete level file
	local result = os.remove( system.pathForFile(levelName, system.DocumentsDirectory) )

	if result then

		popUp.show(levelName.." deleted")
	end
end

---------------------------------------------------------------------------------
-- Button to export level
---------------------------------------------------------------------------------
function initExportButton(loadMenu)

	local X, Y = 0.75 * WIDTH, 0.85 * HEIGHT
	local DEFAULT_FILE = "gfx/loadMenu/exportDefault.png"
	local OVER_FILE = "gfx/loadMenu/exportOver.png"
	
	local button = widget.newButton{
		x = X,
		y = Y,
		defaultFile = DEFAULT_FILE,
		overFile = OVER_FILE,
		onRelease = exportButtonReleased,
	}

	-- Params for listener, openLevel()
	button.params = {
		loadMenu = loadMenu
	}

	loadMenu.view:insert(button)
	loadMenu.exportButton = button
end

---------------------------------------------------------------------------------
-- Export button listener
---------------------------------------------------------------------------------
function exportButtonReleased(event)
	
	-- Get params
	local params = event.target.params

	local levelName = params.loadMenu.currentLevelName

	-- if a level is selected
	if levelName then

		exportLevel(levelName)
	end
end

---------------------------------------------------------------------------------
-- Export level
---------------------------------------------------------------------------------
function exportLevel(levelName)

	-- Open level file 
	local file = io.open(system.pathForFile(levelName, system.DocumentsDirectory))
	
	local levelStr = file:read()

	file:close()

	local exportStr = "level name: "..levelName.."\nlevel table:\n"..levelStr

	print(exportStr)

	native.showPopup( "mail", {

			to = "kotbegemotoo@gmail.com",
			subject = "level: "..levelName,
			body = exportStr,
		})

	popUp.show(levelName.." exported")
end


return loadMenu