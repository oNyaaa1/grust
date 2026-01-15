ITEMS:RegisterItem("rust_deploy_furnace", {
    Name = "Furnace",
    Info = "Furnace!",
    Category = "Items",
    model = "materials/items/deployable/furnace.png",
    Weapon = "rust_deploy_furnace",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Stone",
                    AMOUNT = 250,
                },
                {
                    ITEM = "Low Grade Fuel",
                    AMOUNT = 150,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("rust_deploy_smalloil", {
    Name = "Small Oil Refinery",
    Info = "Small Oil Refinery refine lowgrade fuel!",
    Category = "Items",
    model = "materials/items/deployable/small_oil_refinery.png",
    Weapon = "rust_deploy_smalloil",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Stone",
                    AMOUNT = 250,
                },
                {
                    ITEM = "Low Grade Fuel",
                    AMOUNT = 150,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("rust_deploy_large_bx", {
    Name = "Large Wood Box",
    Info = "Storage",
    Category = "Items",
    model = "materials/items/deployable/large_wood_box.png",
    Weapon = "rust_deploy_large_bx",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Stone",
                    AMOUNT = 250,
                },
                {
                    ITEM = "Low Grade Fuel",
                    AMOUNT = 150,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("rust_deploy_woodsmallbox", {
    Name = "Wood Storage Box",
    Info = "Storage",
    Category = "Items",
    model = "materials/items/deployable/wood_box.png",
    Weapon = "rust_deploy_woodsmallbox",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Stone",
                    AMOUNT = 250,
                },
                {
                    ITEM = "Low Grade Fuel",
                    AMOUNT = 150,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("rust_deploy_workbenchlvl1", {
    Name = "Workbench Level 1",
    Info = "Unlocking tiers 1 etc",
    Category = "Items",
    model = "materials/items/deployable/workbench_tier1.png",
    Weapon = "rust_deploy_workbenchlvl1",
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
}, "Items")

ITEMS:RegisterItem("rust_deploy_workbenchlvl2", {
    Name = "Workbench Level 2",
    Info = "Unlocking tiers 2 etc",
    Category = "Items",
    model = "materials/items/deployable/workbench_tier2.png",
    Weapon = "rust_deploy_workbenchlvl2",
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
}, "Items")

ITEMS:RegisterItem("rust_deploy_workbenchlvl3", {
    Name = "Workbench Level 3",
    Info = "Unlocking tiers 3 etc",
    Category = "Items",
    model = "materials/items/deployable/workbench_tier3.png",
    Weapon = "rust_deploy_workbenchlvl3",
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
}, "Items")

ITEMS:RegisterItem("rust_deploy_rust_vendingmachine", {
    Name = "Vending Machine",
    Info = "Buy stuff",
    Category = "Items",
    model = "materials/items/deployable/vending_machine.png",
    Weapon = "rust_deploy_rust_vendingmachine",
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
}, "Items")

ITEMS:RegisterItem("rust_deploy_rust_chair", {
    Name = "Chair",
    Info = "Sit feel comf",
    Category = "Items",
    model = "materials/items/deployable/chair.png",
    Weapon = "rust_deploy_rust_chair",
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
}, "Items")


