ITEMS:RegisterItem("rust_deploy_tc", {
    Name = "Tool Cupboard",
    Info = "For bandages etc",
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