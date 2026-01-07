AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Turret"
ENT.Radius = 360
ENT.Idle = true
function AddTurret(ent, pos, ang, shelt)
    if CLIENT then return end
    local entz = ents.Create(shelt)
    entz:SetPos(pos)
    entz:SetAngles(ang)
    entz:Spawn()
    entz:Activate()
    entz:SetParent(ent)
    return entz
end

function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/deployable/turret_base.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.yaw_pos = AddTurret(self, self:GetPos() + Vector(0, 0, 30), Angle(0, 0, 0), "rust_yaw_turret")
    self.pitch = AddTurret(self.yaw_pos, self:GetPos() + Vector(0, 0, 35), Angle(0, 0, 0), "rust_pitch_turret")
end

function FindTarget(ent)
    local targ = NULL
    for k, v in pairs(player.GetAll()) do
        local distance = v:GetPos():Distance(ent:GetPos())
        if v == ent then continue end
        if distance >= 0 and v.SafeZone then targ = v end
    end
    return targ
end

function ENT:Think()
    if CLIENT then return end
    local target = FindTarget(self)
    if target == NULL then
        self.yaw_pos:SetAngles(Angle(0, math.sin(CurTime() * 0.5) * 90, 0))
        self.pitch:SetAngles(Angle(math.sin(CurTime() * 0.5) * 1, math.sin(CurTime() * 0.5) * 90, 0))
    elseif target and IsValid(target) then
        self.yaw_pos:SetAngles((self:GetPos() - target:GetPos()):Angle())
        self.pitch:SetAngles((self:GetPos() - target:GetPos()):Angle())
        --[[local bullet = {}
        bullet.Num = 1
        bullet.Src = self:GetPos() + Vector(0, 0, 30)
        bullet.Dir = target:GetPos() - self:GetPos()
        bullet.Spread = Vector(0.01, 0.01, 0)
        bullet.Tracer = 1
        bullet.Force = 2
        bullet.Damage = 0
        self:FireBullets(bullet)]]
    end
end