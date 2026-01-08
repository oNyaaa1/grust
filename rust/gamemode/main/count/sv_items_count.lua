local meta = FindMetaTable("Player")
function meta:CountITEM(item)
    if CLIENT then return end
    local amountz = {}
    for k, v in pairs(self.Inventory) do
        amountz[k] = {
            Weapon = v.Weapon,
            Amount = v.amount
        }
    end

    local amountsnew = 0
    for k, v in pairs(amountz) do
        if v.Weapon == item then amountsnew = amountsnew + v.Amount end
    end
    return amountsnew
end