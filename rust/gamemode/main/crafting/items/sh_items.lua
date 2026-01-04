ITEMS:RegisterItem("Rock", {
    Name = "Rock",
    Info = "Rock, Basic gathering tool.",
    Category = "Tools",
    model = "materials/items/tools/rock.png",
    Weapon = "tfa_rustalpha_rocktool",
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

--[[

ITEMS:RegisterItem("Stone Hatchet", {
    Name = "Stone Hatchet",
    Info = "The Stone Hatchet - Basic for collecting Sheep cloths and tree gathering",
    Category = "Tools",
    model = "materials/items/tools/stone_hatchet.png",
    Weapon = "tfa_rustalpha_stone_hatchet",
    Count = 1,
    Craft = function()
        return {
            {
                Time = 30,
                CanCraft = true,
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

]]
ITEMS:RegisterItem("Stone Pickaxe", {
    Name = "Stone Pickaxe",
    Info = "The Stone Pickaxe - Basic for collecting Ores",
    Category = "Tools",
    model = "materials/items/tools/stone_pickaxe.png",
    Weapon = "tfa_rustalpha_stone_hatchet",
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

ITEMS:RegisterItem("Building Plan", {
    Name = "Building Plan",
    Info = "The Building Plan, For building",
    Category = "Tools",
    model = "materials/items/tools/building_plan.png",
    Weapon = "rust_builder",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 20,
                },
            },
        }
    end,
}, "Tools")

ITEMS:RegisterItem("Hammer", {
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
                    AMOUNT = 200,
                },
            },
        }
    end,
}, "Tools")

ITEMS:RegisterItem("Hatchet", {
    Name = "Hatchet",
    Info = "Hatchet, Gathering trees!",
    Category = "Tools",
    model = "materials/items/tools/hatchet.png",
    Weapon = "tfa_rustalpha_hatchet",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 400,
                },
                {
                    ITEM = "Metal Fragments",
                    AMOUNT = 150
                }
            },
        }
    end,
}, "Tools")

ITEMS:RegisterItem("Pickaxe", {
    Name = "Pickaxe",
    Info = "Pickaxe, Gathering Ores!",
    Category = "Tools",
    model = "materials/items/tools/pickaxe.png",
    Weapon = "tfa_rustalpha_pickaxe",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 400,
                },
                {
                    ITEM = "Metal Fragments",
                    AMOUNT = 150
                }
            },
        }
    end,
}, "Tools")