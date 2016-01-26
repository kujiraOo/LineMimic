-- Color table contains colors for different color schemes

local function rgbToTab( r, g, b )
	local colorTable = {
		r = r / 255,
		g = g / 255,
		b = b / 255,
	}

	return colorTable
end

local color = {

	unchecked = {
		rgbToTab(255, 82, 100),
		rgbToTab(253, 251, 1),
		rgbToTab(221, 95,	255),
		rgbToTab(156, 152, 155),
		},

	checked = {
		rgbToTab(0, 221, 0),
		rgbToTab(0,	151, 255),
		rgbToTab(255, 137, 35),
		rgbToTab(0,	252, 251),
		},

	newAlpha = 1,
	alpha1 = 0.6,
	alpha2 = 0.3,
	inactiveAlpha = 0.1,
}

return color