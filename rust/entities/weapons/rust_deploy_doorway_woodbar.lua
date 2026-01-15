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
        local ent = ents.Create("sent_woodbarricade")
        if not IsValid(ent) then return end
        local targetPos = tr.HitPos + tr.HitNormal * 2
        ent:SetPos(targetPos)
        ent:Spawn()
        ent:Activate()
        ent:SetSocket(true)
        ent:SetAngles(Angle(0,self:GetAngles().y - 180,0))
        ply:CountRemoveInventoryItem("Wood", 30)
        if class == "sent_ceiling" then
            ent:PhysicsInit(SOLID_VPHYSICS)
            ent:SetMoveType(MOVETYPE_VPHYSICS)
            ent:SetSolid(SOLID_VPHYSICS)
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then phys:EnableMotion(false) end
        end

        ply:RemoveInventoryItem("rust_deploy_doorway_woodbar")
        ply:EmitSound("farming/furnace_deploy.wav")
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
            self.PreviewEnt:SetModel("models/deployable/wooden_barricade.mdl")
        end
        return self.PreviewEnt
    end

    function SWEP:Think()
        local ent = self:GetPreviewEnt()
        if not IsValid(ent) then return end
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        local tr = ply:GetEyeTrace()
        if not tr.Hit then
            ent:SetNoDraw(true)
            return
        end

        local targetPos = tr.HitPos + tr.HitNormal * 2
        ent:SetPos(targetPos)
        ent:SetAngles(Angle(0,self:GetAngles().y - 180,0))
        if targetAng then ent:SetAngles(Angle(0, targetAng, 0)) end
        ent:SetRenderMode(RENDERMODE_TRANSALPHA)
        ent:SetNoDraw(false)
    end

    function SWEP:Holster()
        local ent = self:GetPreviewEnt()
        if IsValid(ent) then
            ent:Remove()
            ent = nil
        end
        return true
    end

    function SWEP:Deploy()
        return true
    end
end