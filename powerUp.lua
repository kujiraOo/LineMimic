-- File: powerUp.lua

-- Class declaration
local powerUp = {}

-- Local constants
local RADIUS = 35


-- Local functions
local function onMoveToComplete( powerUp )

	powerUp:removeSelf( )
	powerUp = nil
end


local function initTransition(powerUp)
	
	local dir = powerUp.dir

	local x1, y1 = powerUp.x, powerUp.y
	local x2, y2

	-- Move to the bottom edge of the screen
	if dir == "down" then

		x2 = x1
		y2 = display.actualContentHeight + 0.5 * RADIUS

	-- Move to the left edge of the screen
	elseif dir == "left" then

		x2 = -0.5 * RADIUS 
		y2 = y1

	-- Move to the right edge of the screen
	elseif dir == "right" then

		x2 = display.actualContentWidth + 0.5 * RADIUS
		y2 = y1
	end

	local params = {
		x = x2,
		y = y2,
		time = 3000,
		onComplete = onMoveToComplete,
	}

	transition.moveTo( powerUp, params )
end

local function onTouch( event )
	local powerUp = event.target
	local kind = powerUp.kind
	local phase = event.phase

	if phase == "began" then

		Runtime:dispatchEvent( {name = "powerUpCollected", kind = kind} )

		transition.cancel( powerUp )
		powerUp:removeSelf( )
		powerUp = nil

		return true
	end
end

local function initTouch( powerUp )
	powerUp:addEventListener( "touch", onTouch )
end


-- Class constructor
function powerUp.new(kind, group, x, y, dir, powerUpRad)

	local powerUp = display.newCircle( group, x, y, powerUpRad )
	powerUp.alpha = 0.7

	powerUp.lineManager = lineManager
	powerUp.kind = kind
	powerUp.x = x
	powerUp.y = y
	powerUp.dir = dir

	if kind == "speedDown" then
		powerUp:setFillColor(0, 1, 1)
	elseif kind == "freeze" then
		powerUp:setFillColor(0, 0, 1)
	elseif kind == "fill" then
		powerUp:setFillColor(0, 1, 0)
	end

	initTransition(powerUp)

	initTouch(powerUp)

	return powerUp
end

return powerUp