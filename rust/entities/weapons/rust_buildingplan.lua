AddCSLuaFile()
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
if SERVER then
    util.AddNetworkString("gRust_ServerModel_new")
    util.AddNetworkString("gRust_ServerModel")
    function SWEP:Initialize()
        self:SetHoldType("normal")
        self.delay = 0
        self.Clicked = false
    end

    net.Receive("gRust_ServerModel_new", function() end)
    net.Receive("gRust_ServerModel", function() end)
    function SWEP:ValidPosition(enzt)
        if not IsValid(enzt) then return false end
        local pos = enzt:GetPos()
        local trace = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 100),
            filter = enzt,
            mask = MASK_SOLID_BRUSHONLY
        })

        if not trace.Hit then return false end
        local normalZ = trace.HitNormal.z
        if normalZ < 0.9 then return false end
        local groundHeight = trace.HitPos.z
        local distanceAboveGround = pos.z - groundHeight
        if distanceAboveGround > 50 then return false end
        return true
    end

    function SWEP:PrimaryAttack()
        local pl = self:GetOwner()
        if not IsValid(pl) then return end
        pl:SetAnimation(PLAYER_ATTACK1)
        self:EmitSound("building/hammer_saw_1.wav")
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        local tr = ply:GetEyeTrace()
        local scripted_ent = scripted_ents.Get(sAndbox.Selected or "sent_foundation")
        local ent = ents.Create(sAndbox.Selected or "sent_foundation")
        ent:SetModel(scripted_ent.Models)
        local pos = ply:GetPos():Distance(tr.HitPos)
        local newpos = pos - 120
        local ent_ground = ply:GetGroundEntity()
        local pos2 = ent:FindSocketAdvanced(ply)
        if IsValid(ent_ground) and ent_ground ~= nil then
            ent:SetPos(ent_ground:GetPos() + pos2)
        elseif pos >= 128 and pos < 167 then
            ent:SetPos(tr.HitPos + tr.HitNormal * newpos)
        end
        if self:ValidPosition(ent) and self:GetOwner():GetPos():Distance(ent:GetPos()) <= 170 then
            ent:Spawn()
            ent:Activate()
        else
            ent:Remove()
        end
    end

    function SWEP:SecondaryAttack()
        local pl = self:GetOwner()
        if IsValid(pl) then pl:ConCommand("+azrm_showmenu") end
        return true
    end
else
    function SWEP:PrimaryAttack()
        return true
    end

    function SWEP:SecondaryAttack()
        return true
    end

    function SWEP:Initialize()
    end

    function SWEP:ValidPosition(enzt)
        if not IsValid(enzt) then return false end
        local pos = enzt:GetPos()
        local trace = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 100),
            filter = enzt,
            mask = MASK_SOLID_BRUSHONLY
        })

        if not trace.Hit then return false end
        local normalZ = trace.HitNormal.z
        if normalZ < 0.9 then return false end
        local groundHeight = trace.HitPos.z
        local distanceAboveGround = pos.z - groundHeight
        if distanceAboveGround > 50 then return false end
        return true
    end

    function SWEP:Holster()
        if IsValid(self.Entity) then self.Entity:Remove() end
    end

    function SWEP:Deploy()
        if not ent or ent == nil then
            self.Entity = ents.CreateClientProp()
            self.Entity:Spawn()
        end
    end

    function SWEP:Think()
        if not IsValid(self.Entity) then
            self.Entity = ents.CreateClientProp()
            self.Entity:Spawn()
        end

        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        local tr = ply:GetEyeTrace()
        local scripted_ent = scripted_ents.Get(sAndbox.Selected or "sent_foundation")
        self.Entity:SetModel(scripted_ent.Models)
        local pos = ply:GetPos():Distance(tr.HitPos)
        local newpos = pos - 120
        local ent_ground = ply:GetGroundEntity()
        local pos2 = self.Entity:FindSocketAdvanced(ply)
        if IsValid(ent_ground) and ent_ground ~= nil then
            self.Entity:SetPos(ent_ground:GetPos() + pos2)
        elseif pos >= 128 and pos < 167 then
            self.Entity:SetPos(tr.HitPos + tr.HitNormal * newpos)
        end

        if self:ValidPosition(self.Entity) and self:GetOwner():GetPos():Distance(self.Entity:GetPos()) <= 170 then
            self.Entity:SetColor(Color(0, 0, 255))
        else
            self.Entity:SetColor(Color(255, 0, 0))
        end
    end
end