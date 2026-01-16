ITEMS:RegisterItem("rust_deploy_tc", {
    Name = "Tool Cupboard",
    Info = "For upkeep of the base!",
    Category = "Construction",
    model = "materials/items/deployable/tool_cupboard.png",
    Weapon = "rust_deploy_tc",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_door", {
    Name = "Wooden Door",
    Info = "Wooden Door For the door frame",
    Category = "Construction",
    model = "materials/items/deployable/wooden_door.png",
    Weapon = "rust_deploy_door",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_metal", {
    Name = "Sheet Metal Door",
    Info = "Sheet Metal Door For the door frame",
    Category = "Construction",
    model = "materials/items/deployable/metal_door.png",
    Weapon = "rust_deploy_doorway_metal",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_armoredd", {
    Name = "Armored Door",
    Info = "Armored Door For the door frame",
    Category = "Construction",
    model = "materials/items/deployable/armored_door.png",
    Weapon = "rust_deploy_doorway_armoredd",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_lock", {
    Name = "Key Lock",
    Info = "Key locks used lock doors",
    Category = "Construction",
    model = "materials/items/deployable/keylock.png",
    Weapon = "rust_deploy_lock",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_codelock", {
    Name = "Keypad",
    Info = "Keypad used lock doors",
    Category = "Construction",
    model = "materials/items/deployable/keypad.png",
    Weapon = "rust_deploy_codelock",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_wooddd", {
    Name = "Wood Double Door",
    Info = "Wood Double Door",
    Category = "Construction",
    model = "materials/items/deployable/wood_double_door.png",
    Weapon = "rust_deploy_wooddd",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_metaldd", {
    Name = "Sheet Metal Double Door",
    Info = "Sheet Metal Double Door",
    Category = "Construction",
    model = "materials/items/deployable/sheet_metal_double_door.png",
    Weapon = "rust_deploy_metaldd",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_armoredd", {
    Name = "Armored Double Door",
    Info = "Armored Double Door",
    Category = "Construction",
    model = "materials/items/deployable/armored_double_door.png",
    Weapon = "rust_deploy_doorway_armoredd",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_stonebar", {
    Name = "Stone Barricade",
    Info = "Useful for pvp fights",
    Category = "Construction",
    model = "materials/items/deployable/stone_barricade.png",
    Weapon = "rust_deploy_doorway_stonebar",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_woodbar", {
    Name = "Wooden Barricade Cover",
    Info = "Useful for pvp fights",
    Category = "Construction",
    model = "materials/items/deployable/wooden_barricade.png",
    Weapon = "rust_deploy_doorway_woodbar",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_repairbench", {
    Name = "Repair Bench",
    Info = "Useful for repairing gears/weapons",
    Category = "Construction",
    model = "materials/items/deployable/repair_bench.png",
    Weapon = "rust_deploy_doorway_repairbench",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_researchtable", {
    Name = "Repair Bench",
    Info = "Useful for researching stuff",
    Category = "Construction",
    model = "materials/items/deployable/research_table.png",
    Weapon = "rust_deploy_doorway_researchtable",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_sleepingbag", {
    Name = "Sleeping Bag",
    Info = "Spawn point",
    Category = "Construction",
    model = "materials/items/deployable/sleeping_bag.png",
    Weapon = "rust_deploy_doorway_sleepingbag",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_doorway_bed", {
    Name = "Bed",
    Info = "Spawn point",
    Category = "Construction",
    model = "materials/items/deployable/bed.png",
    Weapon = "rust_deploy_doorway_bed",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_woodenwindowbars", {
    Name = "Wooden Window Bars",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/wood_window_bars.png",
    Weapon = "rust_deploy_woodenwindowbars",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_glasswindow", {
    Name = "Reinforced Glass Window",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/reinforced_glass_window.png",
    Weapon = "rust_deploy_glasswindow",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_embrasureh", {
    Name = "Metal Horizontal Embrasure",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/metal_horizontal_embrasure.png",
    Weapon = "rust_deploy_embrasureh",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_v_embrasureh", {
    Name = "Metal Vertical Embrasure",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/metal_vertical_embrasure.png",
    Weapon = "rust_deploy_v_embrasureh",
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_metal_sf", {
    Name = "Metal Shop Front",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/metal_shop_front.png",
    Weapon = "rust_deploy_metal_sf",
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
}, "Construction")


ITEMS:RegisterItem("rust_deploy_garagedoor", {
    Name = "Garage Door",
    Info = "For door",
    Category = "Construction",
    model = "materials/items/deployable/garage_door.png",
    Weapon = "rust_deploy_garagedoor",
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
}, "Construction")