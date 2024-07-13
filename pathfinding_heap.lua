local pathfinding = {}
local heap = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/pathfinding/main/binary_heap.lua"))()

-- Cached Functions and Constants
local V3, ROUND, HUGE = Vector3.new, math.round, math.huge
local TINSERT = table.insert

-- Precompute moves
local MOVES = {V3(-1,0,0),V3(0,-1,0),V3(0,0,-1),V3(0,0,1),V3(0,1,0),V3(1,0,0)}
local DIAGONAL_MOVES = {
	V3(-1,-1,-1),V3(-1,-1,0),V3(-1,-1,1),V3(-1,0,-1),V3(-1,0,1),V3(-1,1,-1),V3(-1,1,0),V3(-1,1,1),
	V3(0,-1,-1),V3(0,-1,1),V3(0,1,-1),V3(0,1,1),V3(1,-1,-1),V3(1,-1,0),V3(1,-1,1),V3(1,0,-1),V3(1,0,1),
	V3(1,1,-1),V3(1,1,0),V3(1,1,1)
}

-- Utility Functions
local D = 1  -- Cost of moving along an axis
local D2 = math.sqrt(2)  -- Cost of moving diagonally in a plane
local D3 = math.sqrt(3)  -- Cost of moving diagonally in 3D space

local function getMagnitude(start, goal)
	return (start-goal).Magnitude
end

local function vectorToMap(map, v)
	local mx, my = map[v.X], map[v.X] and map[v.X][v.Y]
	return my and my[v.Z]
end

local function addNode(map, v)
	local mx = map[v.X]
	if not mx then mx = {}; map[v.X] = mx end
	local my = mx[v.Y]
	if not my then my = {}; mx[v.Y] = my end
	my[v.Z] = my[v.Z] or v
	return v
end

-- Pathfinding Functions
function pathfinding:getNeighbors(map, node, separation, allow_diagonals)
	local neighbors = {}
	for i = 1, #MOVES do
		local n = vectorToMap(map, node + MOVES[i] * separation)
		if n then neighbors[#neighbors+1] = n end
	end
	if allow_diagonals then
		for i = 1, #DIAGONAL_MOVES do
			local n = vectorToMap(map, node + DIAGONAL_MOVES[i] * separation)
			if n then neighbors[#neighbors+1] = n end
		end
	end
	return neighbors
end

local g_score, f_score, previous_node, visited

function pathfinding:aStar(map, start_node, end_node, separation, allow_diagonals, time_limit, params)
	if #self:getNeighbors(map, start_node, separation, allow_diagonals) == 0 or
		#self:getNeighbors(map, end_node, separation, allow_diagonals) == 0 then
		return false, {}
	end

	time_limit = time_limit or HUGE
	g_score, f_score, previous_node, visited = {}, {}, {}, {}

	g_score[start_node], f_score[start_node] = 0, getMagnitude(start_node, end_node)

	local nodes = heap.new(function(a, b) return f_score[a] > f_score[b] end)
	nodes:Insert(start_node)

	local start_time = tick()
	local best_node = start_node
	local best_f_score = f_score[start_node]

	local timer_func = 0
	while #nodes > 0 do
		timer_func += 1
		if timer_func > 1024 then
			task.wait()
			timer_func = 0
		end
		pcall(function()
			local current = nodes:Pop()
			if current == end_node then return true, self:reconstructPath(current) end
			if tick() - start_time > time_limit then warn("TIMELIMIT REACH") return end

			visited[current] = true
			for _, neighbor in ipairs(self:getNeighbors(map, current, separation, allow_diagonals)) do
				if not visited[neighbor] then
					local tentative_g = g_score[current] + getMagnitude(current, neighbor)
					if tentative_g < (g_score[neighbor] or HUGE) then 
						previous_node[neighbor] = current
						g_score[neighbor] = tentative_g
						f_score[neighbor] = tentative_g + getMagnitude(neighbor, end_node)
						if not nodes:Find(neighbor) then
							nodes:Insert(neighbor)
						end

						-- Update best node if this is closer to the end
						if f_score[neighbor] < best_f_score then
							best_node = neighbor
							best_f_score = f_score[neighbor]
						end
					end
				end
			end
		end)
	end

	-- Time limit reached or no path found, return the best path so far
	return false, self:reconstructPath(best_node)
end

function pathfinding:reconstructPath(node)
	local path = {}
	local current = node
	while current do
		table.insert(path, 1, current)
		current = previous_node[current]
	end
	return path
end

function pathfinding:getPath(map, start_point, end_point, separation, allow_diagonals)
	local start_node = addNode(map, start_point, separation)
	local end_node = addNode(map, end_point, separation)

	if not start_node or not end_node then
		return {}
	end

	local success, path = self:aStar(map, start_node, end_node, separation, allow_diagonals)
	return path
end

return pathfinding
