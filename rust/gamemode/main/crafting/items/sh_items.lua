ITEMS:RegisterItem("rust_e_rock", {
    Name = "Rock",
    Info = "Rock, Basic gathering tool.",
    Category = "Tools",
    model = "materials/items/tools/rock.png",
    Weapon = "rust_e_rock",
    Count = 1,
    Craft = function()
        return {
            {
                Time = 5,
                CanCraft = true,
                {
                    ITEM = "Stone",
                    AMOUNT = 10,
                },
            },
        }
    end,
}, "Tools")


ITEMS:RegisterItem("rust_buildingplan", {
    Name = "Building Plan",
    Info = "The Building Plan, For building",
    Category = "Tools",
    model = "materials/items/tools/building_plan.png",
    Weapon = "rust_buildingplan",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 250,
                },
            },
        }
    end,
}, "Tools")

ITEMS:RegisterItem("rust_hammer", {
    Name = "Hammer",
    Info = "Hammer, Upgrading ur base!",
    Category = "Tools",
    model = "materials/items/tools/hammer.png",
    Weapon = "rust_hammer",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 300,
                },
            },
        }
    end,
}, "Tools")