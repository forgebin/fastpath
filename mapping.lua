local mapping = {}

-- Constants
local RAY_PRECISION = 1.0e-4
local V3, ROUND, MIN = Vector3.new, math.round, math.min
local TINSERT = table.insert

-- Utility Functions
local function getUnit(a, b) return (b-a).Unit end

local function hasProperty(object, property)
    local success, value = pcall(function() return object[property] end)
    return success and value ~= object:FindFirstChild(property)
end

local function addNode(map, v)
    local mx = map[v.X]
    if not mx then mx = {}; map[v.X] = mx end
    local my = mx[v.Y]
    if not my then my = {}; mx[v.Y] = my end
    my[v.Z] = v
    return v
end

-- Mapping Functions
function mapping:recursiveRay(from, to, results, raycast_params, c, reverse)
    c = c + 1
    if c > 1000 then return end
    
    local result = workspace:Raycast(from, to - from, raycast_params)
    if not result then return end

    local intersect = result.Position
    local direction = getUnit(intersect, to)
    
    if reverse then
        self:recursiveRay(intersect + direction * RAY_PRECISION, to, results, raycast_params, c, reverse)
    end

    if not hasProperty(result.Instance, "CanCollide") or result.Instance.CanCollide then
        results[#results + 1] = intersect
    end

    if not reverse then
        self:recursiveRay(intersect + direction * RAY_PRECISION, to, results, raycast_params, c, reverse)
    end
end

function mapping:getValidIntersects(top_intersects, bottom_intersects, intersect_count, agent_height)
    local valid = {}
    for i = 1, intersect_count do
        local top, bottom = top_intersects[i], bottom_intersects[i-1]
        if bottom.Y - top.Y >= agent_height then
            valid[#valid + 1] = top
        end
    end
    return valid
end

function mapping:getTraversableSpots(pos, agent_height, raycast_params)
    local from, to = V3(pos.X, 1000, pos.Z), V3(pos.X, -1000, pos.Z)
    
    local top_intersects, bottom_intersects = {}, {}
    self:recursiveRay(from, to, top_intersects, raycast_params, 0, false)
    self:recursiveRay(to, from, bottom_intersects, raycast_params, 0, true)

    local top_count = #top_intersects
    if top_count == 0 then return {} end
    
    local bottom_count = #bottom_intersects
    if top_count ~= bottom_count then top_count = MIN(top_count, bottom_count) end

    bottom_intersects[0] = from
    return self:getValidIntersects(top_intersects, bottom_intersects, top_count, agent_height)
end

function mapping:createMap(p1, p2, separation, agent_height, raycast_params)
    local map = {}
    raycast_params = raycast_params or RaycastParams.new()

    local diffx, diffz = p2.X - p1.X, p2.Z - p1.Z
    local dx, dz = diffx < 0 and -1 or 1, diffz < 0 and -1 or 1

    for x = 0, diffx, separation.X * dx do
        for z = 0, diffz, separation.Z * dz do
            local position = V3(p1.X + x, 0, p1.Z + z)
            for _, v in ipairs(self:getTraversableSpots(position, agent_height, raycast_params)) do
                addNode(map, v)
            end
        end
    end

    return map
end

return mapping
