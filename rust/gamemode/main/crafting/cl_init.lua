ITEMS = ITEMS or {}
local crafting_frame = nil
function ITEMS:DrawQMenu()
	if IsValid(crafting_frame) then crafting_frame:Remove() end
	local x, y = ScrW(), ScrH()
	crafting_frame = vgui.Create("DFrame")
	crafting_frame:SetSize(x, y - 150)
	crafting_frame:SetPos(0, 0)
	crafting_frame:SetTitle("")
	crafting_frame:MakePopup()
	if IsValid(crafting_frame.btnClose) then crafting_frame.btnClose:Hide() end
	if IsValid(crafting_frame.btnMaxim) then crafting_frame.btnMaxim:Hide() end
	if IsValid(crafting_frame.btnMinim) then crafting_frame.btnMinim:Hide() end
	crafting_frame.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 0)) end
	local pnl = vgui.Create("DPanel", crafting_frame)
	pnl:SetPos(x * 0.2, y * 0.1)
	pnl:SetSize(x / 2 + 200, y / 2 + 200)
	pnl.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 10)) end
	local pnl_dock_btn = vgui.Create("DPanel", pnl)
	pnl_dock_btn:Dock(LEFT)
	pnl_dock_btn:SetWide(x / 2 / 2 / 2)
	pnl_dock_btn.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100)) end
	for i, k in ipairs(ITEMS.Catergories) do
		local DermaButton = vgui.Create("DButton", pnl_dock_btn)
		DermaButton:SetText("")
		DermaButton:Dock(TOP)
		DermaButton:SetTall(40)
		local selected = false
		DermaButton.Paint = function(s, w, h)
			if s:IsHovered() then
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 172, 195, 100))
				if not selected then
					LocalPlayer():EmitSound(sAndbox.GetSounds("piemenu_select"))
					selected = true
				end
			else
				draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 100))
				selected = false
			end

			surface.SetMaterial(k[2])
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(0, 4, 30, 30)
			draw.DrawText(k[1], "DermaDefault", w / 2 - 30, h / 2 - 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end
	end

	local pnl_dock_Right = vgui.Create("DPanel", pnl)
	pnl_dock_Right:Dock(LEFT)
	pnl_dock_Right:SetWide(pnl:GetWide() - 210)
	pnl_dock_Right:DockMargin(5, 5, 5, 5)
	pnl_dock_Right.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 150)) end
end

function ITEMS:DrawQMenuClosed()
	if IsValid(crafting_frame) then crafting_frame:Remove() end
end

hook.Add("OnSpawnMenuClose", "LoadQMenu", ITEMS.DrawQMenuClosed)
hook.Add("OnSpawnMenuOpen", "LoadQMenu", ITEMS.DrawQMenu)