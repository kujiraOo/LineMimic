---------------------------------------------------------------------------------
-- Insctructions about how to draw shapes for the game 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local FILLED = "filled"
local LINE = "line"

---------------------------------------------------------------------------------
-- Cache functions
---------------------------------------------------------------------------------
local PI = math.pi
local cos = math.cos
local sin = math.sin

local shape = {}

------------------------------------------------------------------------------------
-- Draw triangle
------------------------------------------------------------------------------------
function shape.triangle(x, y, verts)
	
	return display.newPolygon(x, y, verts )
end

------------------------------------------------------------------------------------
-- Draw circle segment using display.newPolygon function
------------------------------------------------------------------------------------
function shape.circleSegment(view, x, y, theta, radius)

	local vertices = {0, 0}

	local numVerts = 0.5 * theta

	local delta = theta / numVerts / 180 * PI
	local gamma = 0

	for i = 0, numVerts do

		local x = cos(gamma) * radius
		local y = sin(gamma) * radius

		gamma = gamma + delta

		vertices[3 + 2 * i] = x
		vertices[4 + 2 * i] = y
	end

	return display.newPolygon( view, x, y, vertices )
end

---------------------------------------------------------------------------------
-- Draw flower shape
---------------------------------------------------------------------------------
function shape.flower()

	local MIDDLE_R = 45
	local PETAL_R = 25
	local N_PETALS = 5
	local PETAL_DIST = 75
	local ANGLE_STEP = 2 * PI / N_PETALS

	local group = display.newGroup( )

	local middle = display.newCircle( group, 0, 0, MIDDLE_R )
	middle.fillType = FILLED
	
	local angle = 0

	for i = 1, N_PETALS do

		local x = cos(angle) * 75
		local y = sin(angle) * 75

		local petal = display.newCircle( group, x, y, PETAL_R)
		petal.fillType = FILLED

		angle = angle + ANGLE_STEP
	end

	return group
end

---------------------------------------------------------------------------------
-- Draw reaction bar shape
---------------------------------------------------------------------------------
function shape.reactionBar()
	
	local H = 8
	local W = 150
	local STROKE_W = 2
	local R = 8
	local CH_Z = 20
	
	local group = display.newGroup( )

	local barOutline = display.newRect(group, 0, 0, W, H )
	barOutline.strokeWidth = STROKE_W

	local checkZoneL = display.newLine(group, -0.5 * CH_Z, -0.5 * H, -0.5 * CH_Z, 0.5 * H)
	checkZoneL.strokeWidth = STROKE_W
	checkZoneL.fillType = LINE

	local checkZoneR = display.newLine(group, 0.5 * CH_Z, -0.5 * H, 0.5 * CH_Z, 0.5 * H)
	checkZoneR.strokeWidth = STROKE_W
	checkZoneR.fillType = LINE

	group.barOutline = barOutline
	group.checkZoneL = checkZoneL
	group.checkZoneR = checkZoneR

	return group
end

function shape.icecream()

	print("creating icecream")

	local R = 20
	local W = 40
	local H = 60
	local OFFSET = 30
	
	local group = display.newGroup( )

	local head = display.newCircle(group, 0, 0, R )
	head.fillType = FILLED

	local x1 = -0.5 * W
	local y1 = R + OFFSET
	local x2 = 0.5 * W
	local y2 = y1
	local x3 = 0
	local y3 = y1 + H

	local verts = {x1, y1, x2, y2, x3, y3}

	local triangle = shape.triangle(x1, y1, verts)
	triangle.fillType = FILLED

	triangle.anchorX = 0
	triangle.anchorY = 0

	group:insert(triangle)

	group.head = head

	return group
end

function shape.wheel()

	local circleSegments = {}

	local group = display.newGroup( )

	local R = 100 -- radius of the wheel
	local THETA = 65 -- angle of the segment's arc in degrees
	local DELTA = 72 -- angle of segment arc + spacing arc

	for i = 0, 4 do

		local segment = shape.circleSegment(group, 0, 0, THETA, R)

		segment.fillType = FILLED

		segment.anchorX = 0
		segment.anchorY = 0
		segment.rotation = i * DELTA

		circleSegments[#circleSegments + 1] = segment
	end

	return group
end


---------------------------------------------------------------------------------
-- Set color of the shape
---------------------------------------------------------------------------------
function shape.setColor(shape, color)

	for i = 1, shape.numChildren do

		local o = shape[i]

		

		if o.fillType == LINE or o.fillType ~= FILLED then

			o:setStrokeColor( color.r, color.g, color.b )
		elseif o.fillType == FILLED then

			o:setFillColor(color.r, color.g, color.b)

			print("setting color of shape element")
		end
	end
end

return shape