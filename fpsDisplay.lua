-- file: fpsDisplay.lua
-- Returns text object that displays current frame rate

local fpsDisplay = class("fpsDisplay")

local sGetTimer = system.getTimer
local mathFloor = math.floor

local function createView( )
	local view = display.newText( display.fps, 0, display.contentHeight - 20, native.systemFont, 15 )
	view:setFillColor( 0 )
	view.anchorX = 0

	return view
end

function fpsDisplay:init()

	self.view = createView()

	self.prevTime = 0

	Runtime:addEventListener( "enterFrame", self )
end

function fpsDisplay:enterFrame( )
	
	local view = self.view
	local prevTime = self.prevTime

	local currentTime = sGetTimer()

	view.text = mathFloor(1000 / (currentTime - prevTime))

	self.prevTime = currentTime
end


return fpsDisplay