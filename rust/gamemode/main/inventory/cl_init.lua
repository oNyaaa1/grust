hook.Add("LoadInventory", "Inventory", function(pnl, sbox_pnl1, sbox_pnl2) end)
hook.Add("ScoreboardShow", "MyInventory", function()
	sAndbox.InventoryMain()
	return true
end)

hook.Add("ScoreboardHide", "MyInventory", function()
	local frame = sAndbox.InventoryMain()
	if IsValid(frame) then
		frame:Remove()
		frame = nil
	end
	return true
end)

local x, y = ScrW(), ScrH()
sAndbox.pnl2 = {}
sAndbox.pnl3 = vgui.Create("DPanel")
sAndbox.pnl3:SetPos(x * 0.3, y * 0.88)
sAndbox.pnl3:SetSize(602, 100)
sAndbox.pnl3.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 0)) end
local grid2 = vgui.Create("ThreeGrid", sAndbox.pnl3)
grid2:Dock(FILL)
grid2:DockMargin(4, 4, 4, 4)
grid2:InvalidateParent(true)
grid2:SetColumns(6)
grid2:SetHorizontalMargin(2)
grid2:SetVerticalMargin(2)
for i = 1, 6 do
	sAndbox.pnl2[i] = vgui.Create("DPanel")
	sAndbox.pnl2[i]:SetTall(60)
	sAndbox.pnl2[i].Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 200)) end
	grid2:AddCell(sAndbox.pnl2[i])
end