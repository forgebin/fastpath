local Octree = {}
Octree.__index = Octree

function Octree.new(center, size, maxDepth, maxObjects)
    local self = setmetatable({}, Octree)
    self.center = center
    self.size = size
    self.maxDepth = maxDepth or 8
    self.maxObjects = maxObjects or 8
    self.objects = {}
    self.children = nil
    self.depth = 0
    return self
end

function Octree:insert(object, position)
    if not self:contains(position) then
        return false
    end

    if #self.objects < self.maxObjects and not self.children then
        table.insert(self.objects, {object = object, position = position})
        return true
    end

    if not self.children then
        self:split()
    end

    for _, child in ipairs(self.children) do
        if child:insert(object, position) then
            return true
        end
    end

    return false
end

function Octree:split()
    if self.depth >= self.maxDepth then
        return
    end

    local halfSize = self.size / 2
    local quarterSize = halfSize / 2

    self.children = {
        Octree.new(self.center + Vector3.new(-quarterSize.X, quarterSize.Y, -quarterSize.Z), halfSize, self.maxDepth, self.maxObjects),
        Octree.new(self.center + Vector3.new(quarterSize.X, quarterSize.Y, -quarterSize.Z), halfSize, self.maxDepth, self.maxObjects),
        Octree.new(self.center + Vector3.new(-quarterSize.X, quarterSize.Y, quarterSize.Z), halfSize, self.maxDepth, self.maxObjects),
        Octree.new(self.center + Vector3.new(quarterSize.X, quarterSize.Y, quarterSize.Z), halfSize, self.maxDepth, self.maxObjects),
        Octree.new(self.center + Vector3.new(-quarterSize.X, -quarterSize.Y, -quarterSize.Z), halfSize, self.maxDepth, self.maxObjects),
        Octree.new(self.center + Vector3.new(quarterSize.X, -quarterSize.Y, -quarterSize.Z), halfSize, self.maxDepth, self.maxObjects),
        Octree.new(self.center + Vector3.new(-quarterSize.X, -quarterSize.Y, quarterSize.Z), halfSize, self.maxDepth, self.maxObjects),
        Octree.new(self.center + Vector3.new(quarterSize.X, -quarterSize.Y, quarterSize.Z), halfSize, self.maxDepth, self.maxObjects)
    }

    for _, child in ipairs(self.children) do
        child.depth = self.depth + 1
    end

    for _, obj in ipairs(self.objects) do
        for _, child in ipairs(self.children) do
            if child:insert(obj.object, obj.position) then
                break
            end
        end
    end

    self.objects = {}
end

function Octree:contains(position)
    local halfSize = self.size / 2
    return position.X >= self.center.X - halfSize.X and position.X <= self.center.X + halfSize.X
       and position.Y >= self.center.Y - halfSize.Y and position.Y <= self.center.Y + halfSize.Y
       and position.Z >= self.center.Z - halfSize.Z and position.Z <= self.center.Z + halfSize.Z
end

function Octree:query(position, radius)
    local result = {}

    if not self:intersectsSphere(position, radius) then
        return result
    end

    for _, obj in ipairs(self.objects) do
        if (obj.position - position).Magnitude <= radius then
            table.insert(result, obj.object)
        end
    end

    if self.children then
        for _, child in ipairs(self.children) do
            for _, obj in ipairs(child:query(position, radius)) do
                table.insert(result, obj)
            end
        end
    end

    return result
end

function Octree:intersectsSphere(center, radius)
    local halfSize = self.size / 2
    local dX = math.abs(center.X - self.center.X)
    local dY = math.abs(center.Y - self.center.Y)
    local dZ = math.abs(center.Z - self.center.Z)

    if dX > halfSize.X + radius or dY > halfSize.Y + radius or dZ > halfSize.Z + radius then
        return false
    end

    if dX <= halfSize.X or dY <= halfSize.Y or dZ <= halfSize.Z then
        return true
    end

    local cornerDistanceSq = (dX - halfSize.X)^2 + (dY - halfSize.Y)^2 + (dZ - halfSize.Z)^2

    return cornerDistanceSq <= radius^2
end

return Octree
