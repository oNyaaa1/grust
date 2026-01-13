AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_doublebarrel.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_doublebarrel.mdl"
SWEP.DrawCrosshair = true
SWEP.UseHands = true
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipSizeMaxSize = 30
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Sound = "weapons/rust_distant/grenade-launcher-attack.mp3"
SWEP.Primary.NextFire = 1
function SWEP:Initialize()
    self:SetHoldType("ar2")
    self.delay = 0
    self.Clicked = false
    self.Reloaded = false
    self.Clapped = 0
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if self.Primary.DefaultClip <= 0 then return end
    if not self:CanPrimaryAttack() then
        self.Reloaded = false
        self.OldClip = nil
        return
    end

    if not IsValid(pl) then return end
    if SERVER and pl.ConsumeDurabilityForWeapon then pl:ConsumeDurabilityForWeapon(self) end
    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound(self.Primary.Sound)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:SetNextPrimaryFire(CurTime() + self.Primary.NextFire)
    local bullet = {}
    bullet.Num = 1
    bullet.Src = pl:GetShootPos()
    bullet.Dir = pl:GetAimVector()
    bullet.Spread = 0.4
    bullet.Tracer = 3
    bullet.Force = 1
    bullet.Damage = 25
    bullet.Attacker = pl
    pl:FireBullets(bullet)
    local BulletsFire = math.random(0.4, 0.5)
    pl:SetEyeAngles(pl:GetAngles() - Angle(BulletsFire, BulletsFire, 0))
    self:TakePrimaryAmmo(1)
    self.Reloaded = false
    self.Clapped = self.Clapped + 1
end

function SWEP:Reload()
    if self.delay >= CurTime() then return end
    self.delay = CurTime() + 1
    if self.Reloaded then return end
    if self.Primary.ClipSize <= self.Primary.ClipSizeMaxSize then
        timer.Simple(4, function() if IsValid(self) then self.Clicked = false end end)
        self:SendWeaponAnim(ACT_VM_RELOAD)
        self.Primary.ClipSize = self.Primary.ClipSize - self.Clapped or 0
        self.Primary.DefaultClip = 30
        self.Clapped = 0
        timer.Simple(5, function() self.Reloaded = true end)
        self:SetNextPrimaryFire(CurTime() + 5)
    end
end

function SWEP:Think()
end

function SWEP:SecondaryAttack()
end