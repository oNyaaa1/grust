util.AddNetworkString("DataSendGrust")
hook.Add("PlayerSpawn", "sAndbox_PlayerSpawnInventory", function(ply)
    -- Initialize inventory
    ply.Inventory = {}
    -- Set player model and stats
    ply:SetModel("models/player/darky_m/rust/hazmat.mdl")
    ply:SetHealth(math.random(50,65))
    ply:SetHunger(math.random(80, 120))
    ply:SetThirst(math.random(80, 120))
    -- Give starting items with longer delay to ensure client is ready
    timer.Simple(0.5, function()
        if not IsValid(ply) then return end
        ply:AddInventoryItem({
            Weapon = "rust_e_rock",
        }, true, 1,  1)
        
        net.Start("DataSendGrust")
        net.Send(ply)
        -- Select rock after giving items
        timer.Simple(0.2, function() if IsValid(ply) and ply:HasWeapon("rust_e_rock") then ply:SelectWeapon("rust_e_rock") end end)
    end)
end)

function clearSlot(ply)
    if not IsValid(ply) or not ply.Inventory then return end
    -- Remove all weapons
    for i = 1, 36 do
        if ply.Inventory[i] and ply.Inventory[i].Weapon then if ply:HasWeapon(ply.Inventory[i].Weapon) then ply:StripWeapon(ply.Inventory[i].Weapon) end end
    end

    -- Clear inventory table
    ply.Inventory = {}
    -- Send clear messages to client
    for i = 1, 36 do
        net.Start("sAndbox_GridSize_Inventory")
        net.WriteTable({
            Weapon = nil,
            Mats = nil
        })

        net.WriteFloat(i)
        net.WriteBool(false)
        net.Send(ply)
    end
end

hook.Add("PlayerDeath", "sAndbox_DeathClearInventory", function(ply) clearSlot(ply) end)