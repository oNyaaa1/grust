-- Spawning System for gRust
-- Handles spawning of all entities on the map
local SpawningSystem = {}
-- Configuration
function Logger(msg)
    print(msg)
end

local trees = 300
-- Predefined spawn positions
local function FindRandomPlacesOnMap(count)
    local positions = {}
    local attempts = 0
    local maxAttempts = count * 15
    while #positions < count and attempts < maxAttempts do
        attempts = attempts + 1
        local pos = Vector(math.Rand(-14400, 14400), math.Rand(-14400, 14400), 5000)
        local tr = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 10000),
            mask = MASK_SOLID_BRUSHONLY
        })

        local surfaceMaterial = util.GetSurfacePropName(tr.SurfaceProps)
        if surfaceMaterial == "grass" then
            if table.HasValue(positions, tr.HitPos + Vector(0, 0, 10)) then return end
            if tr.Hit and tr.HitPos.z > 50 and tr.HitPos.z < 1000 then table.insert(positions, tr.HitPos + Vector(0, 0, 10)) end
        end
    end
    return positions
end

function SpawningSystem.SpawnTrees()
    local positions = FindRandomPlacesOnMap(trees)
    local spawnedCount = 0
    for _, pos in pairs(positions) do
        local ent = ents.Create("rust_trees")
        if IsValid(ent) then
            ent:SetPos(pos - Vector(0, 0, 50))
            ent:Spawn()
            ent:Activate()
            ent:SetModelScale(1.75, 0)
            ent:DropToFloor()
            spawnedCount = spawnedCount + 1
            local trace = util.TraceLine({
                start = ent:GetPos(),
                endpos = ent:GetPos() - Vector(0, 0, 1000), -- Trace 1000 units downwards
                filter = ent -- Filter out the entity so it doesn't hit itself
            })

            local floorNormal = trace.HitNormal
            local alignedAngles = Vector(1, 0, 0):AngleEx(floorNormal)
            ent:SetAngles(alignedAngles)
        end
    end

    Logger("[Spawning] Spawned " .. spawnedCount .. " Trees")
end

hook.Add("PlayerInitialSpawn", "AddTrees", function(ply)
    if not TreeSpawned then
        //SpawningSystem.SpawnTrees()
        TreeSpawned = true
    end
end)

Logger("Spawning system loaded")