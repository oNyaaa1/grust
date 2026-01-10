game.AddDecal("TreeMarker", "decals/decal_xspray_a_red")
local function MineWoodex(ply, item, amount, ent)
    local me = ply:ExistingInventoryItem({
        Weapon = item
    }, amount * 2 or 0)

    if me then return end
    ply:AddInventoryItem({
        Weapon = item,
    }, true, amount or 0)
end

local function MineWood(ply, item, amount, ent)
    local me = ply:ExistingInventoryItem({
        Weapon = item
    }, amount or 0)

    if me then return end
    ply:AddInventoryItem({
        Weapon = item,
    }, true, amount or 0)
end

local function MakeTreeFall(ent)
    if not IsValid(ent) then return end
    local treePos = ent:GetPos()
    local treeAngles = ent:GetAngles()
    local treeModel = ent:GetModel()
    ent:SetMoveType(MOVETYPE_VPHYSICS)
    ent:SetSolid(SOLID_VPHYSICS)
    ent:PhysicsInit(SOLID_VPHYSICS)
    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(800)
        local fallDirection = Angle(0, math.random(0, 360), 0):Forward()
        fallDirection.z = 0
        fallDirection:Normalize()
        local torque = Vector(fallDirection.y, -fallDirection.x, 0) * 3000
        phys:ApplyTorqueCenter(torque)
        local push = fallDirection * 100
        push.z = -50
        phys:ApplyForceCenter(push)
        phys:SetMass(800)
    end

    ent.treeFallen = true
    timer.Simple(3, function()
        if IsValid(ent) then
            local alpha = 255
            local fadeTimer = "tree_fade_" .. ent:EntIndex()
            timer.Create(fadeTimer, 0.1, 40, function()
                if IsValid(ent) then
                    alpha = alpha - 6.375
                    ent:SetColor(Color(255, 255, 255, math.max(0, alpha)))
                    ent:SetRenderMode(RENDERMODE_TRANSALPHA)
                    if alpha <= 0 then
                        timer.Remove(fadeTimer)
                        ent:Remove()
                    end
                else
                    timer.Remove(fadeTimer)
                end
            end)
        end
    end)

    timer.Simple(math.random(600, 900), function()
        local newTree = ents.Create("rust_trees")
        if IsValid(newTree) then
            newTree:SetModel(treeModel)
            newTree:SetPos(treePos)
            newTree:SetAngles(treeAngles)
            newTree:Spawn()
            newTree:Activate()
            newTree.treeHealth = nil
            newTree.treeHits = nil
            newTree.treeFallen = false
        end
    end)
end

local WOOD_WEAPONS = {
    ["rust_e_rock"] = {
        mult = 1
    },
    ["tfa_rustalpha_stone_hatchet"] = {
        mult = 1.3
    },
    ["tfa_rustalpha_hatchet"] = {
        mult = 1.8
    }
}

hook.Add("EntityTakeDamage", "Wood", function(targ, dmg)
    local ply = dmg:GetAttacker()
    if not IsValid(ply) or not ply:IsPlayer() then return end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end
    local class = wep:GetClass()
    local realwep = WOOD_WEAPONS[class]
    if realwep == nil then return end
    local plytr = ply:GetEyeTrace()
    if plytr.Entity:GetMaterialType() ~= MAT_WOOD then return end
    -- First, get the initial hit position from player's trace
    local startPos = plytr.HitPos
    -- Get the tree's center position
    local tree = plytr.Entity
    local treeCenter = tree:GetPos()
    -- Calculate the offset from tree center to hit position
    local offset = startPos - treeCenter
    local radius = offset:Length2D() -- Distance from tree center in 2D space
    -- Get the starting angle from the player's hit position
    local startAngle = math.atan2(offset.y, offset.x)
    -- Initialize rotation progress and starting angle if not set
    if not targ.RotationProgress then targ.RotationProgress = 0 end
    if not targ.StartAngle then targ.StartAngle = startAngle end
    -- Increment the angle to rotate left (counterclockwise)
    local angleIncrement = math.rad(30) -- 30 degrees per hit, adjust as needed
    local currentAngle = targ.StartAngle + targ.RotationProgress
    -- Calculate position at current angle
    local x = treeCenter.x + math.cos(currentAngle) * radius
    local y = treeCenter.y + math.sin(currentAngle) * radius
    local z = startPos.z -- Keep the same height as original hit
    local decalPos = Vector(x, y, z)
    -- Trace from decal position toward tree center to get proper surface normal
    local decalTrace = util.TraceLine({
        start = decalPos,
        endpos = Vector(treeCenter.x, treeCenter.y, z), -- Keep Z the same
        filter = ply
    })

    if not targ.NotDecal then
        targ.NotDecal = true
        util.Decal("TreeMarker", startPos + plytr.HitNormal * 2, startPos - plytr.HitNormal * 2)
    end

    if not targ.Healthz then targ.Healthz = 200 end
    -- If there's no marker placed yet, accept any hit
    if not targ.LastDecalPos then
        if decalTrace.Hit then
            targ.Healthz = targ.Healthz - dmg:GetDamage() * 3
            MineWoodex(ply, "Wood", 12, targ)
            targ:EmitSound("farming/tree_spray.wav")
            targ:RemoveAllDecals()
            util.Decal("TreeMarker", decalTrace.HitPos + decalTrace.HitNormal, decalTrace.HitPos - decalTrace.HitNormal, game.GetWorld())
            targ.LastDecalPos = decalTrace.HitPos
            targ.RotationProgress = targ.RotationProgress + angleIncrement
        end
    else
        -- Marker exists, check if player hit close enough
        if decalTrace.Hit then
            targ.Healthz = targ.Healthz - dmg:GetDamage() * 3
            local hitDistance = startPos:Distance(decalTrace.HitPos)
            local maxHitDistance = 20 -- Adjust this value to make it easier/harder to hit
            if hitDistance <= maxHitDistance then
                MineWoodex(ply, "Wood", 12, targ)
                -- Player hit the marker!
                targ:EmitSound("farming/tree_spray.wav")
                targ:RemoveAllDecals()
                util.Decal("TreeMarker", decalTrace.HitPos + decalTrace.HitNormal, decalTrace.HitPos - decalTrace.HitNormal, game.GetWorld())
                targ.LastDecalPos = decalTrace.HitPos
                targ.RotationProgress = targ.RotationProgress + angleIncrement
            end
        end
    end

    targ.Healthz = targ.Healthz - dmg:GetDamage()
    print(targ.Healthz)
    if targ.Healthz <= 0 then MakeTreeFall(targ) end
    --targ:EmitSound("farming/tree_spray.wav")
    --targ.strongSpot = nil
    --targ:RemoveAllDecals()
    --PlaceTreeDecals(plytr.HitPos, plytr.HitNormal, targ)
    MineWood(ply, "Wood", 12, targ)
end)