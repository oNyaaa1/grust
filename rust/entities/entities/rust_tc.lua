AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Item Loot Drop"
ENT.Radius = 360
ENT.Authorized = {}
if SERVER then
    util.AddNetworkString("TC_rust_Authorize")
    util.AddNetworkString("TC_rust_Authorize_Snd")
    function ENT:Initialize()
        self:SetModel("models/zohart/deployables/tool_cupboard.mdl")
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Think()
        for k, v in pairs(ents.FindInSphere(self:GetPos(), self.Radius)) do
            if not table.HasValue(self.Authorized, v:SteamID64()) then v.BB_Blocked = true end
        end
    end

    function ENT:Use(act, ply)
        local ent = self
        net.Start("TC_rust_Authorize_Snd")
        net.WriteEntity(ent)
        net.Send(ply)
    end

    net.Receive("TC_rust_Authorize", function(len, ply)
        local ent = net.ReadEntity()
        local trace = ply:GetEyeTrace().Entity
        if ent == trace then table.insert(ent.Authorized, ply:SteamID64()) end
    end)
else
    net.Receive("TC_rust_Authorize_Snd", function()
        local ent = net.ReadEntity()
        net.Start("TC_rust_Authorize")
        net.WriteEntity(ent)
        net.SendToServer()
    end)
end