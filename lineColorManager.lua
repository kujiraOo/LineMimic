-- File: lineColorManager.lua
-- This file contains table with colors for the line

local function color( r, g, b )
	local colorTable = {
		R = r / 255,
		G = g / 255,
		B = b / 255,
	}

	return colorTable
end

local lineColorManager = {
	UNCHECKED_LINE_COLOR = color(255, 82, 100),
    CHECKED_LINE_COLOR = color(0, 221, 0),

	NEW_LINE_ALPHA = 1,
	LINE_ALPHA1 = 0.6,
	LINE_ALPHA2 = 0.3,
	INACTIVE_LINE_ALPHA = 0.1,
}


return lineColorManager