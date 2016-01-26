-- File: playerDataManager.lua

-- Save and retrieve information about hight scores etc

local playerDataManager = {}


function playerDataManager.load()
	local path = system.pathForFile( "save", system.DocumentsDirectory )
	local file = io.open(path)
	
	if file then
		playerDataManager.bestScore = tonumber(file:read()) or 0
		playerDataManager.bestSpeed = tonumber(file:read()) or 0
		file:close()
	else
		playerDataManager.bestScore = 0
		playerDataManager.bestSpeed = 0
	end
end


function playerDataManager.save()
	local path = system.pathForFile( "save", system.DocumentsDirectory )
	local file = io.open(path, "w")
	
	file:write(playerDataManager.bestScore.."\n")
	file:write(playerDataManager.bestSpeed)
	file:close()
end

return playerDataManager