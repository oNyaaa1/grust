AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Door Lock"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/deployable/key_lock.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
		self.Ent_Health = 2500
		self.Ent_HealthMax = 100
		--self:SetMaterial("Model/effects/vol_light001")
		self:DrawShadow()
		self.SpawnTime = 0
		self.EntCount = 0
		self.DoorOpen = false
		self:SetNWInt("health_" .. self:GetClass(), self.Ent_Health)
	end

	function ENT:OnTakeDamage(dmg)
	end

	function ENT:Use(btn, ply)
	end

	function ENT:StartTouch(entity)
		return false
	end

	function ENT:EndTouch(entity)
		return false
	end

	function ENT:Touch(entity)
		return false
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