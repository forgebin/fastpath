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
local function getMagnitude(a, b) return (b-a).Magnitude end
local function snap(a, b) return ROUND(a/b)*b end
local function snapToGrid(v, separation)
    return V3(snap(v.X, separation.X), snap(v.Y, separation.Y), snap(v.Z, separation.Z))
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

function pathfinding:aStar(map, start_node, end_node, separation, allow_diagonals, time_limit)
    if #self:getNeighbors(map, start_node, separation, allow_diagonals) == 0 or
       #self:getNeighbors(map, end_node, separation, allow_diagonals) == 0 then
        return false
    end

    time_limit = time_limit or HUGE
    g_score, f_score, previous_node, visited = {}, {}, {}, {}

    g_score[start_node], f_score[start_node] = 0, getMagnitude(start_node, end_node)

    local nodes = heap.new(function(a, b) return f_score[a] > f_score[b] end)
    nodes:Insert(start_node)

    local start_time = os.clock()
    while #nodes > 0 do
        local current = nodes:Pop()
        if current == end_node then return true end
        if os.clock() - start_time > time_limit then return false end
        
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
                end
            end
        end
    end
    return false
end

function pathfinding:reconstructPath(node, start_node, end_node, list)
    local current = node
    while current and current ~= start_node do
        if current ~= end_node then
            list[#list+1] = current
        end
        current = previous_node[current]
    end
    for i = 1, #list // 2 do
        list[i], list[#list - i + 1] = list[#list - i + 1], list[i]
    end
end

function pathfinding:getPath(map, start_point, end_point, separation, allow_diagonals)
    local start_node = addNode(map, snapToGrid(start_point, separation))
    local end_node = addNode(map, snapToGrid(end_point, separation))

    if not start_node or not end_node or not self:aStar(map, start_node, end_node, separation, allow_diagonals) then
        return {}
    end

    local path = {}
    self:reconstructPath(end_node, start_node, end_node, path)
    return path
end

return pathfinding
