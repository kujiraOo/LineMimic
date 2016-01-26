-- File accelManager.lua

-- This class helps control drawManager's speed and acceleration

-- Imports

-- Class delcaration
local accelManager = class("accelManager")


-- Class construtor
function accelManager:init(level, completionSpeed)
	
	self.level = level

	self.isActive = true

	self.acc = 0 
	self.speedIncRate = 1
	self.completionSpeed = completionSpeed

	self.elsCounter = 0
end


function accelManager:onNextEl( )

	self.elsCounter = self.elsCounter + 1
	
	local isActive = self.isActive

	if isActive then

		local incRate = self.speedIncRate
		local elsCounter = self.elsCounter

		if elsCounter % incRate == 0 then

			self:updateSpeed()
			self:checkCompletionSpeed()
		end
	end
end

------------------------------------------------------------------------------------
-- Increase drawManager's speed
------------------------------------------------------------------------------------
function accelManager:updateSpeed( )
	
	local acc = self.acc

	self.level.drawManager.speed = self.level.drawManager.speed + acc

	if self.level.speedText then
		
		self.level.speedText.text = self.level.drawManager.speed
	end
end

------------------------------------------------------------------------------------
-- For levels where player has to reach certatin speed to complete the level
------------------------------------------------------------------------------------
function accelManager:checkCompletionSpeed( )

	local completionSpeed = self.completionSpeed
	local speed = self.level.drawManager.speed
	
	if completionSpeed and speed > completionSpeed then

		self.level.drawManager.isActive = false
		self.level:GUIonCompletion()
		self.level:complete()
	end
end


return accelManager