-- File scenes/gameOver.lua

local composer = require( "composer" )
local color = require("color")
local widget = require("widget")

local scene = composer.newScene()


---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

local function newButton( label )
   local button

    button = widget.newButton{
      label = label,
      id = label,
      width = 150,
      height = 30,
      left = 0.5 * display.contentWidth - 75,
      shape = "roundedRect",
      fillColor = { default = {0, 0, 0, 0.1}, over = {0, 0, 0, 0.1}},
      labelColor = { default = {1, 1, 1}, over = {1, 1, 1}},
   }

   return button
end

function scene:initBackground( )
   local ct = color.standard.unchecked

   local paint = {
      type = "gradient",
      color1 = { ct.r, ct.g, ct.b },
      color2 = { 0.7, 1, 0.7 },
      direction = "down"
   }
   
   local rect = display.newRect( self.view, 0.5 * display.contentWidth, 0.5 * display.contentHeight,
                     display.actualContentWidth, display.actualContentHeight )
   rect.fill = paint

end

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   self:initBackground()

   local img = display.newImageRect( sceneGroup, "gfx/sad.png", 64, 64 )
   img.x, img.y = 0.5 * display.contentWidth, 0.5 * display.contentHeight

   local text = display.newText( sceneGroup, "game over", 0.5 * display.contentWidth, 
                              0.5 * display.contentHeight, native.systemFont, 20 )

   text.y = 150

   local restartButton = newButton("restart")
   restartButton:addEventListener( "tap", self )
   restartButton.y = 300
   sceneGroup:insert(restartButton)

   local menuButton = newButton("menu")
   menuButton:addEventListener( "tap", self )
   menuButton.y = 350
   sceneGroup:insert(menuButton)

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

function scene:tap(event)

   local button = event.target

   if button.id == "restart" then

      self:restartLevel()

   elseif button.id == "menu" then

      composer.gotoScene("scenes.levelMenu", {effect = "slideDown"})

   end
end

function scene:restartLevel( )
   composer.gotoScene( "scenes.gameScreen", {effect = "slideDown", params = {restartLevel = true}} )
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
      Runtime:removeEventListener( "tap", tapListener )
      composer.removeScene("scenes.startScreen")
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