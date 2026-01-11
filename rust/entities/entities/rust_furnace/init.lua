AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("gRustFurnace")
ENT.SetHealthz = 100
function ENT:Initialize()
    self:SetModel("models/deployable/furnace.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end
    local ent = ents.Create("rust_ores")
    ent:SetPos(tr.HitPos + tr.HitNormal * 32)
    ent:Spawn()
    ent:Activate()
    return ent
end

function ENT:OnTakeDamage(dmg)
    if not IsValid(self) then return end
    local attacker = dmg:GetAttacker()
    if not (IsValid(attacker) and attacker:IsPlayer()) then return end
    if self.SetHealthz == nil then self.SetHealthz = 300 end
    self.SetHealthz = self.SetHealthz - 30
    if self.SetHealthz <= 0 then self:Remove() end
end

function ENT:Think()
end

function ENT:Use(btn, ply)
    net.Start("gRustFurnace")
    net.WriteEntity(self)
    net.Send(ply)
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