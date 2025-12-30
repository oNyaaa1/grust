AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_rock.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_rock.mdl"
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
function SWEP:Initialize()
    self:SetHoldType("melee")
    self.delay = 0
    self.Clicked = false
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    if SERVER and pl.ConsumeDurabilityForWeapon then pl:ConsumeDurabilityForWeapon(self) end
    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("tools/rock_swing.mp3")
    self:SendWeaponAnim(ACT_VM_SWINGMISS)
    self.delay = CurTime() + 0.5
    self:SetNextPrimaryFire(CurTime() + 1.5)
    local tr = pl:GetEyeTrace()
    self.Clicked = true
    timer.Simple(0.5, function() self.Clicked = false end)
end

function SWEP:Think()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    if self.delay < CurTime() then
        self.delay = CurTime() + 0.5
        local tr = pl:GetEyeTrace()
        if pl:GetPos():Distance(tr.HitPos) <= 10 and self.Clicked == true then
            local ent = tr.Entity
            local findtwig = string.find(ent:GetModel(), "twig")
            local damage = math.random(1, 6)
            if findtwig then damage = 25 end
            if ent ~= NULL then self:ShootBullet(damage, 1, 0, "", 0, 1) end
            self:SendWeaponAnim(ACT_VM_SWINGHIT)
            self.Clicked = false
        end
    end
end

function SWEP:SecondaryAttack()
end