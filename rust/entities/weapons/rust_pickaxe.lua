AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_iron_pickaxe.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_iron_pickaxe.mdl"
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
    self:EmitSound("tools/rock_swing.mp3")
    self:SendWeaponAnim(ACT_VM_SWINGMISS)
    self.delay = CurTime() + 0.1
    self:SetNextPrimaryFire(CurTime() + 1.2)
    self.Clicked = true
    timer.Simple(1, function() self.Clicked = false end)
end

function SWEP:Think()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    if self.delay < CurTime() then
        self.delay = CurTime() + 0.1
        local tr = pl:GetEyeTrace()
        if self.Clicked == true and tr.Hit then
            local hitDist = pl:GetPos():Distance(tr.HitPos)
            local ent = tr.Entity
            -- Check if we hit something within range
            if hitDist <= 70 and IsValid(ent) then
                local findtwig = string.find(ent:GetModel() or "", "twig")
                local damage = math.random(1, 6)
                if findtwig then damage = 25 end
                -- Hit the entity
                self:ShootBullet(damage, 1, 0, "", 0, 1)
                self:SendWeaponAnim(ACT_VM_SWINGHIT)
                self.Clicked = false
            elseif hitDist <= 70 then
                -- Hit within close range (world/props)
                self:ShootBullet(math.random(1, 6), 1, 0, "", 0, 1)
                self:SendWeaponAnim(ACT_VM_SWINGHIT)
                self.Clicked = false
            end
        end
    end
end

function SWEP:SecondaryAttack()
end