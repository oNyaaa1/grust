ITEMS:RegisterItem("rust_deploy_landmine", {
    Name = "Homemade Landmine",
    Info = "For killing",
    Category = "Other",
    model = "materials/items/deployable/homemade_landmine.png",
    Weapon = "rust_deploy_landmine",
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
}, "Other")