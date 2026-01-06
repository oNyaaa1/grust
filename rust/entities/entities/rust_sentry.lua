AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Turret"
ENT.Radius = 360
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
    --self.head = AddTurret(self.pitch, self:GetPos() + Vector(0, 0, -5), Angle(0, 0, 0), "rust_head_turret")
end

function ENT:Think()
    if CLIENT then return end
    self.yaw_pos:SetAngles(Angle(0, math.sin(CurTime() * 0.5) * 90, 0))
    self.pitch:SetAngles(Angle(math.sin(CurTime() * 0.5) * 1, math.sin(CurTime() * 0.5) * 90, 0))
end