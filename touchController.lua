-- File: touchController.lua

-- Gets input from user. It analyses swipe motions and converts them to UP DOWN LEFT RIGHT
-- directions. 
-- It also marks line that is to check as valid if user's input matches the dirction of the line. 

local touchController = class("touchController")

-- Constants 
local UP = 1
local DOWN = 2
local LEFT = 3
local RIGHT = 4


-- Private functions
local function calculateDirection(x1, y1, x2, y2)
	if math.abs(x2 - x1) > math.abs(y2 - y1) then -- direction is horizontal 
		if x2 - x1 > 0 then
			return RIGHT
		else
			return LEFT
		end
	else
		if y2 - y1 > 0 then 
			return DOWN
		else
			return UP
		end
	end
end


-- Public methods
function touchController:init(checkManager)
	self.checkManager = checkManager
	
	Runtime:addEventListener( "touch", self )
end

function touchController:touch( event )

	local checkManager = self.checkManager

	if ( event.phase == "began" ) then
        --code executed when the button is touched
        self.x1 = event.x
		self.y1 = event.y

		checkManager:checkTouchBeginEl(event.x, event.y)

    elseif ( event.phase == "ended" ) then
        --code executed when the touch lifts off the object
	    if self.x1 then
			self.x2 = event.x
			self.y2 = event.y
			
			local inputDir = calculateDirection(self.x1, self.y1, self.x2, self.y2)

			self.checkManager:checkTouchEndEl(inputDir, self.x1, self.y1, self.x2, self.y2)
		end
		
		self:reset()
    end
    
	return true
end

function touchController:reset()
	self.x1 = nil
	self.y1 = nil
	self.x2 = nil
	self.y2 = nil
end

function touchController:disable()
	Runtime:removeEventListener( "touch", self )
end

return touchController