AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_lr300.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_lr300.mdl"
SWEP.DrawCrosshair = true
SWEP.UseHands = true
SWEP.Primary.Automatic = true
function SWEP:Initialize()
    self:SetHoldType("melee2")
    self.delay = 0
    self.Clicked = false
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    if SERVER and pl.ConsumeDurabilityForWeapon then pl:ConsumeDurabilityForWeapon(self) end
    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/rust_distant/lr300-attack.mp3")
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:SetNextPrimaryFire(CurTime() + 0.15)
    local bullet = {}
    bullet.Num = 1
    bullet.Src = pl:GetShootPos()
    bullet.Dir = pl:GetAimVector()
    bullet.Spread = 0.4
    bullet.Tracer = 3
    bullet.Force = 1
    bullet.Damage = 35
    bullet.Attacker = pl
    pl:FireBullets(bullet)
    local BulletsFire = math.random(0.4, 0.5)
    pl:SetEyeAngles(pl:GetAngles() - Angle(BulletsFire, BulletsFire, 0))
end

function SWEP:Think()
end

function SWEP:SecondaryAttack()
end