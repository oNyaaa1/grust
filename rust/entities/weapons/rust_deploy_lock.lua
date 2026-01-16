AddCSLuaFile()
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
-- Your original global table name
if SERVER then
    function SWEP:PrimaryAttack()
        local ply = self:GetOwner()
        if ply.SafeZone then return end
        if not IsValid(ply) then return end
        ply:SetAnimation(PLAYER_ATTACK1)
        local tr = ply:GetEyeTrace()
        if not tr.Hit then return end
        local strDoor = string.find(tr.Entity:GetClass(), "door")
        if not strDoor then return end
        ply:EmitSound("doors/keylock_lock.wav")
        tr.Entity.doorLock = ents.Create("sent_lock")
        tr.Entity.doorLock:SetModel("models/deployable/key_lock.mdl")
        tr.Entity.doorLock:SetPos(tr.Entity:GetPos() + tr.Entity:GetUp() * 38 + tr.Entity:GetRight() * 0 + tr.Entity:GetForward() * 46)
        tr.Entity.doorLock:SetAngles(tr.Entity:GetAngles())
        tr.Entity.doorLock:Spawn()
        tr.Entity.doorLock:Activate()
        tr.Entity.doorLock:SetParent(tr.Entity)
        ply:RemoveInventoryItem("rust_deploy_lock")
    end

    function SWEP:SecondaryAttack()
        return true
    end
else -- CLIENT
    function SWEP:Initialize()
        self.PreviewEnt = nil
    end

    function SWEP:PrimaryAttack()
        return true
    end

    function SWEP:SecondaryAttack()
        return true
    end

    function SWEP:GetPreviewEnt()
        if not IsValid(self.PreviewEnt) then
            self.PreviewEnt = ents.CreateClientProp()
            self.PreviewEnt:Spawn()
            self.PreviewEnt:SetModel("models/deployable/key_lock.mdl")
        end
        return self.PreviewEnt
    end

    function SWEP:Think()
        local ent = self:GetPreviewEnt()
        if not IsValid(ent) then return end
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        local tr = ply:GetEyeTrace()
        --if not string.find(tr.Entity:GetClass(), "sent_door*") then
        --    ent:SetNoDraw(true)
        --    return
        -- end
        ent:SetAngles(tr.Entity:GetAngles() + Angle(0, 0, 0))
        ent:SetPos(tr.Entity:GetPos() + tr.Entity:GetUp() * 38 + tr.Entity:GetRight() * 0 + tr.Entity:GetForward() * 46)
        if targetAng then tr.Entity:SetAngles(Angle(0, targetAng, 0)) end
        ent:SetRenderMode(RENDERMODE_TRANSALPHA)
        ent:SetNoDraw(false)
    end

    function SWEP:Holster()
        local ent = self:GetPreviewEnt()
        if IsValid(ent) then
            ent:Remove()
            ent = nil
        end
    end

    function SWEP:Deploy()
        return true
    end
end