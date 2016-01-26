-- File directionPattern.pattern

-- Class declaration
local pattern = class("pattern")

-- Local constants
local up = 1
local down = 2
local left = 3
local right = 4


-- Parent class for all direction patterns

-- Calculate line's starting point
function pattern:calcStartPoint( dir )

	local lastLine = self.lineManager.lastLine

	if lastLine then

		local x1, y1 = lastLine.x2, lastLine.y2
		local lineWidth = lastLine.width

		if lastLine.dir == up then -- to avoid line start and end points intersection
			y1 = y1 + 0.5 * lineWidth
		elseif lastLine.dir == down then
			y1 = y1 - 0.5 * lineWidth
		elseif lastLine.dir == left then
			x1 = x1 + 0.5 * lineWidth
		elseif lastLine.dir == right then
			x1 = x1 - 0.5 * lineWidth
		end

		if lastLine.dir == up or lastLine.dir == down then
			if dir == left then
				x1 = x1 - 0.5 * lineWidth
			else
				x1 = x1 + 0.5 * lineWidth
			end
		else
			if dir == up then
				y1 = y1 - 0.5 * lineWidth
			else
				y1 = y1 + 0.5 * lineWidth
			end
		end

		return x1, y1
	else

		return self.lineManager.config.startX, self.lineManager.config.startY
	end
end

-- Calculate line's end point
function pattern:calcEndPoint(length, dir, x1, y1)

	if dir == up then
		return x1, y1 - length
	end
	
	if dir == down then
		return x1, y1 + length
	end
	
	if dir == left then
		return x1 - length, y1
	end
	
	if dir == right then
		return	x1 + length, y1
	end
end

-- Function checks if potential line or subpattern will traverse a specific edge
function pattern:traverseEdge(dir, length, lastX, lastY)

	local lastX = lastX or self.lineManager.lastX
	local lastY = lastY or self.lineManager.lastY

	if dir == right and lastX + length > self.rightEdge then
		return true
	elseif dir == left and lastX - length < self.leftEdge then
		return true
	elseif dir == down and lastY + length > self.bottomEdge then
		return true
	elseif dir == up and lastY - length < self.topEdge then
		return true
	end

	return false
end

function pattern:reverseDir(dir)
	
	if dir == left then
		return right
	elseif dir == right then
		return left
	elseif dir == up then
		return down
	elseif dir == down then
		return up
	end
end

return pattern