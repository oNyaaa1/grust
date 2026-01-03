AddCSLuaFile()
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
SWEP.Occupied = {}
sAndbox.Selected = "sent_foundation"
local ENTITY = FindMetaTable("Entity")
function ENTITY:GetSocket()
    return self:GetNWBool("Socket")
end

if SERVER then
    util.AddNetworkString("gRust_ServerModel_new")
    util.AddNetworkString("gRust_ServerModel")
    function SWEP:Initialize()
        self:SetHoldType("normal")
        self.delay = 0
        self.Clicked = false
    end

    net.Receive("gRust_ServerModel_new", function() end)
    net.Receive("gRust_ServerModel", function()
        local str = net.ReadString()
        sAndbox.Selected = str
    end)

    function SWEP:ValidPosition(enzt)
        if not IsValid(enzt) then return false end
        local pos = enzt:GetPos()
        local trace = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 100),
            filter = enzt,
            mask = MASK_SOLID_BRUSHONLY
        })

        local groundHeight = trace.HitPos.z
        local distanceAboveGround = pos.z - groundHeight
        if distanceAboveGround > 100 then return false end
        return true
    end

    local function IsValidSpot(ent, vec)
        local posx = math.Round(vec.x)
        local posy = math.Round(vec.y)
        if posx ~= math.Round(ent:GetPos().x) and posy ~= math.Round(ent:GetPos().y) then return false end
        return true
    end

    function ENTITY:SetSocket(bool)
        self:SetNWBool("Socket", bool)
    end

    function SWEP:PrimaryAttack()
        local pl = self:GetOwner()
        if not IsValid(pl) then return end
        pl:SetAnimation(PLAYER_ATTACK1)
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        local tr = ply:GetEyeTrace()
        local selectz = sAndbox.Selected
        local scripted_ent = scripted_ents.Get(selectz or "sent_foundation")
        if sAndbox.Selected == "sent_door" then scripted_ent.Models = "models/deployable/wooden_door.mdl" end
        local ent = ents.Create(selectz or "sent_foundation")
        ent:SetModel(scripted_ent.Models)
        local pos = ply:GetPos():Distance(tr.HitPos)
        local newpos = pos - 120
        local ent_ground = ply:GetGroundEntity()
        local pos2, anglez = ent:FindSocketAdvanced(ply, selectz or "sent_foundation")
        local finalpos = tr.HitPos + tr.HitNormal * newpos
        local newpos2 = IsValid(ent_ground) and ent_ground:GetPos() + pos2 or nil
        if IsValid(ent_ground) and ent_ground ~= nil or sAndbox.Selected == "sent_ceiling" then
            ent:SetPos(newpos2)
            if anglez then ent:SetAngles(Angle(0, anglez, 0)) end
        elseif pos >= 128 and pos < 167 then
            ent:SetPos(finalpos)
            constraint.Weld(ent, game.GetWorld(), 0, 0, 0, true, true)
            pl:EmitSound("building/hammer_saw_1.wav")
        end

        if sAndbox.Selected == "sent_door" or sAndbox.Selected == "sent_ceiling" or self:ValidPosition(ent) then
            ent:Spawn()
            ent:Activate()
            ent:SetSocket(true)
            constraint.Weld(ent, game.GetWorld(), 0, 0, 0, true, true)
            pl:EmitSound("building/hammer_saw_1.wav")
        end

        if not self:ValidPosition(ent) then ent:Remove() end
    end

    function SWEP:SecondaryAttack()
        local pl = self:GetOwner()
        if IsValid(pl) then pl:ConCommand("+azrm_showmenu") end
        return true
    end
else
    sAndbox.Occupied = {}
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
            local ply = self:GetOwner()
            if not IsValid(ply) then return end
            local tr = ply:GetEyeTrace()
            local pos = ply:GetPos():Distance(tr.HitPos)
            local newpos = pos - 120
            local finalpos = tr.HitPos + tr.HitNormal * newpos
            self.Entity:SetPos(finalpos)
        end

        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        local tr = ply:GetEyeTrace()
        local scripted_ent = scripted_ents.Get(sAndbox.Selected or "sent_foundation")
        if sAndbox.Selected == "sent_door" then scripted_ent.Models = "models/deployable/wooden_door.mdl" end
        self.Entity:SetModel(scripted_ent.Models)
        local pos = ply:GetPos():Distance(tr.HitPos)
        local newpos = pos - 120
        local ent_ground = ply:GetGroundEntity()
        local pos2, anglez = self.Entity:FindSocketAdvanced(ply, sAndbox.Selected or "sent_foundation")
        local newpos2 = IsValid(ent_ground) and ent_ground:GetPos() + pos2 or nil
        local finalpos = tr.HitPos + tr.HitNormal * newpos
        if IsValid(ent_ground) and ent_ground ~= nil or sAndbox.Selected == "sent_ceiling" then
            if newpos2 ~= nil then self.Entity:SetPos(newpos2) end
            if anglez then self.Entity:SetAngles(Angle(0, anglez, 0)) end
        elseif pos >= 128 and pos < 167 and not IsValid(tr.Entity) and finalpos ~= Vector(0, 0, 0) then
            self.Entity:SetPos(finalpos)
        end

        if tr.Entity:GetSocket() == true then self.Entity:Remove() end
        if self:ValidPosition(self.Entity) or sAndbox.Selected == "sent_ceiling" then
            self.Entity:SetColor(Color(0, 0, 255))
        else
            self.Entity:SetColor(Color(255, 0, 0))
        end
    end
end