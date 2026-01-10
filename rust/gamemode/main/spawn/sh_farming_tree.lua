game.AddDecal("TreeMarker", "decals/decal_xspray_a_red")
local ORE_WEAPONS = {
    ["rust_e_rock"] = {
        Name = "Rock",
        ["Metal Ore"] = 1,
        ["Sulfur Ore"] = 1,
        ["Stone"] = 1,
    },
    ["rust_stone_hatchet"] = {
        ["Metal Ore"] = 1.94,
        ["Sulfur Ore"] = 2.57,
        ["Stone"] = 2.11733
    },
    ["rust_pickaxe"] = {
        ["Metal Ore"] = 2.4,
        ["Sulfur Ore"] = 3,
        ["Stone"] = 2.667
    },
    ["rust_jackhammer"] = {
        ["Metal Ore"] = 2.4,
        ["Sulfur Ore"] = 3,
        ["Stone"] = 2.667
    }
}

local function MineWood(ply, item, amount, ent)
    local me = ply:ExistingInventoryItem({
        Weapon = item
    }, amount or 0)

    if me then return end
    ply:AddInventoryItem({
        Weapon = item,
    }, true, amount or 0)
end

hook.Add("EntityTakeDamage", "Wood", function(targ, dmg)
    local ply = dmg:GetAttacker()
    if not IsValid(ply) or not ply:IsPlayer() then return end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end
    local class = wep:GetClass()
    local realwep = ORE_WEAPONS[class]
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

    -- If there's no marker placed yet, accept any hit
    if not targ.LastDecalPos then
        if decalTrace.Hit then
            targ:EmitSound("farming/tree_spray.wav")
            targ:RemoveAllDecals()
            util.Decal("TreeMarker", decalTrace.HitPos + decalTrace.HitNormal, decalTrace.HitPos - decalTrace.HitNormal, game.GetWorld())
            targ.LastDecalPos = decalTrace.HitPos
            targ.RotationProgress = targ.RotationProgress + angleIncrement
        end
    else
        -- Marker exists, check if player hit close enough
        if decalTrace.Hit then
            local hitDistance = startPos:Distance(decalTrace.HitPos)
            local maxHitDistance = 20 -- Adjust this value to make it easier/harder to hit
            if hitDistance <= maxHitDistance then
                -- Player hit the marker!
                targ:EmitSound("farming/tree_spray.wav")
                targ:RemoveAllDecals()
                util.Decal("TreeMarker", decalTrace.HitPos + decalTrace.HitNormal, decalTrace.HitPos - decalTrace.HitNormal, game.GetWorld())
                targ.LastDecalPos = decalTrace.HitPos
                targ.RotationProgress = targ.RotationProgress + angleIncrement
            end
        end
    end

    --targ:EmitSound("farming/tree_spray.wav")
    --targ.strongSpot = nil
    --targ:RemoveAllDecals()
    --PlaceTreeDecals(plytr.HitPos, plytr.HitNormal, targ)
    MineWood(ply, "Wood", 12, targ)
end)