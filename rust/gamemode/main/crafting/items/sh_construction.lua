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

ITEMS:RegisterItem("rust_deploy_doorway", {
    Name = "Wooden Door",
    Info = "Wooden Door For the door frame",
    Category = "Construction",
    model = "materials/items/deployable/wooden_door.png",
    Weapon = "rust_deploy_doorway",
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

ITEMS:RegisterItem("rust_keylock", {
    Name = "Key Lock",
    Info = "Key locks used lock doors",
    Category = "Construction",
    model = "materials/items/deployable/keylock.png",
    Weapon = "rust_keylock",
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