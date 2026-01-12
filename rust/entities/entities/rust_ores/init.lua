AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("gRustAngleRocks")
local matr = {"models/blacksnow/rust_rock", "models/blacksnow/rock_ore"}
function ENT:Initialize()
    self:SetModel("models/environment/ores/ore_node_stage1.mdl")
    self:SetSkin(math.random(1, 3))
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
        phys:SetMass(50)
        phys:SetMaterial("rock") -- Use a high-friction material
        phys:EnableDrag(false) -- Disable drag so it doesn't slide
    end

    self.SetHealthz = 300
    self.SpawnTime = CurTime()
    -- Get the rock's bounding box
    -- Get the rock's bounding box in local space
    -- Get the rock's bounding box in local space
    local mins, maxs = self:GetModelBounds()
    -- Random position on top of the rock in local space
    local randomX = math.Rand(mins.x * 0.2, maxs.x * 0.2)
    local randomY = math.Rand(mins.y * 0.2, maxs.y * 0.2)
    local localPos = Vector(randomX, randomY, maxs.z)
    -- Convert to world space
    local topPosition = self:LocalToWorld(localPos)
    self.strongSpot = topPosition
    self:SetNWVector("StrongSpot", topPosition)
end

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end
    local ent = ents.Create("rust_ores")
    ent:SetPos(tr.HitPos + tr.HitNormal * 32)
    ent:Spawn()
    ent:Activate()
    return ent
end

function ENT:RecoveryTime(pos)
    timer.Simple(60 * 5, function()
        if not util.IsInWorld(pos) then return end
        local ent = ents.Create("rust_ores")
        ent:SetPos(pos)
        ent:Spawn()
        ent:Activate()
    end)
end

function ENT:UpdateStrongSpot()
    local mins, maxs = self:GetModelBounds()
    local randomX = math.Rand(mins.x * 0.7, maxs.x * 0.7)
    local randomY = math.Rand(mins.y * 0.7, maxs.y * 0.7)
    local localPos = Vector(randomX, randomY, maxs.z)
    local topPosition = self:LocalToWorld(localPos)
    self.strongSpot = topPosition
    self:SetNWVector("StrongSpot", topPosition)
end

local function MineRocks(ply, item, amount)
    local me = ply:ExistingInventoryItem({
        Weapon = item
    }, amount or 0)

    if me then return end
    ply:AddInventoryItem({
        Weapon = item,
    }, true, amount or 0)
end

local function GetTypeRock(typez)
    if typez:GetSkin() == 3 then
        --=rock=--
        return "Stone"
    end

    if typez:GetSkin() == 1 then
        --=metal=--
        return "Metal Ore"
    end

    if typez:GetSkin() == 2 then
        --=sulfur=--
        return "Sulfur Ore"
    end
end

local ORE_WEAPONS = {
    ["rust_e_rock"] = {
        Name = "Rock",
        ["Metal Ore"] = 1,
        ["Sulfur Ore"] = 1,
        ["Stone"] = 1,
    },
    ["rust_stone_pickaxe"] = {
        ["Metal Ore"] = 1.94,
        ["Sulfur Ore"] = 2.57,
        ["Stone"] = 2.11733
    },
    ["rust_pickaxe"] = {
        ["Metal Ore"] = 2.4,
        ["Sulfur Ore"] = 3,
        ["Stone"] = 2.667
    },
    ["rust_jackhammer"] = {
        ["Metal Ore"] = 2.4,
        ["Sulfur Ore"] = 3,
        ["Stone"] = 2.667
    }
}

function ENT:OnTakeDamage(dmg)
    if not IsValid(self) then return end
    local attacker = dmg:GetAttacker()
    if not (IsValid(attacker) and attacker:IsPlayer()) then return end
    local wep = attacker:GetActiveWeapon()
    if not IsValid(wep) then return end
    local class = wep:GetClass()
    local realwep = ORE_WEAPONS[class]
    if realwep == nil then return end
    attacker:EmitSound("tools/rock_strike_1.mp3")
    if self.SetHealthz == nil then self.SetHealthz = 300 end
    self.SetHealthz = self.SetHealthz - 30
    -- Then in your damage code:
    -- Add this function to your entity
    -- In your damage/hit detection code:
    local tr = attacker:GetEyeTrace()
    -- Get the direction from rock center to weak spot
    local spotDir = (self.strongSpot - self:GetPos()):GetNormalized()
    -- Get the direction from rock center to where they hit
    local hitDir = (tr.HitPos - self:GetPos()):GetNormalized()
    -- Check if the directions are similar (dot product close to 1)
    local similarity = spotDir:Dot(hitDir)
    -- In your model change code:
    if self.SetHealthz <= 240 then
        self:SetModel("models/environment/ores/ore_node_stage2.mdl")
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:EnableMotion(false)
            phys:SetMass(50)
            phys:SetMaterial("rock") -- Use a high-friction material
            phys:EnableDrag(false) -- Disable drag so it doesn't slide
        end

        self:UpdateStrongSpot()
    end

    if self.SetHealthz <= 150 then
        self:SetModel("models/environment/ores/ore_node_stage3.mdl")
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:EnableMotion(false)
            phys:SetMass(50)
            phys:SetMaterial("rock") -- Use a high-friction material
            phys:EnableDrag(false) -- Disable drag so it doesn't slide
        end

        self:UpdateStrongSpot()
    end

    if self.SetHealthz <= 60 then
        self:SetModel("models/environment/ores/ore_node_stage4.mdl")
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:EnableMotion(false)
            phys:SetMass(50)
            phys:SetMaterial("rock") -- Use a high-friction material
            phys:EnableDrag(false) -- Disable drag so it doesn't slide
        end

        self:UpdateStrongSpot()
    end

    if self.SetHealthz <= 0 then
        self:RecoveryTime(self:GetPos())
        self:Remove()
    end

    net.Start("gRustAngleRocks")
    net.WriteEntity(self)
    net.Broadcast()
    local rock = GetTypeRock(tr.Entity)
    if not rock then return end
    if similarity > 0.9 then -- Hit the same general area (0.9 = ~25 degree cone)
        attacker:EmitSound("farming/flare_hit.wav")
        self:UpdateStrongSpot()
        MineRocks(attacker, rock, 60)
        return
    end

    MineRocks(attacker, rock, 30)
end

function ENT:Think()
end

function ENT:Use(btn, ply)
end

function ENT:StartTouch(ent)
    return false
end

function ENT:EndTouch(ent)
    return false
end

function ENT:Touch(ent)
    return false
end