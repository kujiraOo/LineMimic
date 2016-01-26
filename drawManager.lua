------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local color = require("color")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local drawManager = class("drawManager")

------------------------------------------------------------------------------------
-- Save level 
-- Require pattern necessary for level
-- Draw manager always starts from behaviour 1
------------------------------------------------------------------------------------
-- Set first behaviour
function drawManager:init(level)

	self.level = level
	self.behaviours = level.behaviours

	self.isActive = true
	
	self:requirePatterns()

	self.behaviourId = 1
	self.speed = 1

	self:setNextBehaviour()
end

------------------------------------------------------------------------------------
-- Require patterns for level's behaviours
-- Level behaviour indecies:
------------------------------------------------------------------------------------
function drawManager:requirePatterns( )

	local behaviours = self.level.behaviours
	local patternClasses = {}
	
	for i = 1, #behaviours do

		local patternName = behaviours[i]["pattern"]

		patternClasses[patternName] = require("pattern."..patternName)
	end

	self.patternClasses = patternClasses
end

------------------------------------------------------------------------------------
-- Set behaviour of the drawManager
-- Behaviour is an instance of a pattern with specified params
-- Pattern also needs an view to place elements in
-- levelElView is passed to pattern 
-- Other params are accessed from level's behaviors table
------------------------------------------------------------------------------------
function drawManager:setNextBehaviour( )
	
	local behaviour = self.behaviours[self.behaviourId]
	local currentPatternClass = self.patternClasses[behaviour.pattern]
	local patternParams = behaviour.params
	local levelElView = self.level.elView

	if behaviour.speed then

		self.speed = behaviour.speed
	end

	if behaviour.acc then

		self.level.accelManager.acc = behaviour.acc
	end

	print("acceleration for next pattern: ", self.level.accelManager.acc)
	
	self.currentPattern = currentPatternClass:new(patternParams, levelElView)

	print("drawManager: ", self, "\n next behaviour, pattern: ", self.currentPattern.name)
end

------------------------------------------------------------------------------------
-- Create graphic element, add it to screen, regigester it in
-- check and alpha managers
------------------------------------------------------------------------------------
function drawManager:nextEl( )

	--print("drawManager: ", self, "\n trying to add next element, pattern: ", self.currentPattern)
	
	if self.isActive then
		
		local pattern = self.currentPattern
		local speed = self.speed

		local el = pattern:nextEl(speed)

		el:setColor(color.standard.unchecked)
		el:setOnCompleteAction(self.onElComplete, self)

		self.level.checkManager:addElement(el)
		self.level.alphaManager:addElement(el)

		local accelManager = self.level.accelManager

		if accelManager then

			accelManager:onNextEl()
		end

		self.lastEl = el

		--print("draw manager speed", self.speed)
	end
end

------------------------------------------------------------------------------------
-- This function is called when current element
-- has finished its drawing animation
------------------------------------------------------------------------------------
function drawManager:onElComplete( )

	if not self.isDestroyed then
	
		local pattern = self.currentPattern

		if pattern.isComplete then

			self:onPatternComplete()
		else

			self:nextEl()
		end
	end
end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function drawManager:onPatternComplete( )
	
	self.behaviourId = self.behaviourId + 1

	local id = self.behaviourId
	local numBehaviours = #self.behaviours

	if id > numBehaviours then

		self.level:complete()

	else

		self:setNextBehaviour()
		self:nextEl()

	end
end


------------------------------------------------------------------------------------
-- Cancel all transitions and animatedLineSegments
------------------------------------------------------------------------------------
function drawManager:destroy( )

	self.isDestroyed = true

	transition.cancel( )
	Runtime:dispatchEvent( {name = "drawManagerDestroyed"} )
end

return drawManager