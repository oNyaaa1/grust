AddCSLuaFile()
if CLIENT then
    SWEP.Author = "TheFreeCode"
    SWEP.Slot = 3
    SWEP.SlotPos = 0
    SWEP.IconLetter = "b"
    killicon.AddFont("hands_hammer", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.PrintName = "Hammer"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "gRust"
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/darky_m/rust/c_hammer.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_hammer.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.HoldType = "ar2"
SWEP.LoweredHoldType = "passive"
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.002
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.08
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(-6.6, -15, 2.6)
SWEP.IronSightsAng = Vector(2.6, -1, 0)
SWEP.HasIron = false
SWEP.DrawAmmo = false
function SWEP:Initialize()
    self:SetHoldType("melee2")
end

function SWEP:PrimaryAttack()
    self:SendWeaponAnim( ACT_VM_MISSCENTER ) 
    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(true) end
    self:SetNextSecondaryFire(CurTime() + 1)
    self:GetOwner():ConCommand("+azrm_showmenu")
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(false) end
end