ITEMS = {}
ITEMS.ITEM = {}
function ITEMS:Register(item)
	table.insert(ITEMS.ITEM, item)
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