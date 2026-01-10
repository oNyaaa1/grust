-- rust_trees/init.lua
if SERVER then AddCSLuaFile() end

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
    if CLIENT then return end
    self:SetModel(self:GetModel())
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
end

function ENT:OnTakeDamage(dmg)
end