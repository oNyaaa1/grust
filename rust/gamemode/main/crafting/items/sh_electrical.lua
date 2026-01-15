ITEMS:RegisterItem("rust_deploy_auto_turret", {
    Name = "Auto Turret",
    Info = "Auto Turret to kill enemies",
    Category = "Electrical",
    model = "materials/items/deployable/auto_turret.png",
    Weapon = "rust_deploy_auto_turret",
    Count = 50,
    Stackable = true,
    StackSize = 150,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Cloth",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Electrical")