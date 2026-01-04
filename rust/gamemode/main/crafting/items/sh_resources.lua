ITEMS:RegisterItem("Low Grade Fuel", {
    Name = "Low Grade Fuel",
    Info = "For syringes",
    Category = "Resources",
    model = "materials/items/resources/low_grade_fuel.png",
    Weapon = "",
    Count = 5,
    Stackable = true,
    StackSize = 150,
    IzAdmin = true,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Cloth",
                    AMOUNT = 20,
                },
                {
                    ITEM = "Animal Fat",
                    AMOUNT = 30
                }
            },
        }
    end,
}, "Resources")


