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
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() end
        self.DoorOpen = true
    end

    function ENT:Think()
        if self.PropLockDoor == nil then self.PropLockDoor = nil end
        if self.PropGarDoor == nil then self.PropGarDoor = nil end
        for k, v in pairs(ents.FindInSphere(self:GetPos(), 0.1)) do
            if v:GetClass() == "sent_garagedoor" then self.PropGarDoor = v end
        end

        if IsValid(self.doorLock) and IsValid(self.PropGarDoor) then
            self.doorLock:SetPos(self.PropGarDoor:GetPos() + self.PropGarDoor:GetUp() * 38 + self.PropGarDoor:GetRight() * -5 + self.PropGarDoor:GetForward() * 46)
            self.doorLock:SetAngles(self.PropGarDoor:GetAngles())
        end
    end

    function ENT:Use(act, caller)
        if self.Lock and self.Lock ~= caller then return end
        if caller.Meh == nil then caller.Meh = 0 end
        if caller.Meh >= CurTime() then return end
        caller.Meh = CurTime() + 0.2
        if self.DoorOpen == false then
            if IsValid(self.PropGarDoor) then self.PropGarDoor:SetSequence("open") end
            caller:EmitSound("doors/garage_door_open.wav")
            self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
            self.DoorOpen = true
        elseif self.DoorOpen == true then
            if IsValid(self.PropGarDoor) then self.PropGarDoor:SetSequence("close") end
            caller:EmitSound("doors/garage_door_stop.wav")
            self:SetCollisionGroup(COLLISION_GROUP_WORLD)
            self.DoorOpen = false
        end
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end