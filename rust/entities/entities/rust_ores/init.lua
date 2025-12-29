AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
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
    end

    self.SetHealthz = 300
    constraint.Weld(self, game.GetWorld(), 0, 0, 0, true, true)
    self.SpawnTime = CurTime()
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

function ENT:OnTakeDamage(dmg)
    if not IsValid(self) then return end
    local attacker = dmg:GetAttacker()
    if not (IsValid(attacker) and attacker:IsPlayer()) then return end
    attacker:EmitSound("tools/rock_strike_1.mp3")
    if self.SetHealthz == nil then self.SetHealthz = 300 end
    self.SetHealthz = self.SetHealthz - 30
    if self.SetHealthz <= 240 then self:SetModel("models/environment/ores/ore_node_stage2.mdl") end
    if self.SetHealthz <= 150 then self:SetModel("models/environment/ores/ore_node_stage3.mdl") end
    if self.SetHealthz <= 60 then self:SetModel("models/environment/ores/ore_node_stage4.mdl") end
    if self.SetHealthz <= 0 then
        self:RecoveryTime(self:GetPos())
        self:Remove()
    end
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