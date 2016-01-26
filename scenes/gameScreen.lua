local composer = require( "composer" )
local scene = composer.newScene()

-- Imports
local widget = require("widget")
local testLevel = require("level.testLevel")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- Local functions
function scene:initPauseButton()

   local button

   button = widget.newButton{
      label = "pause",
      width = 70,
      height = 30,
      top = 0.5 * (display.contentHeight - display.actualContentHeight) + 10,
      left = display.actualContentWidth - 80,
      shape = "roundedRect",
      strokeColor = { default = {0}, over = {0.2, 0.2, 0.2}},
      fillColor = {default = {1, 1, 1, 0.2}, over = {1, 1, 1}},
      labelColor = { default = {0}, over = {0.2, 0.2, 0.2}},
   }

   button:addEventListener( "touch", self )

   Runtime:addEventListener( "gameResumed", function ( event )
      button.alpha = 1
   end )

   self.view:insert(button)

   Runtime:addEventListener( "levelComplete", self )

   self.pauseButton = button
end

function scene:levelComplete( )
   
   self.pauseButton.alpha = 0
end

-- "scene:create()"
function scene:create( event )

   print("creating game screen")

   local sceneGroup = self.view

   self:initPauseButton()

   Runtime:addEventListener( "system", self )

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

function scene:system( event )

   if event.type == "applicationSuspend" then
      self:pause(event)
   end
end

function scene:touch(event)

   if event.phase == "began" then
      scene:pause()
   end
end

-- Pause scene
function scene:pause()

   transition.pause( )
   composer.showOverlay( "scenes.pauseScreen" , {isModal = true, params = {level = self.level, pauseButton = self.pauseButton}})
   Runtime:dispatchEvent( {name = "gamePaused"})
   self.pauseButton.alpha = 0.5
end


-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then

      if event.params then

         local restartLevel = event.params.restartLevel
         local nextLevel = event.params.nextLevel
         local levelFromMenu = event.params.levelFromMenu
         local levelFromEditor = event.params.levelFromEditor

         if restartLevel then 

            self.level:reset()

         elseif nextLevel then

            self:nextLevel()

         elseif levelFromMenu then

            self:levelFromMenu(event.params.levelN)

         elseif levelFromEditor then

            self:levelFromEditor(event.params.behaviours)

         end
      end

      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then

      self.level:start()

      self.pauseButton.alpha = 1
      self.pauseButton:toFront()
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- Change level
function scene:nextLevel( )

   local levelN = self.level.id + 1

   self.level.view:removeSelf() 

   self:initLevel(levelN)
end

-- Init level from menu
function scene:levelFromMenu(levelN)

   if self.level then 
      self.level.view:removeSelf( )
   end
   
   self:initLevel(levelN)
end

function scene:levelFromEditor(behaviours)
   
   local level = testLevel:new(behaviours)

   self.view:insert(level.view)
   self.level = level
end

function scene:initLevel(levelN)
      
   local levelClass = require("level.level"..levelN)
   local level = levelClass:new()
   self.view:insert(level.view)
   self.level = level
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

      self.level:destroy()

      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   self = nil

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