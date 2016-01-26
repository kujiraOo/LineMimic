-- Imports
local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

-- Local functions 
local function initBackground( sceneGroup )
   -- Create background for the sceneGroup to enable tap on entire screen

   local rect = display.newRect(sceneGroup, 0.5 * display.contentWidth, 
                              0.5 * display.contentHeight, display.actualContentWidth,
                              display.actualContentHeight)
   rect:setFillColor( 0 )
   rect.alpha = 0.6
end

local function newButton( label )
   local button

    button = widget.newButton{
      label = label,
      id = label,
      width = 150,
      height = 30,
      left = 0.5 * display.contentWidth - 75,
      shape = "roundedRect",
      fillColor = { default = {0.95}, over = {0.8}},
      labelColor = { default = {0, 0, 0, 0.6}, over = {0, 0, 0, 0.6}},
   }

   return button
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    self.level = event.params.level
    self.pauseButton = event.params.pauseButton

    initBackground(sceneGroup)

    local text = display.newText( sceneGroup, "PAUSE", 0.5 * display.contentWidth, 100, nil, 20 )
 
    local resumeButton = newButton("resume")
    resumeButton:addEventListener( "tap", self )
    resumeButton.y = 150
    sceneGroup:insert(resumeButton)

    local restartButton = newButton("restart")
    restartButton:addEventListener( "tap", self )
    restartButton.y = 200
    scene.view:insert(restartButton)

    local menuButton = newButton("menu")
    menuButton:addEventListener( "tap", self )
    menuButton.y = 250
    scene.view:insert(menuButton)

    --[[local debugMenuButton = newButton("debug menu", function ( )
        composer.removeScene( "scenes.gameScreen" )
        composer.removeScene( "scenes.pauseScreen")
        composer.gotoScene( "scenes.debugMenuScreen" )
        display.setDefault( "background", 1 )
    end)
    debugMenuButton.y = 250
    scene.view:insert(debugMenuButton)]]

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

function scene:tap(event)

    print(event.target.id)

    local button = event.target

    if button.id == "resume" then

        transition.resume()
        composer.hideOverlay( "scenes.pauseScreen" )
        Runtime:dispatchEvent( {name = "gameResumed"})

    elseif button.id == "restart" then

        composer.hideOverlay( "scenes.pauseScreen")
        self.pauseButton.alpha = 1
        self.level:reset()
        self.level:start()

    elseif button.id == "menu" then

        --composer.hideOverlay( "scenes.pauseScreen")
        composer.gotoScene( "scenes.levelMenu" )

    end
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
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