AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/environment/plants/hemp.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self:SetUseType(SIMPLE_USE)
	self:SetBodygroup(1, 3)
	self.CanPickup = true
	self.MaxUses = 1
	self.CurrentUses = 0
end

function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end
	if self.CurrentUses >= self.MaxUses then return end
	if activator:GiveItem("Cloth", 10) then
		activator:EmitSound("ui/items/pickup_cloth_1.wav")
		--activator:SendNotification("Cloth", NOTIFICATION_PICKUP, "materials/icons/pickup.png", "+" .. 10)
		local item = activator:GetItem("Cloth")
		activator:SendNotification("Cloth", NOTIFICATION_PICKUP, "materials/icons/pickup.png", "+" .. 10 .. " (" .. item["Amount"] .. ")")
		self.CurrentUses = self.CurrentUses + 1
		if self.CurrentUses >= self.MaxUses then
			self:Remove() -- Remove hemp permanently instead of respawning
		end
	else
		activator:ChatPrint("")
	end
end

function ENT:OnRemove()
end