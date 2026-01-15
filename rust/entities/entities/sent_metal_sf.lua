AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Item Loot Drop"
ENT.Radius = 360
ENT.Authorized = {}
if SERVER then
    util.AddNetworkString("TC_rust_Authorize")
    function ENT:Initialize()
        self:SetModel("models/darky_m/rust/shopfront.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end
end