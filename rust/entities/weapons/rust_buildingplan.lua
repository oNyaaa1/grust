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
        
        -- Check for obstructions for ceiling
        if sAndbox.Selected == "sent_ceiling" then
            local mins, maxs = enzt:GetCollisionBounds()
            local traceData = {
                start = pos,
                endpos = pos,
                mins = mins,
                maxs = maxs,
                filter = enzt
            }
            local trace = util.TraceHull(traceData)
            if trace.Hit then return false end
        end
        
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

    -- Check if socket position is already occupied
    function SWEP:IsSocketOccupied(pos, radius)
        radius = radius or 10  -- Much smaller radius to check exact position
        local nearby = ents.FindInSphere(pos, radius)
        for _, ent in ipairs(nearby) do
            if IsValid(ent) and ent:GetSocket() and ent:GetClass() ~= "worldspawn" then
                -- Check if positions are very close (same socket)
                local dist = ent:GetPos():Distance(pos)
                if dist < 20 then
                    return true
                end
            end
        end
        return false
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
        
        -- Check if placing a wall without a foundation
        local isWall = selectz == "sent_wall" or string.find(string.lower(selectz or ""), "wall")
        if isWall then
            local hasFoundation = false
            -- Check if looking at a socketed entity that is NOT a wall
            if IsValid(tr.Entity) and tr.Entity:GetSocket() then
                local lookingAtWall = tr.Entity:GetClass() == "sent_wall" or string.find(string.lower(tr.Entity:GetClass() or ""), "wall")
                if not lookingAtWall then
                    hasFoundation = true
                end
            end
            -- Check if standing on a socketed entity
            if IsValid(ent_ground) and ent_ground:GetSocket() then
                hasFoundation = true
            end
            
            if not hasFoundation then
                ent:Remove()
                return
            end
        end
        
        -- Check if looking at an entity with sockets
        local targetPos = nil
        if IsValid(tr.Entity) and tr.Entity:GetSocket() then
            -- Check if looking at a wall when trying to place a wall
            local lookingAtWall = tr.Entity:GetClass() == "sent_wall" or string.find(string.lower(tr.Entity:GetClass() or ""), "wall")
            if not (isWall and lookingAtWall) then
                -- Attach to the entity being looked at
                local attachPos, attachAng = ent:FindSocketAdvanced(ply, selectz or "sent_foundation", tr.Entity)
                if attachPos then
                    targetPos = tr.Entity:GetPos() + attachPos
                    ent:SetPos(targetPos)
                    if attachAng then ent:SetAngles(Angle(0, attachAng, 0)) end
                end
            end
        elseif IsValid(ent_ground) and ent_ground:GetSocket() then
            targetPos = newpos2
            ent:SetPos(newpos2)
            if anglez then ent:SetAngles(Angle(0, anglez, 0)) end
        elseif sAndbox.Selected == "sent_ceiling" then
            -- For ceiling, place directly above the ground entity
            if IsValid(ent_ground) and ent_ground:GetSocket() then
                targetPos = ent_ground:GetPos() + Vector(0, 0, 125)
                ent:SetPos(targetPos)
            end
        elseif pos >= 128 and pos < 167 and not isWall then
            -- Only allow non-wall entities to be placed on ground
            targetPos = finalpos
            ent:SetPos(finalpos)
            constraint.Weld(ent, game.GetWorld(), 0, 0, 0, true, true)
            pl:EmitSound("building/hammer_saw_1.wav")
        end

        -- Only spawn if position is valid and socket is not occupied
        if targetPos and self:IsSocketOccupied(targetPos) then
            ent:Remove()
            return
        end
        
        -- Don't spawn if no valid target position
        if not targetPos then
            ent:Remove()
            return
        end

        if sAndbox.Selected == "sent_door" or sAndbox.Selected == "sent_ceiling" or (self:ValidPosition(ent) and not isWall) then
            ent:Spawn()
            ent:Activate()
            ent:SetSocket(true)
            if sAndbox.Selected == "sent_ceiling" then
                ent:PhysicsInit(SOLID_VPHYSICS)
                ent:SetMoveType(MOVETYPE_VPHYSICS)
                ent:SetSolid(SOLID_VPHYSICS)
                local phys = ent:GetPhysicsObject()
                if IsValid(phys) then
                    phys:EnableMotion(false)
                end
            end
            constraint.Weld(ent, game.GetWorld(), 0, 0, 0, true, true)
            pl:EmitSound("building/hammer_saw_1.wav")
        elseif isWall and (IsValid(tr.Entity) and tr.Entity:GetSocket() or IsValid(ent_ground) and ent_ground:GetSocket()) then
            -- Special case for walls - only spawn if attached to foundation
            ent:Spawn()
            ent:Activate()
            ent:SetSocket(true)
            constraint.Weld(ent, game.GetWorld(), 0, 0, 0, true, true)
            pl:EmitSound("building/hammer_saw_1.wav")
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
        
        -- Check for obstructions for ceiling
        if sAndbox.Selected == "sent_ceiling" then
            local mins, maxs = enzt:GetCollisionBounds()
            local traceData = {
                start = pos,
                endpos = pos,
                mins = mins,
                maxs = maxs,
                filter = enzt
            }
            local trace = util.TraceHull(traceData)
            if trace.Hit then return false end
        end
        
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

    -- Client-side check for socket occupation
    function SWEP:IsSocketOccupied(pos, radius)
        radius = radius or 10  -- Much smaller radius to check exact position
        local nearby = ents.FindInSphere(pos, radius)
        for _, ent in ipairs(nearby) do
            if IsValid(ent) and ent:GetSocket() and ent:GetClass() ~= "worldspawn" then
                -- Check if positions are very close (same socket)
                local dist = ent:GetPos():Distance(pos)
                if dist < 20 then
                    return true
                end
            end
        end
        return false
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
        
        local isLookingAtSocket = IsValid(tr.Entity) and tr.Entity:GetSocket()
        local isWall = sAndbox.Selected == "sent_wall" or string.find(string.lower(sAndbox.Selected or ""), "wall")
        local hasFoundation = false
        
        if isWall then
            -- Check if looking at a socketed entity that is NOT a wall
            if isLookingAtSocket then
                local lookingAtWall = tr.Entity:GetClass() == "sent_wall" or string.find(string.lower(tr.Entity:GetClass() or ""), "wall")
                if not lookingAtWall then
                    hasFoundation = true
                end
            end
            -- Check if standing on a socketed entity
            if IsValid(ent_ground) and ent_ground:GetSocket() then
                hasFoundation = true
            end
            
            -- Hide preview if wall has no foundation
            if not hasFoundation then
                self.Entity:SetNoDraw(true)
                return
            else
                self.Entity:SetNoDraw(false)
            end
        else
            self.Entity:SetNoDraw(false)
        end
        
        -- Check if looking at an entity with sockets
        if isLookingAtSocket then
            -- Check if looking at a wall when trying to place a wall
            local lookingAtWall = tr.Entity:GetClass() == "sent_wall" or string.find(string.lower(tr.Entity:GetClass() or ""), "wall")
            if not (isWall and lookingAtWall) then
                -- Attach preview to the entity being looked at
                local attachPos, attachAng = self.Entity:FindSocketAdvanced(ply, sAndbox.Selected or "sent_foundation", tr.Entity)
                if attachPos then
                    self.Entity:SetPos(tr.Entity:GetPos() + attachPos)
                    if attachAng then self.Entity:SetAngles(Angle(0, attachAng, 0)) end
                end
            end
        elseif IsValid(ent_ground) and ent_ground ~= nil or sAndbox.Selected == "sent_ceiling" then
            if sAndbox.Selected == "sent_ceiling" and IsValid(ent_ground) and ent_ground:GetSocket() then
                -- For ceiling, place directly above the ground entity center
                self.Entity:SetPos(ent_ground:GetPos() + Vector(0, 0, 125))
            elseif newpos2 ~= nil then
                self.Entity:SetPos(newpos2)
            end
            if anglez then self.Entity:SetAngles(Angle(0, anglez, 0)) end
        elseif pos >= 128 and pos < 167 and finalpos ~= Vector(0, 0, 0) then
            self.Entity:SetPos(finalpos)
        end
        
        -- Update color based on socket occupation
        local targetPos = self.Entity:GetPos()
        
        if self:IsSocketOccupied(targetPos) then
            self.Entity:SetColor(Color(255, 0, 0))
        elseif isLookingAtSocket then
            -- Check if FindSocketAdvanced returned valid position
            local attachPos = self.Entity:FindSocketAdvanced(ply, sAndbox.Selected or "sent_foundation", tr.Entity)
            if attachPos then
                self.Entity:SetColor(Color(0, 0, 255))
            else
                self.Entity:SetColor(Color(255, 0, 0))
            end
        elseif sAndbox.Selected == "sent_ceiling" then
            -- Check for ceiling collision
            if self:ValidPosition(self.Entity) then
                self.Entity:SetColor(Color(0, 0, 255))
            else
                self.Entity:SetColor(Color(255, 0, 0))
            end
        elseif self:ValidPosition(self.Entity) then
            self.Entity:SetColor(Color(0, 0, 255))
        else
            self.Entity:SetColor(Color(255, 0, 0))
        end
    end
end