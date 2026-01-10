ITEMS:RegisterItem("Sulfur Ore", {
    Name = "Sulfur Ore",
    Info = "For smelting and crafting stuff",
    Category = "Admin",
    model = "materials/items/resources/sulfur_ore.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 1000,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Sulfur Ore",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Admin")

ITEMS:RegisterItem("Metal Ore", {
    Name = "Metal Ore",
    Info = "For smelting and crafting stuff",
    Category = "Admin",
    model = "materials/items/resources/metal_ore.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 1000,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Metal Ore",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Admin")

ITEMS:RegisterItem("Stone", {
    Name = "Stone",
    Info = "Used for upgrading your base!",
    Category = "Admin",
    model = "materials/items/resources/stone.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    IzAdmin = true,
    StackSize = 1000,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Stone",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Admin")