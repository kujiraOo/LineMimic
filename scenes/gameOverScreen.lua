local composer = require( "composer" )
local scene = composer.newScene()

-- Imports
local lineColorManager = require("lineColorManager")
local playerDataManager = require("playerDataManager")
local widget = require("widget")


---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- Constants
local TXT_OFFSET = 30

-- Local functions
local function initText( sceneGroup, score, speed)
   local centerX, centerY = 0.5 * display.contentWidth, 0.5 * display.contentHeight
   local font = native.systemFont

   local gameOverText = display.newText( sceneGroup, "GAME OVER", centerX, centerY, font, 30 )

   local scoreText = "LINES: "..score.." BEST: "..playerDataManager.bestScore
   scoreText = display.newText(sceneGroup, scoreText, centerX, centerY + TXT_OFFSET, font, 15 )

   local speedText = "SPEED: "..speed.." BEST: "..playerDataManager.bestSpeed
   speedText = display.newText(sceneGroup, speedText, centerX, centerY + 2 * TXT_OFFSET, font, 15 )
end

local function initBackground( sceneGroup )
   -- Create background for the sceneGroup to enable tap on entire screen

   local rect = display.newRect(sceneGroup, 0.5 * display.contentWidth, 
                              0.5 * display.contentHeight, display.actualContentWidth,
                              display.actualContentHeight)
   rect:setFillColor( 0 )
   rect.alpha = 0.01
end

-- Create button with game over screen styling
local function newButton(label, listener )

   local button = widget.newButton {
      label = label,
      onRelease = listener,
      shape = "roundedRect",
      width = 150,
      height = 30,
      cornerRadius = 5,
      fillColor = { default = {1, 1, 1, 1}, over = {1, 1, 1, 1} },
      labelColor = {default = {1, 0.5, 0.5, 1}, over = {1, 0.5, 0.5, 1}},
   }

   return button 
end

-- Init buttons for game over screen
local function initButtons(scene)
   local restartButton = newButton("restart", function ( )
      if scene.canContinue then
         composer.removeScene( "scenes.gameScreen" )
         composer.removeScene( "scenes.gameOverScreen")
         composer.gotoScene( "scenes.gameScreen", {params = {config = scene.config}} )
      end
   end)
   restartButton.x = 0.5 * display.contentWidth
   restartButton.y = 0.5 * display.contentHeight + 100
   scene.view:insert(restartButton)

   local debugMenuButton = newButton("debug menu", function ( )
      if scene.canContinue then
         composer.removeScene( "scenes.gameScreen" )
         composer.removeScene( "scenes.gameOverScreen")
         composer.gotoScene( "scenes.debugMenuScreen" )
      end
   end)
   debugMenuButton.x = 0.5 * display.contentWidth
   debugMenuButton.y = 0.5 * display.contentHeight + 150
   scene.view:insert(debugMenuButton)
end


-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   self.config = event.params.config

   self.canContinue = false

   initBackground(sceneGroup)
   initText(sceneGroup, event.params.score, event.params.speed)

   initButtons(self)

   -- Wait for game over animation to be finished

   Runtime:addEventListener( "gameOverAnimationFinished", function(event) self.canContinue = true end )

   
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
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


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene