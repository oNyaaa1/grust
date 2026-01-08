ITEMS = {}
ITEMS.ITEM = {}
COUNT = COUNT or {}
if SERVER then
	util.AddNetworkString("CraftingAbility")
	net.Receive("CraftingAbility", function(len, ply)
		local tbl = net.ReadTable()
		--local str = net.ReadString()
		local item = ITEMS:GetItem(tbl[1])
		if not item then return end
		ply:AddInventoryItem({
			Weapon = item.Weapon,
		}, true, nil, 1)
	end)
end

ITEMS.Catergories = {
	[1] = {"FAVORITE", Material("icons/favorite_inactive.png", "noclamp nobips")},
	[2] = {"COMMON", Material("icons/servers.png", "noclamp nobips")},
	[3] = {"CONSTRUCTION", Material("icons/construction.png", "noclamp nobips")},
	[4] = {"ITEMS", Material("icons/extinguish.png", "noclamp nobips")},
	[5] = {"RESOURCES", Material("icons/servers.png", "noclamp nobips")},
	[6] = {"CLOTHING", Material("icons/servers.png", "noclamp nobips")},
	[7] = {"TOOLS", Material("icons/tools.png", "noclamp nobips")},
	[8] = {"MEDICAL", Material("icons/medical.png", "noclamp nobips")},
	[9] = {"WEAPONS", Material("icons/weapon.png", "noclamp nobips")},
	[10] = {"AMMO", Material("icons/ammo.png", "noclamp nobips")},
	[11] = {"ELECTRICAL", Material("icons/electric.png", "noclamp nobips")},
	[12] = {"FUN", Material("icons/dots.png", "noclamp nobips")},
	[13] = {"OTHER", Material("icons/dots.png", "noclamp nobips")}
}

function ITEMS:RegisterItem(itemName, items, category)
	self[itemName] = items
	local countz = 0
	for k, v in pairs(ITEMS) do
		if type(v) == "table" and v.Category == category then countz = countz + 1 end
	end

	COUNT[category] = countz
end

function ITEMS:GetItem(itemName)
	return self[itemName]
end