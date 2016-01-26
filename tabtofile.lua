-- file:tabtofile.lua

-- This module provides function to save tables to file and
-- load table from files
-- The table files have specific format
-- key:value

local tabtofile = {}


-- Local functions
local function doesTableContainsEls( t )
	local i = 0 

	for k, v in pairs(t) do
		i = i + 1
	end

	if i > 0 then
		return true
	else 
		return false
	end
end

function tabtofile.save(t, fileName)
	local path = system.pathForFile( fileName, system.DocumentsDirectory )

	local s = ""

	for k, v in pairs(t) do
		s = s..k..":"..tostring(v).."\n"
	end

	print(s)

	local file = io.open( path, "w" )

	file:write( s )

	file:close()
end

function tabtofile.load( fileName )

	print ("tabtofile.load: start reading from file to rable")

	local t = {}

	local path = system.pathForFile( fileName, system.DocumentsDirectory )

	local file = io.open( path )

	if file then 
		for line in file:lines() do
			local k = line:match( "(.+):" )
			local v = line:match( ":(.+)" )

			if tonumber( v ) then
				v = tonumber(v)
			end

			if (v == "nil") then
				v = nil
			elseif (v == "true") then
				v = true
			elseif (v == "false") then
				v = false
			end

			t[k] = v
		end

		if doesTableContainsEls(t) then
			print ("tabtofile: table contatins following data")

			for k, v in pairs(t) do
				print(k, v)
			end

			return t
		else
			print("tabtofile.load: table doesn't containt any data")
		end
	else 
		print("tabtofile.load: no file")
		return nil
	end
end

return tabtofile