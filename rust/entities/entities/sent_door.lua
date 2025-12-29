AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Door"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/vasey/wood_house/door.mdl"
if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/vasey/wood_house/door.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion(false)
		end

		constraint.Weld(self, Entity(0), 0, 0, 0, true, true)
		self.Ent_Health = 2500
		self.Ent_HealthMax = 100
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
		local doors = 0
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 30)) do
			if v:GetClass() == "sent_doorway" then doors = doors + 1 end
		end

		if doors <= 0 then self:Remove() end
	end

	function ENT:OnTakeDamage(dmg)
		local ply = dmg:GetAttacker()
		local inflictor = dmg:GetInflictor()
		--if type(inflictor) == "Entity" then return end
		--if self.PropOwned != ply then return end
		self.Ent_Health = self.Ent_Health - dmg:GetDamage()
		if self.Ent_Health <= 0 then self:Remove() end
		self:SetNWInt("health_" .. self:GetClass(), self.Ent_Health)
	end

	function ENT:Use(btn, ply)
		if ply.Meh == nil then ply.Meh = 0 end
		if ply.Meh >= CurTime() then return end
		ply.Meh = CurTime() + 0.2
		if self.PropOwned ~= ply then
			ply:ChatPrint("Door is locked")
			return
		end

		if self.DoorOpen == false then
			self.DoorPos = self:GetAngles()
			self.DoorPosa = self:GetPos()
			self:SetPos(self:GetPos() + ply:GetForward() + Vector(28, 25, 7))
			self:SetAngles(self:GetAngles() + Angle(0, 90, 0))
			self.DoorOpen = true
		elseif self.DoorOpen == true then
			self:SetPos(self.DoorPosa)
			self:SetAngles(self.DoorPos)
			self.DoorOpen = false
		end
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