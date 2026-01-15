AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Turret yaw"
ENT.Radius = 360
function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/deployable/turret_yaw.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end