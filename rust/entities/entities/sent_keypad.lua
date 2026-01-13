AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Door"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/deployable/keypad.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion(false)
		end
	end

	function ENT:Think()
		local doors = 0
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 30)) do
			if v:GetClass() == "sent_way_door" then doors = doors + 1 end
		end

		if doors <= 0 then
			if IsValid(self) then self:Remove() end
			if IsValid(self.doorLock) then self.doorLock:Remove() end
		end
	end

	function ENT:OnTakeDamage(dmg)
	end

	function ENT:Use(btn, ply)
	end

	function ENT:StartTouch(entity)
		local pl = self:GetOwner()
		if not IsValid(pl) then return end
		entity.Lock = pl
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