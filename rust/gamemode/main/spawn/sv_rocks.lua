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

local function MineRocks(ply, item, amount, ent)
    local me = ply:ExistingInventoryItem({
        Weapon = item
    }, amount or 0)

    if me then return end
    ply:AddInventoryItem({
        Weapon = item,
    }, true, amount or 0)
end

local function GetTypeRock(typez)
    if typez:GetSkin() == 3 then
        --=rock=--
        return "Stone"
    end

    if typez:GetSkin() == 1 then
        --=metal=--
        return "Metal Ore"
    end

    if typez:GetSkin() == 2 then
        --=sulfur=--
        return "Sulfur Ore"
    end
end

hook.Add("EntityTakeDamage", "Wood", function(targ, dmg)
    local ply = dmg:GetAttacker()
    if not IsValid(ply) or not ply:IsPlayer() then return end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end
    local class = wep:GetClass()
    local realwep = ORE_WEAPONS[class]
    if realwep == nil then return end
    --targ.maxHP = TREE_MODELS[targ:GetModel()]
    --local hp = targ.maxHP - dmg:GetDamage()
    local plytr = ply:GetEyeTrace()
    local rock = GetTypeRock(plytr.Entity)
    if not rock then return end
    print(rock)
    MineRocks(ply, rock, 12, targ)
end)