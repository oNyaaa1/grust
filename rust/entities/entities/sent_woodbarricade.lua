AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Item Loot Drop"
ENT.Radius = 360
ENT.Authorized = {}
if SERVER then
    function ENT:Initialize()
        self:SetModel("models/deployable/wooden_barricade.mdl")
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Think()
    end
end