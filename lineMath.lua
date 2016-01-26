local lineMath = {}

---------------------------------------------------------------------------------
-- Cache functions
---------------------------------------------------------------------------------
local abs = math.abs

---------------------------------------------------------------------------------
-- Local constants
---------------------------------------------------------------------------------
local up = 1
local down = 2
local left = 3
local right = 4
local halfWidth = 2

---------------------------------------------------------------------------------
-- Public constants
---------------------------------------------------------------------------------
lineMath.up = up
lineMath.down = down
lineMath.left = left
lineMath.right = right

---------------------------------------------------------------------------------
-- Calculate length
---------------------------------------------------------------------------------
function lineMath.calcLen(x1, y1, x2, y2)
	
	local dx = abs(x2 - x1)
	local dy = abs(y2 - y1)

	if dx > dy then

		return dx

	elseif dy > dx then

		return dy
	end
end

---------------------------------------------------------------------------------
-- Calc dir
---------------------------------------------------------------------------------
function lineMath.calcDir(x1, y1, x2, y2)
	
	local dx = abs(x2 - x1)
	local dy = abs(y2 - y1)

	if dx > dy then

		if x2 > x1 then

			return right

		elseif x2 < x1 then

			return left
		end

	elseif dy >dx then

		if y2 > y1 then

			return down

		elseif y2 < y1 then

			return up
		end
	end
end

---------------------------------------------------------------------------------
-- Calc final point 
-- The line must be paralles to x or y axis
---------------------------------------------------------------------------------
function lineMath.calcFinalPoint(x1, y1, x2, y2 )
	
	local dx = abs(x2 - x1)
	local dy = abs(y2 - y1)

	if dx > dy then

		return x2, y1

	else 

		return x1, y2
	end
end

---------------------------------------------------------------------------------
-- Adjust start point, to provide proper connection
---------------------------------------------------------------------------------
function lineMath.adjustStartPoint(x1, y1, x2, y2, lastDir)

	local curDir = lineMath.calcDir(x1, y1, x2, y2)
	
	if lastDir == up or lastDir == down then

		if curDir == left then 

			x1 = x1 - halfWidth

		elseif curDir == right then

			x1 = x1 + halfWidth

		end

	elseif lastDir == left or lastDir == right then

		if curDir == up then 

			y1 = y1 - halfWidth

		elseif curDir == down then

			y1 = y1 + halfWidth

		end
	end

	if lastDir == up then

		y1 = y1 + halfWidth

	elseif lastDir == down then

		y1 = y1 - halfWidth

	elseif lastDir == left then

		x1 = x1 + halfWidth

	elseif lastDir == right then

		x1 = x1 - halfWidth
	end

	return x1, y1
end

return lineMath