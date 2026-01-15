AddCSLuaFile()
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
-- Your original global table name
if SERVER then
    function SWEP:IsSocketOccupied(pos, radius)
        radius = radius or 15
        for _, ent in pairs(ents.FindInSphere(pos, radius)) do
            if IsValid(ent) and ent:GetSocket() and ent:GetClass() ~= "worldspawn" and ent:GetClass() ~= "sent_way_door_spanner" then if ent:GetPos():Distance(pos) < 25 then return true end end
        end
        return false
    end

    function SWEP:PrimaryAttack()
        local ply = self:GetOwner()
        if ply.SafeZone then return end
        if not IsValid(ply) then return end
        ply:SetAnimation(PLAYER_ATTACK1)
        local tr = ply:GetEyeTrace()
        if not tr.Hit then return end
        local ent = ents.Create("sent_door_dd_wood")
        if not IsValid(ent) then return end
        local targetPos = nil
        local targetAng = nil
        local groundEnt = ply:GetGroundEntity()
        if not targetPos and IsValid(groundEnt) and groundEnt:GetSocket() then
            local attachPos, attachAng = ent:FindSocketAdvanced(ply, "sent_door_dd_wood")
            if attachPos then
                targetPos = groundEnt:GetPos() + attachPos
                targetAng = attachAng or 0
            end
        end

        if not targetPos or self:IsSocketOccupied(targetPos) then
            SafeRemoveEntity(ent)
            return
        end

        ent:SetPos(targetPos)
        ent:SetAngles(Angle(0, targetAng, 0))
        ent:Spawn()
        ent:Activate()
        ent:SetSocket(true)
        local phys = ent:GetPhysicsObject()
        --/if IsValid(phys) then phys:EnableMotion(false) end
        ply:CountRemoveInventoryItem("Wood", 30)
        if class == "sent_ceiling" then
            ent:PhysicsInit(SOLID_VPHYSICS)
            ent:SetMoveType(MOVETYPE_VPHYSICS)
            ent:SetSolid(SOLID_VPHYSICS)
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then phys:EnableMotion(false) end
        end

        ply:RemoveInventoryItem("rust_deploy_metaldd")
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
            self.PreviewEnt:SetModel("models/deployable/wood_double_door.mdl")
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

        local targetPos = nil
        local groundEnt = ply:GetGroundEntity()
        if not targetPos and IsValid(groundEnt) and groundEnt:GetSocket() then
            local attachPos, attachAng = ent:FindSocketAdvanced(ply, "sent_door_dd_wood")
            if attachPos then
                targetPos = groundEnt:GetPos() + attachPos
                targetAng = attachAng or 0
            end
        end

        if targetPos == nil then return end
        ent:SetPos(targetPos)
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