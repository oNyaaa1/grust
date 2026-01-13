AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_bow.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_bow.mdl"
SWEP.DrawCrosshair = true
SWEP.UseHands = true
SWEP.Primary.Automatic = true
function SWEP:Initialize()
    self:SetHoldType("ar2")
    self.delay = 0
    self.Clicked = false
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:SetNextPrimaryFire(CurTime() + 2)
    local bullet = {}
    bullet.Num = 1
    bullet.Src = pl:GetShootPos()
    bullet.Dir = pl:GetAimVector()
    bullet.Spread = 0.4
    bullet.Tracer = 3
    bullet.Force = 1
    bullet.Damage = 40
    bullet.Attacker = pl
    pl:FireBullets(bullet)
    local BulletsFire = math.random(0.4, 0.5)
    pl:SetEyeAngles(pl:GetAngles() - Angle(BulletsFire, BulletsFire, 0))
    self.Reloaded = false
end

function SWEP:Reload()
    if self.Reloaded then return end
    self:SendWeaponAnim(ACT_VM_DEPLOY)
    self.Reloaded = true
end

function SWEP:Think()
end

function SWEP:SecondaryAttack()
end