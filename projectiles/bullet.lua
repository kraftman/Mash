
local lg = love.graphics

local bullet = {
    fireRate = 0.8
}

bullet.__index = bullet

function bullet:Update(dt)

end

function bullet:GetNewCoords(dt)
    return {
        x = self.x + self.vx * dt,
        y = self.y + self.vy * dt
    }
end

function bullet:SetNewCoords(coords)
    self.x = coords.x
    self.y = coords.y
end

function bullet:Draw()
    lg.circle('fill', self.x, self.y, self.radius)

end

function bullet:GetFireRate()
    return self.fireRate
end

function bullet:SetPlayer(player)
    self.owner = player
end

function bullet:RemoveOOB()
    self.world:RemoveProjectile(self)
end



function bullet:Create(world, x, y, angle)
    local b = setmetatable({}, bullet)
    b.world = world
    b.x = x
    b.y = y
    b.vMultiplier = 500
    b.vx = b.vMultiplier * math.sin( angle )
    b.vy = b.vMultiplier * math.cos( angle )
    b.radius = 2 
    return b
end

return bullet