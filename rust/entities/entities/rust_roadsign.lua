AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
local RoadSignModels = {"models/environment/roadsigns/roadsign_b.mdl", "models/environment/roadsigns/roadsign_c.mdl", "models/environment/roadsigns/roadsign_d.mdl", "models/environment/roadsigns/roadsign_e.mdl", "models/environment/roadsigns/roadsign_f.mdl", "models/environment/roadsigns/roadsign_g.mdl"}
function ENT:Initialize()
    if CLIENT then return end
    -- Pick a random roadsign model
    local randomModel = RoadSignModels[math.random(#RoadSignModels)]
    self:SetModel(randomModel)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    -- Roadsign health settings
    self:PrecacheGibs()
    -- Damage multipliers
end

local LootItems = {
    {
        Item = "roadsigns",
        Min = 1,
        Max = 2,
        Chance = 100
    },
    {
        Item = "metalpipe",
        Min = 1,
        Max = 2,
        Chance = 100
    }
}

local function GetRandomItem(tbl)
    for i = 1, #tbl do
        local v = tbl[i]
        if (math.random() * 100) > v.Chance then continue end
        local Item = gRust.CreateItem(v.Item)
        if not Item then return end
        Item:SetQuantity(math.random(v.Min, v.Max))
        table.remove(tbl, i)
        return Item
    end
end

function ENT:SpawnLoot()
    if CLIENT then return end
    local tbl = table.Copy(LootItems)
    for i = 1, 3 do -- Spawn up to 3 items
        local Item = GetRandomItem(tbl)
        if not Item then continue end
        local Maxs = self:OBBMaxs()
        local ent = ents.Create("rust_droppeditem")
        ent:SetItem(Item)
        ent:SetPos(self:GetPos() + Vector(math.random(-Maxs.x, Maxs.x), math.random(-Maxs.y, Maxs.y), Maxs.z * math.random(0.25, 0.5)))
        ent:Spawn()
    end
end

function ENT:OnDestroyed(dmg)
    if CLIENT then return end
    -- Spawn loot using the proper system
    self:SpawnLoot()
    -- Gib effects
    self:GibBreakClient(Vector(0, 0, 1))
    -- Schedule respawn
    self:ScheduleRespawn()
end

function ENT:ScheduleRespawn()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    local respawnTime = self:GetRespawnTime() or 300
    gRust.CreateRespawn("rust_roadsign", pos, ang, 300)
end