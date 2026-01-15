AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Wall Blocker"
if SERVER then
    util.AddNetworkString("TC_rust_Authorize")
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube3x3x025.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMaterial("Models/effects/vol_light001")
        self:SetColor(Color(255, 255, 255, 0))
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end