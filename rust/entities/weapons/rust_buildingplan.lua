AddCSLuaFile()
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
-- Your original global table name
sAndbox = sAndbox or {}
sAndbox.Selected = sAndbox.Selected or "sent_foundation"
local ENTITY = FindMetaTable("Entity")
function ENTITY:GetSocket()
    return self:GetNWBool("Socket", false)
end

function ENTITY:SetSocket(bool)
    self:SetNWBool("Socket", bool or false)
end

function SWEP:ValidPosition(ent)
    if not IsValid(ent) then return false end
    local pos = ent:GetPos()
    local mins, maxs = ent:GetCollisionBounds()
    -- 4 bottom corners in world space
    local corners = {pos + Vector(mins.x, mins.y, mins.z), pos + Vector(maxs.x, mins.y, mins.z), pos + Vector(mins.x, maxs.y, mins.z), pos + Vector(maxs.x, maxs.y, mins.z)}
    -- Special ceiling check (keep unchanged)
    if sAndbox.Selected ~= "sent_foundation" then return true end
    local hits = 0
    local requiredHits = 4 -- Change to 3 if you want to allow one corner overhanging (good for edges/cliffs)
    for _, corner in ipairs(corners) do
        local tr = util.TraceLine({
            start = corner + Vector(0, 0, 4), -- Start a bit higher to avoid self-blocking on edges/slopes
            endpos = corner - Vector(0, 0, 40), -- Much longer downward trace for cliffs/ledges/uneven terrain
            filter = ent,
            mask = MASK_SOLID_BRUSHONLY
        })

        if tr.Hit and tr.HitWorld then hits = hits + 1 end
    end
    return hits >= requiredHits
end

if SERVER then
    util.AddNetworkString("gRust_ServerModel_new")
    util.AddNetworkString("gRust_ServerModel")
    function SWEP:Initialize()
        self:SetHoldType("normal")
    end

    net.Receive("gRust_ServerModel", function(len, ply)
        local str = net.ReadString()
        if scripted_ents.Get(str) then sAndbox.Selected = str end
    end)

    function SWEP:IsSocketOccupied(pos, radius)
        radius = radius or 15
        for _, ent in pairs(ents.FindInSphere(pos, radius)) do
            if IsValid(ent) and ent:GetSocket() and ent:GetClass() ~= "worldspawn" then if ent:GetPos():Distance(pos) < 25 then return true end end
        end
        return false
    end

    function SWEP:PrimaryAttack()
        local ply = self:GetOwner()
        if ply.SafeZone then return end
        if not IsValid(ply) then return end
        local Count = ply:CountITEM("Wood")
        //if Count < 30 then return end
        ply:SetAnimation(PLAYER_ATTACK1)
        local tr = ply:GetEyeTrace()
        if not tr.Hit then return end
        local class = sAndbox.Selected or "sent_foundation"
        local sent = scripted_ents.Get(class)
        if not sent then return end
        local ent = ents.Create(class)
        if not IsValid(ent) then return end
        ent:SetModel(sent.Models or "")
        if class == "sent_door" then ent:SetModel("models/deployable/wooden_door.mdl") end
        local isWall = class == "sent_wall" or string.find(string.lower(class), "wall")
        local isDoorWay = class == "sent_doorway" or string.find(string.lower(class), "doorway")
        local groundEnt = ply:GetGroundEntity()
        local targetPos = nil
        local targetAng = nil
        -- Snap to looked-at socket
        if IsValid(tr.Entity) and tr.Entity:GetSocket() then
            local attachPos, attachAng = ent:FindSocketAdvanced(ply, class, tr.Entity)
            if attachPos then
                targetPos = tr.Entity:GetPos() + attachPos
                targetAng = attachAng or 0
            end
        end

        -- Snap to ground socket
        if not targetPos and IsValid(groundEnt) and groundEnt:GetSocket() then
            local attachPos, attachAng = ent:FindSocketAdvanced(ply, class)
            if attachPos then
                targetPos = groundEnt:GetPos() + attachPos
                targetAng = attachAng or 0
            end
        end

        -- Ceiling special placement
        if not targetPos and class == "sent_ceiling" and IsValid(groundEnt) and groundEnt:GetSocket() then targetPos = groundEnt:GetPos() + Vector(0, 0, 125) end
        -- Free ground placement (non-walls only)
        if not targetPos and not isWall and not isDoorWay then
            local dist = ply:GetPos():Distance(tr.HitPos)
            if dist >= 128 and dist < 167 then targetPos = tr.HitPos + tr.HitNormal * (dist - 120) end
        end

        if isDoorWay and not targetPos then
            SafeRemoveEntity(ent)
            return
        end

        if isWall and not targetPos then
            SafeRemoveEntity(ent)
            return
        end

        if not targetPos or self:IsSocketOccupied(targetPos) then
            SafeRemoveEntity(ent)
            return
        end

        ent:SetPos(targetPos)
        if targetAng then ent:SetAngles(Angle(0, targetAng, 0)) end
        -- Final 4-corner ground validation
        if not self:ValidPosition(ent) then
            SafeRemoveEntity(ent)
            return
        end

        ent:Spawn()
        ent:Activate()
        ent:SetSocket(true)
        ply:CountRemoveInventoryItem("Wood", 30)
        if class == "sent_ceiling" then
            ent:PhysicsInit(SOLID_VPHYSICS)
            ent:SetMoveType(MOVETYPE_VPHYSICS)
            ent:SetSolid(SOLID_VPHYSICS)
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then phys:EnableMotion(false) end
        end

        constraint.Weld(ent, game.GetWorld(), 0, 0, 0, true, true)
        ply:EmitSound("building/hammer_saw_1.wav")
        if sAndbox.SaveStructure then sAndbox.SaveStructure() end
    end

    function SWEP:SecondaryAttack()
        local ply = self:GetOwner()
        if IsValid(ply) then ply:ConCommand("+azrm_showmenu") end
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
        end
        return self.PreviewEnt
    end

    function SWEP:IsSocketOccupied(pos, radius)
        radius = radius or 15
        for _, ent in pairs(ents.FindInSphere(pos, radius)) do
            if IsValid(ent) and ent:GetSocket() and ent:GetClass() ~= "worldspawn" then if ent:GetPos():Distance(pos) < 25 then return true end end
        end
        return false
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

        local class = sAndbox.Selected or "sent_foundation"
        local sent = scripted_ents.Get(class)
        if not sent then
            ent:SetNoDraw(true)
            return
        end

        local model = sent.Models or ""
        if class == "sent_door" then model = "models/deployable/wooden_door.mdl" end
        ent:SetModel(model)
        local isWall = class == "sent_wall" or string.find(string.lower(class), "wall")
        local groundEnt = ply:GetGroundEntity()
        local targetPos = nil
        local targetAng = nil
        if IsValid(tr.Entity) and tr.Entity:GetSocket() then
            local attachPos, attachAng = ent:FindSocketAdvanced(ply, class, tr.Entity)
            if attachPos then
                targetPos = tr.Entity:GetPos() + attachPos
                targetAng = attachAng
            end
        end

        if not targetPos and IsValid(groundEnt) and groundEnt:GetSocket() then
            local attachPos, attachAng = ent:FindSocketAdvanced(ply, class)
            if attachPos then
                targetPos = groundEnt:GetPos() + attachPos
                targetAng = attachAng
            end
        end

        if not targetPos and class == "sent_ceiling" and IsValid(groundEnt) and groundEnt:GetSocket() then targetPos = groundEnt:GetPos() + Vector(0, 0, 125) end
        if not targetPos and not isWall then
            local dist = ply:GetPos():Distance(tr.HitPos)
            if dist >= 128 and dist < 167 then targetPos = tr.HitPos + tr.HitNormal * (dist - 120) end
        end

        -- Hide preview if wall has no valid attachment
        if not targetPos or (isWall and not (IsValid(tr.Entity) and tr.Entity:GetSocket() or IsValid(groundEnt) and groundEnt:GetSocket())) then
            ent:SetNoDraw(true)
            return
        end

        ent:SetPos(targetPos)
        if targetAng then ent:SetAngles(Angle(0, targetAng, 0)) end
        -- Color: cyan = valid, red = invalid
        local valid = not self:IsSocketOccupied(targetPos) and self:ValidPosition(ent)
        ent:SetColor(valid and Color(0, 255, 255, 200) or Color(255, 0, 0, 200))
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