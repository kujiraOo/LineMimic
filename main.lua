-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Imports
require("30logglobal")

local composer = require("composer")
local playerDataManager = require("playerDataManager")
local fpsDisplay = require("fpsDisplay")

-- Local functions
local function clearConfigFile( )
	local path = system.pathForFile( "config", system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:close()
end

local function clearSaveDataFile( )
	local path = system.pathForFile( "save", system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:close()
end

-- Adjust color, go to scene

math.randomseed(os.time())

display.setDefault( "background", 1 )

local fps = fpsDisplay:new()

composer.gotoScene( "scenes.devVerStartMenu" )

print(display.imageSuffix)

