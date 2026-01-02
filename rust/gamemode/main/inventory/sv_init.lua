hook.Add("PlayerSpawning", "PlayerSpawning", function(ply, stats)
    ply:RegisterPlayer("models/player/darky_m/rust/hazmat.mdl")
    ply:SetHunger(math.random(80, 120))
    ply:SetThirst(math.random(80, 120))
    ply:AddInventoryItem({
        Weapon = "rust_e_rock",
        Mats = "ui/zohart/items/rock.png",
    }, false)

    ply:AddInventoryItem({
        Weapon = "rust_buildingplan",
        Mats = "ui/zohart/icons/inventory/blueprint.png",
    }, true)

    ply:SelectWeapon("rust_e_rock")
end)