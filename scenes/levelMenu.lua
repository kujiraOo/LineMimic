local composer = require( "composer" )
local widget = require ("widget")
local color = require("color")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

-- Local constants 

local function newButton( label )
   local button

    button = widget.newButton{
      label = label,
      id = label,
      width = 50,
      height = 50,
      left = 0.5 * display.contentWidth - 75,
      shape = "roundedRect",
      fillColor = { default = {0, 0, 0, 0.1}, over = {0, 0, 0, 0.1}},
      labelColor = { default = {1, 1, 1}, over = {1, 1, 1}},
   }

   return button
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    self:initBackground()

    self:initButtons()

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

function scene:initBackground( )
   local ct = color.standard.checked

   local paint = {
      type = "gradient",
      color1 = { ct.r, ct.g, ct.b },
      color2 = { 0.6, 0.8, 1 },
      direction = "down"
   }
   
   local rect = display.newRect( self.view, 0.5 * display.contentWidth, 0.5 * display.contentHeight,
                     display.actualContentWidth, display.actualContentHeight )
   rect.fill = paint
end

function scene:initButtons(  )

    local buttonSpacing = 0.25 * display.contentWidth 
    
    local y = 100

    for i = 5, 10 do

        local button = newButton(tostring(i))
        button:addEventListener( "tap", self )


        button.x = ((i - 5) % 3 + 1) * buttonSpacing
        button.y = y
        self.view:insert(button)

        if (i - 4) % 3 == 0 then

          y = y + 60
        end
    end
end

function scene:tap(event )

    local buttonId = event.target.id
    
    composer.gotoScene( "scenes.gameScreen", {
        effect = "slideDown",
        params = {
            levelFromMenu = true,
            levelN = buttonId
        }
    })
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