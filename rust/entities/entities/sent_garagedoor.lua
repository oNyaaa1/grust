AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Item Loot Drop"
ENT.Radius = 360
ENT.Authorized = {}
if SERVER then
    util.AddNetworkString("TC_rust_Authorize")
    function ENT:Initialize()
        self:SetModel("models/darky_m/rust/building/garage_door.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() end
        self.CollisionBug = ents.Create("sent_blocker_wall_door")
        self.CollisionBug:SetPos(self:GetPos() + self:GetUp() * 35 + self:GetRight() * -5)
        self.CollisionBug:SetAngles(self:GetAngles() - Angle(90, 90, 0))
        self.CollisionBug:Spawn()
        self.CollisionBug:Activate()
        
        self.DoorOpen = false
    end

    function ENT:Think()
    end

    function ENT:Use(btn, ply)
        if self.Lock and self.Lock ~= ply then return end
        if ply.Meh == nil then ply.Meh = 0 end
        if ply.Meh >= CurTime() then return end
        ply.Meh = CurTime() + 0.2
        --if self.PropOwned ~= ply then
        --ply:ChatPrint("Door is locked")
        --return
        --end
        --[[

 if self.DoorOpen == false then
            self:SetSequence("open")
            self:EmitSound("doors/garage_door_open.wav")
            self.CollisionBug:SetCollisionGroup(COLLISION_GROUP_PLAYER)
            self.DoorOpen = true
        elseif self.DoorOpen == true then
            self:SetSequence("close")
            self:EmitSound("doors/garage_door_stop.wav")
            self.CollisionBug:SetCollisionGroup(COLLISION_GROUP_WORLD)
            self.DoorOpen = false
        end]]
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end