
------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local animatedLineSegment = class("animatedLineSegment")

------------------------------------------------------------------------------------
-- Local constants
------------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4

local width = 4

-- Public methods
function animatedLineSegment:init(parentView, x, y, dir, length, speed)

	self.width = width
	self.isPaused = false
	self.currentLength = 0
	self.checkType = "touchEnd"

	self.parent, self.x, self.y, self.dir, self.maxLength, self.speed = parentView, x, y, dir, length, speed

	self.container = display.newGroup()
	self.parent:insert(self.container)

	Runtime:addEventListener( "enterFrame", self )
	Runtime:addEventListener( "gamePaused", self )
	Runtime:addEventListener( "gameResumed", self )
	Runtime:addEventListener( "drawManagerDestroyed", self )
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function animatedLineSegment:enterFrame()

	if not self.isPaused then

		self:updateLength()
		self:checkIfComplete()
		self:redraw()
	end
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function animatedLineSegment:gamePaused( )
	self.isPaused = true
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function animatedLineSegment:gameResumed( )
	self.isPaused = false
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function animatedLineSegment:drawManagerDestroyed( )

	--print(self, "\ndrawManagerDestroyed")
	self:removeListeners()
end

function animatedLineSegment:removeListeners( )
	Runtime:removeEventListener( "enterFrame", self )
	Runtime:removeEventListener( "gamePaused", self )
	Runtime:removeEventListener( "gameResumed", self )
	Runtime:removeEventListener( "drawManagerDestroyed", self )
end

------------------------------------------------------------------------------------
-- Update line's length on enter frame
------------------------------------------------------------------------------------
function animatedLineSegment:updateLength( )
	
	local speed = self.speed
		
	self.currentLength = self.currentLength + speed
end

------------------------------------------------------------------------------------
-- Check line completion
------------------------------------------------------------------------------------
function animatedLineSegment:checkIfComplete( )

	local currentLength = self.currentLength
	local maxLength = self.maxLength

	if currentLength > maxLength then

		self.currentLength = maxLength

		if self.foo then
			self.foo(self.arg)
		end

		self:removeListeners()
	end
end



------------------------------------------------------------------------------------
-- Redraw line with new length, color or alpha
------------------------------------------------------------------------------------
function animatedLineSegment:redraw( )

	local x1, y1 = self.x, self.y

	local x2, y2 = self:calcEndPoint()

	if self.line then self.line:removeSelf( ) end

	self.line = display.newLine(self.container, x1, y1, x2, y2)

	self.line.strokeWidth = self.width
	self.line:setStrokeColor( self.color.r, self.color.g, self.color.b )
	self.line.alpha = self.alpha
end

------------------------------------------------------------------------------------
-- Calculate segments's graphics object's end point based on its current length
-- and direction
------------------------------------------------------------------------------------
function animatedLineSegment:calcEndPoint( )

	local dir = self.dir
	local x, y = self.x, self.y
	local currentLength = self.currentLength

	if dir == up then

		return x, y - currentLength
	elseif dir == down then

		return x, y + currentLength
	elseif dir == left then
		
		return x - currentLength, y
	elseif dir == right then

		return x + currentLength, y
	end
end


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function animatedLineSegment:setOnCompleteAction( foo, arg)

	--print(self, "\nset on complete action", foo, arg)

	self.foo = foo
	self.arg = arg
end

------------------------------------------------------------------------------------
-- Set segment's alpha
------------------------------------------------------------------------------------
function animatedLineSegment:setAlpha( alpha )
	self.alpha = alpha
	self:redraw()
end

------------------------------------------------------------------------------------
-- Set segment's alpha
-- Color is table - {r = _, g = _, b = _}
------------------------------------------------------------------------------------
function animatedLineSegment:setColor( color )
	self.color = color
	self:redraw()
end

return animatedLineSegment