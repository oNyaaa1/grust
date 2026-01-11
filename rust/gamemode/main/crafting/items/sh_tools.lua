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

ITEMS:RegisterItem("rust_stone_hatchet", {
    Name = "Stone Hatchet",
    Info = "Good for gathering minerals and wood",
    Category = "Tools",
    model = "materials/items/tools/stone_hatchet.png",
    Weapon = "rust_stone_hatchet",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 200,
                },
                {
                    ITEM = "Stone",
                    AMOUNT = 100,
                },
            },
        }
    end,
}, "Tools")

ITEMS:RegisterItem("rust_pickaxe", {
    Name = "Pickaxe",
    Info = "Good for harvesting ores (Metal,stone,sulfur)",
    Category = "Tools",
    model = "materials/items/tools/pickaxe.png",
    Weapon = "rust_pickaxe",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 200,
                },
                {
                    ITEM = "Stone",
                    AMOUNT = 100,
                },
            },
        }
    end,
}, "Tools")
