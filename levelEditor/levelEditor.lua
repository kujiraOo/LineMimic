---------------------------------------------------------------------------------
-- Level editor scene
---------------------------------------------------------------------------------

local composer = require( "composer" )
local mainMenu = require("levelEditor.mainMenu")
local level = require("levelEditor.level")
local addPatternMenu = require("levelEditor.addPatternMenu")
local patternMenu = require("levelEditor.patternMenu")
local levelLoader = require("levelEditor.levelLoader")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local elColor = {r = 0.6, g = 0.9, b = 1}

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local params = event.params

    self:initState()
    self:initMainMenu()
    self:initPatternMenu()
    self:initAddPatternMenu()
    self:initLevel(params)
    self:initPatternNameBar()
end

---------------------------------------------------------------------------------
-- Init level editor's state 
---------------------------------------------------------------------------------
function scene:initState( )
    
    self.controlMode = "draw" --"/select/order"
    self.defaultSize = 50
end

---------------------------------------------------------------------------------
-- Init main menu
---------------------------------------------------------------------------------
function scene:initMainMenu( )

    local view = self.view
    local mainMenu = mainMenu:new(self)

    view:insert(mainMenu.view)
    self.mainMenu = mainMenu
end

---------------------------------------------------------------------------------
-- Init new level
---------------------------------------------------------------------------------
function scene:initLevel(params)

    local levelTable

    local lvl = level:new(self) 

    if params then 
        levelTable = params.levelTable
    end

    self.view:insert(lvl.view)
    self.view:insert(lvl.editGUIView)
    self.level = lvl

    if levelTable then

        levelLoader.load(self, levelTable)
    end

    lvl.editGUIView:toBack( )
    lvl.view:toBack( )
end


---------------------------------------------------------------------------------
-- Add pattern menu
---------------------------------------------------------------------------------
function scene:initAddPatternMenu( )
    
    local menu = addPatternMenu:new(self)

    self.view:insert(menu.view)
    self.addPatternMenu = menu
end

---------------------------------------------------------------------------------
-- Pattern menu
---------------------------------------------------------------------------------
function scene:initPatternMenu( )
    
    local menu = patternMenu:new(self)

    self.view:insert(menu.view)
    self.patternMenu = menu
end

---------------------------------------------------------------------------------
-- Bar on top of the screen that indicates of currently active pattern
---------------------------------------------------------------------------------
function scene:initPatternNameBar( )

    local view = self.view
    local width = 120
    local height = 30

    local group = display.newGroup()
    group.x = 0.5 * display.contentWidth
    group.y = 0.5 * (display.contentHeight - display.actualContentHeight + height)
    view:insert(group)

    local bg = display.newRect( group, 0, 0, width, height )
    bg:setFillColor( 0, 0.5 )

    local text = display.newText( group, "no pattern", 0, 0, "Helvetica", 15)
    text:setTextColor( elColor.r, elColor.g, elColor.b )
    self.patternNameText = text
end

---------------------------------------------------------------------------------
-- Set pattern name bar
---------------------------------------------------------------------------------
function scene:setPatternNameBarText(text)
    
    self.patternNameText.text = text
end

---------------------------------------------------------------------------------
-- Hide all menus
---------------------------------------------------------------------------------
function scene:hideMenus()

    self.patternMenu:hide()
    self.mainMenu.view.isVisible = false
    self.addPatternMenu.view.isVisible = false
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        Runtime:addEventListener( "touch", self.level )
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        Runtime:removeEventListener( "touch", self.level )

        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene