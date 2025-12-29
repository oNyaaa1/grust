AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Foundation"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/building_re/twig_foundation.mdl"
if SERVER then
    function ENT:Initialize()
        self.Entity:SetModel(self.Models)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            //phys:EnableMotion(false)
        end

        constraint.Weld(self, Entity(0), 0, 0, 0, true, true)
        self.Ent_Health = 50
        --self:SetMaterial("Model/effects/vol_light001")
        self:DrawShadow()
        self.SpawnTime = 0
        self.EntCount = 0
        self.DoorOpen = false
        self:SetNWInt("health_" .. self:GetClass(), self.Ent_Health)
    end

    --[[ function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local ent = ents.Create( "zombie_tree1" )
	ent:SetPos( tr.HitPos + tr.HitNormal * 32 ) 
	ent:Spawn()
	ent:Activate()

	return ent
end ]]
    function ENT:Think()
    end

    function ENT:OnTakeDamage(dmg)
        local ply = dmg:GetAttacker()
        local inflictor = dmg:GetInflictor()
        --if self.PropOwned ~= ply then return end
        self.Ent_Health = self.Ent_Health - dmg:GetDamage()
        if self.Ent_Health <= 0 then self:Remove() end
        self:SetNWInt("health_" .. self:GetClass(), self.Ent_Health)
    end

    function ENT:OnRemove()
        self:EmitSound("zohart/building/wood_gib-4.wav")
    end

    function ENT:Use(btn, ply)
    end
end

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
    function ENT:Initialize()
    end

    function ENT:Draw()
        self:DrawModel()
    end
end