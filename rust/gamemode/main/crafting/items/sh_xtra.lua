ITEMS:RegisterItem("Cloth", {
    Name = "Cloth",
    Info = "For bandages etc",
    Category = "Admin",
    model = "materials/items/resources/cloth.png",
    Weapon = "",
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
}, "Admin")

ITEMS:RegisterItem("Animal Fat", {
    Name = "Animal Fat",
    Info = "For bandages etc",
    Category = "Admin",
    model = "materials/items/resources/animal_fat.png",
    Weapon = "",
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
                    ITEM = "Animal Fat",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Admin")

ITEMS:RegisterItem("Wood", {
    Name = "Wood",
    Info = "For upgrading your base!",
    Category = "Admin",
    model = "materials/items/resources/wood.png",
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
                    ITEM = "Wood",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Admin")

ITEMS:RegisterItem("Metal Fragments", {
    Name = "Metal Fragments",
    Info = "For Pickaxes etc",
    Category = "Admin",
    model = "materials/items/resources/metal_fragments.png",
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
                    ITEM = "Metal Fragments",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Admin")