------------------------------------------------------------------------------------
-- File level/testLevel.lua
--
-- This level pictures windmills on the background consisting from rect patterns
-- and reaction bars
-- Icecreams representing people in front
-- Flower in front
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------------------
local level = require ("level.level")

------------------------------------------------------------------------------------
-- Class declaration
------------------------------------------------------------------------------------
local testLevel = level:extend("testLevel")

------------------------------------------------------------------------------------
-- Class constructor
------------------------------------------------------------------------------------
function testLevel:init(behaviours)

	self.behaviours = behaviours

	self.super.init(self)

	self.maxNumEls = 8
end

return testLevel