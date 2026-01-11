ITEMS:RegisterItem("rust_salvagedcleaver", {
    Name = "Salvaged Cleaver",
    Info = "Killing, Havesting",
    Category = "Weapons",
    model = "materials/items/weapons/salvaged_cleaver.png",
    Weapon = "rust_salvagedcleaver",
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
}, "Weapons")