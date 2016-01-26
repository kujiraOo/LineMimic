---------------------------------------------------------------------------------
-- This module creates a level using a level table and a level object
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Imports
---------------------------------------------------------------------------------
local connectedLinePattern = require("levelEditor.pattern.connectedLine")
local separatedLinePattern = require("levelEditor.pattern.separatedLine")
local touchElementPattern = require("levelEditor.pattern.touchElement")

local levelLoader = {}


---------------------------------------------------------------------------------
-- Local functions declaration
---------------------------------------------------------------------------------
local loadPatterns, loadPattern, loadConnectedLine, loadSeparatedLine, 
	loadTouchEl

---------------------------------------------------------------------------------
-- Load function goes through all patterns from level table end
---------------------------------------------------------------------------------
function levelLoader.load(levelEditor, levelTable)

	local level = levelEditor.level

	print("number of elements in the table being loaded", #levelTable.patterns)

	loadPatterns(level, levelTable, levelEditor)

	return level
end


---------------------------------------------------------------------------------
-- Load all patterns and add them to level
---------------------------------------------------------------------------------
function loadPatterns(level, levelTable, levelEditor)

	local patterns = levelTable.patterns

	local patternMenu = levelEditor.patternMenu
	
	for i = 1, #patterns do

		local patternTable = patterns[i]

		pattern = loadPattern(patternTable, levelEditor)

		level:addPattern(pattern)
		patternMenu:addPatternButton(pattern)

	end
end

---------------------------------------------------------------------------------
-- Init pattern object and return it
---------------------------------------------------------------------------------
function loadPattern(patternTable, levelEditor)

	local pattern 

	print ("loadPattern func: pattern type", patternTable.patternType)

	if patternTable.patternType == "connectedLine" then

		pattern = connectedLinePattern:new(levelEditor)

	elseif patternTable.patternType == "separatedLine" then

		pattern = separatedLinePattern:new(levelEditor)

	elseif patternTable.patternType == "touchElement" then

		pattern = touchElementPattern:new(levelEditor, patternTable.elType)
	end

	pattern:loadFromTable(patternTable)

	return pattern
end


return levelLoader