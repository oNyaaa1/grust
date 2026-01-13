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
