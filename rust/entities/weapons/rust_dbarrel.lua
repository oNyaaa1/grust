AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_doublebarrel.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_doublebarrel.mdl"
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
    self:SetNextPrimaryFire(CurTime() + 1)
    local bullet = {}
    bullet.Num = 3
    bullet.Src = pl:GetShootPos()
    bullet.Dir = pl:GetAimVector()
    bullet.Spread = 0.5
    bullet.Tracer = 3
    bullet.Force = 1
    bullet.Damage = 15
    bullet.Attacker = pl
    pl:FireBullets(bullet)
    self.Clicked = false
    local BulletsFire = math.random(0.4, 0.5)
    pl:SetEyeAngles(pl:GetAngles() - Angle(BulletsFire, BulletsFire, 0))
end

function SWEP:Reload()
    if self.delay >= CurTime() then return end
    if self.Clicked then return end
    self.delay = CurTime() + 1.1
    self.Clicked = true
    self:SendWeaponAnim(ACT_VM_RELOAD)
    timer.Simple(1, function() self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) end)
end

function SWEP:Think()
end

function SWEP:SecondaryAttack()
end