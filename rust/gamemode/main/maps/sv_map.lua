util.AddNetworkString("gRust_Teleport_Map")
net.Receive("gRust_Teleport_Map", function(len, pl)
	if not pl:IsAdmin() then return end
	local mappos = net.ReadVector()
	pl:SetPos(Vector(mappos.x, mappos.y, mappos.z - 6000))
	pl:SetHealth(100)
end)