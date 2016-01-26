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
   local ct = color.checked[1]

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

   print("creating dev start menu screen")

   local sceneGroup = self.view

   self:initBackground()

   self:initEditorButton()
   self:initLevelMenuButton()
end

function scene:tap(event)

   local button = event.target

   if button.id == "editor" then

      composer.gotoScene("levelEditor.levelEditor", {effect = "slideDown"})

   elseif button.id == "menu" then

      composer.gotoScene("scenes.levelMenu", {effect = "slideDown"})
   end
end


-- "scene:show()"
function scene:show( event )

   print("showing dev start menu screen")

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

------------------------------------------------------------------------------------
-- Create level menu button
------------------------------------------------------------------------------------
function scene:initLevelMenuButton( )

   local button = newButton("menu")
   button:addEventListener( "tap", self )
   button.y = 300
   self.view:insert(button)

   self.levelMenuButton = button
end

------------------------------------------------------------------------------------
-- Create editor button
------------------------------------------------------------------------------------
function scene:initEditorButton( )
   
   local button = newButton("editor")
   button:addEventListener( "tap", self )
   button.y = 250
   self.view:insert(button)

   self.editorButton = button
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