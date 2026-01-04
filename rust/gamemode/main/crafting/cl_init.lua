ITEMS = ITEMS or {}
local crafting_frame = nil
local btn = {}
local Tbl = {}
Tbl[1] = {"Favorite", "icons/favorite_inactive.png"}
Tbl[2] = {"Construction", "icons/construction.png"}
Tbl[3] = {"Items", "icons/extinguish.png"}
Tbl[4] = {"Resources", "icons/servers.png"}
Tbl[5] = {"Clothing", "icons/servers.png"}
Tbl[6] = {"Tools", "icons/tools.png"}
Tbl[7] = {"Medical", "icons/medical.png"}
Tbl[8] = {"Weapons", "icons/weapon.png"}
Tbl[9] = {"Ammo", "icons/ammo.png"}
Tbl[11] = {"Fun", "icons/servers.png"}
Tbl[12] = {"Other", "icons/electric.png"}
Tbl[13] = {"Admin", "icons/electric.png"}
function ITEMS:DrawQMenu()
	if IsValid(crafting_frame) then crafting_frame:Remove() end
	local x, y = ScrW(), ScrH()
	crafting_frame = vgui.Create("DFrame")
	crafting_frame:SetSize(x, y - 150)
	crafting_frame:SetPos(x * -0.15, 0)
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
	local pnl_dock_Right = vgui.Create("DPanel", pnl)
	pnl_dock_Right:Dock(LEFT)
	pnl_dock_Right:SetWide(600)
	pnl_dock_Right:DockMargin(5, 5, 5, 5)
	pnl_dock_Right.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 150)) end
	for i, k in ipairs(ITEMS.Catergories) do
		local DermaButton = vgui.Create("DButton", pnl_dock_btn)
		DermaButton:SetText("")
		DermaButton:Dock(TOP)
		DermaButton:SetTall(40)
		local grid2new = vgui.Create("ThreeGrid", pnl_dock_Right)
		grid2new:Dock(FILL)
		grid2new:DockMargin(4, 4, 4, 4)
		grid2new:SetColumns(5)
		grid2new:SetHorizontalMargin(2)
		grid2new:SetVerticalMargin(2)
		grid2new:InvalidateParent(true)
		grid2new:InvalidateLayout(true)
		DermaButton.DoClick = function()
			for o, dill in pairs(btn) do
				if IsValid(btn[o]) then
					btn[o]:Remove()
					btn[o] = nil
				end
			end

			local function LoadCategory(categoryName)
				grid2new:Clear()
				for _, vk in pairs(ITEMS) do
					if type(vk) == "function" then continue end
					if type(vk) == "table" and string.lower(vk.Category or "") == string.lower(categoryName or "") and not IsValid(btn[_]) then
						btn[_] = vgui.Create("DImageButton")
						btn[_]:SetImage(vk.model)
						btn[_]:Dock(FILL)
						btn[_]:SetTall(100)
						btn[_].DoClick = function()
							if IsValid(dpnl) then dpnl:Remove() end
							dpnl = RightPanelInfo(right, vk)
						end

						grid2new:AddCell(btn[_])
					end
				end
			end

			LoadCategory(k[1])
		end

		local selected = false
		local tblnew = {}
		for jitz,inpairs in pairs(COUNT) do
			tblnew[string.lower(jitz)] = inpairs
		end
		local xd = tblnew[string.lower(k[1])]
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
			draw.DrawText(xd ~= nil and xd or "0", "DermaDefault", w * 0.9, h * 0.2, color_white, TEXT_ALIGN_LEFT)
		end
	end

	local Timmeh = 360
	local MyTime = 0
	local Bottom = vgui.Create("DPanel", pnl_dock_Right)
	Bottom:Dock(BOTTOM)
	Bottom:SetSize(0, 120)
	--Bottom:DockMargin(0, 0, 0, 0)
	Bottom.Paint = function(s, w, h)
		surface.SetDrawColor(Color(255, 255, 255, 0))
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawOutlinedRect(0, 0, w, h, 2)
		draw.DrawText("CRAFTING QUEUE", "Default", w * 0.02, h * 0.1, Color(255, 255, 255, 40), TEXT_ALIGN_LEFT)
		if Timmeh <= 0 then Timmeh = 360 end
		if MyTime <= CurTime() then
			MyTime = CurTime() + 0.1
			Timmeh = Timmeh - 1
		end

		local time = math.Round(1 % CurTime() + Timmeh - 1)
	end
end

function ITEMS:DrawQMenuClosed()
	if IsValid(crafting_frame) then crafting_frame:Remove() end
end

hook.Add("OnSpawnMenuClose", "LoadQMenu", ITEMS.DrawQMenuClosed)
hook.Add("OnSpawnMenuOpen", "LoadQMenu", ITEMS.DrawQMenu)