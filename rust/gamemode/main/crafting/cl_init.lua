ITEMS = ITEMS or {}
local crafting_frame = nil
local Width, Height = ScrW(), ScrH()
local btn = {}
local Bottom = nil
local right = right or nil
local dpanel = dpanel or nil
local dpanel2 = dpanel2 or nil
-- Color scheme matching Rust
local RUST_DARK = Color(30, 30, 30, 250)
local RUST_DARKER = Color(20, 20, 20, 250)
local RUST_ITEM_BG = Color(45, 45, 45, 250)
local RUST_ITEM_HOVER = Color(60, 60, 60, 250)
local RUST_SELECTED = Color(0, 120, 120, 255)
local RUST_ACCENT = Color(0, 150, 150, 255)
local RUST_TEXT = Color(200, 200, 180, 255)
local RUST_TEXT_DIM = Color(150, 150, 140, 255)
local function CreateCraftRow(parent, materialName, needAmount, playerHave)
	local row = vgui.Create("DPanel", parent)
	row:SetTall(40)
	row:Dock(TOP)
	row:DockMargin(0, 1, 0, 1)
	row.Paint = function(s, w, h)
		-- Background
		surface.SetDrawColor(RUST_DARKER)
		surface.DrawRect(0, 0, w, h)
		-- Calculate section widths
		local amountW = 80
		local itemW = w - amountW - 160
		local totalW = 80
		local haveW = 80
		-- Amount section
		draw.SimpleText(tostring(needAmount or ""), "DermaDefault", amountW / 2, h / 2, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		-- Item name section
		draw.SimpleText(tostring(materialName or ""), "DermaDefault", amountW + 10, h / 2, RUST_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		-- Total section
		draw.SimpleText(tostring(needAmount or ""), "DermaDefault", amountW + itemW + totalW / 2, h / 2, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		-- Have section (with color indication)
		local haveText = string.Comma(playerHave or 0)
		local haveColor = (playerHave or 0) >= (needAmount or 0) and Color(100, 200, 100) or Color(200, 100, 100)
		draw.SimpleText(haveText, "DermaDefault", amountW + itemW + totalW + haveW / 2, h / 2, haveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	return row
end

local function RightPanelInfo(parent, ITEM)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if IsValid(dpanel) then dpanel:Remove() end
	if IsValid(dpanel2) then dpanel2:Remove() end
	currentSelectedItem = ITEM
	-- Get parent dimensions
	local parentW, parentH = parent:GetSize()
	-- Create info panel as overlay (not docked)
	dpanel2 = vgui.Create("DPanel", parent)
	dpanel2:SetPos(parentW - 460, 10)
	dpanel2:SetSize(450, parentH - 120)
	dpanel2.Paint = function(s, w, h)
		-- Semi-transparent dark background
		surface.SetDrawColor(Color(20, 20, 20, 245))
		surface.DrawRect(0, 0, w, h)
		-- Left border accent
		surface.SetDrawColor(RUST_ACCENT)
		surface.DrawRect(0, 0, 2, h)
	end

	-- Close button
	local CloseBtn = vgui.Create("DButton", dpanel2)
	CloseBtn:SetPos(10, 10)
	CloseBtn:SetSize(30, 30)
	CloseBtn:SetText("")
	CloseBtn.Paint = function(s, w, h)
		local col = RUST_ITEM_BG
		if s:IsHovered() then col = Color(150, 50, 50) end
		surface.SetDrawColor(col)
		surface.DrawRect(0, 0, w, h)
		-- Draw X
		surface.SetDrawColor(RUST_TEXT)
		surface.DrawLine(8, 8, w - 8, h - 8)
		surface.DrawLine(w - 8, 8, 8, h - 8)
	end

	CloseBtn.DoClick = function() if IsValid(dpanel2) then dpanel2:Remove() end end
	-- Item icon and info section
	local InfoPanel = vgui.Create("DPanel", dpanel2)
	InfoPanel:SetPos(0, 50)
	InfoPanel:SetSize(450, 140)
	InfoPanel.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_ITEM_BG)
		surface.DrawRect(10, 0, w - 20, h)
	end

	-- Item icon
	local IconPanel = vgui.Create("DPanel", InfoPanel)
	IconPanel:SetPos(20, 10)
	IconPanel:SetSize(120, 120)
	IconPanel.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_DARKER)
		surface.DrawRect(0, 0, w, h)
		if ITEM.model then
			local mat = Material(ITEM.model, "smooth")
			if mat and not mat:IsError() then
				surface.SetMaterial(mat)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(10, 10, w - 20, h - 20)
			end
		end
	end

	-- Item name and description
	local NameLabel = vgui.Create("DLabel", InfoPanel)
	NameLabel:SetPos(150, 15)
	NameLabel:SetSize(270, 25)
	NameLabel:SetText(ITEM.Name or "Unknown Item")
	NameLabel:SetFont("DermaLarge")
	NameLabel:SetTextColor(RUST_TEXT)
	local DLabel = vgui.Create("DLabel", InfoPanel)
	DLabel:SetPos(150, 45)
	DLabel:SetSize(270, 80)
	DLabel:SetText(ITEM.Info or "No information available")
	DLabel:SetFont("DermaDefault")
	DLabel:SetTextColor(RUST_TEXT_DIM)
	DLabel:SetWrap(true)
	DLabel:SetAutoStretchVertical(true)
	-- Crafting requirements header
	local HeaderPanel = vgui.Create("DPanel", dpanel2)
	HeaderPanel:SetPos(10, 195)
	HeaderPanel:SetSize(430, 40)
	HeaderPanel.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_ITEM_BG)
		surface.DrawRect(0, 0, w, h)
		local amountW = 80
		local itemW = w - amountW - 160
		local totalW = 80
		local haveW = 80
		draw.SimpleText("AMOUNT", "DermaDefaultBold", amountW / 2, h / 2, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("ITEM TYPE", "DermaDefaultBold", amountW + 10, h / 2, RUST_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("TOTAL", "DermaDefaultBold", amountW + itemW + totalW / 2, h / 2, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("HAVE", "DermaDefaultBold", amountW + itemW + totalW + haveW / 2, h / 2, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- Crafting materials scroll panel
	local MaterialScroll = vgui.Create("DScrollPanel", dpanel2)
	MaterialScroll:SetPos(10, 240)
	MaterialScroll:SetSize(430, parentH - 370)
	local sbar = MaterialScroll:GetVBar()
	sbar:SetHideButtons(true)
	sbar.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_DARKER)
		surface.DrawRect(0, 0, w, h)
	end

	sbar.btnGrip.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_ITEM_BG)
		surface.DrawRect(2, 0, w - 4, h)
	end

	if ITEM.Craft and type(ITEM.Craft) == "function" then
		local craftData = ITEM.Craft()
		local materials = {}
		if craftData then
			for k, v in ipairs(craftData) do
				if istable(v) then
					for i, j in ipairs(v) do
						if istable(j) and j.ITEM and j.AMOUNT then
							local playerHave = 0
							for _, a in pairs({}) do
								if a.Weapon == j.ITEM then
									playerHave = a.Amount or 0
									break
								end
							end

							table.insert(materials, {j.ITEM, j.AMOUNT, playerHave})
						end
					end
				end
			end
		end

		if #materials > 0 then
			for i = 1, math.max(4, #materials) do
				if materials[i] then
					CreateCraftRow(MaterialScroll, materials[i][1], materials[i][2], materials[i][3])
				else
					CreateCraftRow(MaterialScroll, "", "", "")
				end
			end
		else
			local NoCraft = vgui.Create("DLabel", MaterialScroll)
			NoCraft:Dock(FILL)
			NoCraft:SetText("No materials required")
			NoCraft:SetFont("DermaDefault")
			NoCraft:SetTextColor(RUST_TEXT_DIM)
			NoCraft:SetContentAlignment(5)
		end
	else
		local NoCraft = vgui.Create("DLabel", MaterialScroll)
		NoCraft:Dock(FILL)
		NoCraft:SetText("No crafting recipe available")
		NoCraft:SetFont("DermaDefault")
		NoCraft:SetTextColor(RUST_TEXT_DIM)
		NoCraft:SetContentAlignment(5)
	end

	-- Craft button
	local Buttonzz = vgui.Create("DButton", dpanel2)
	Buttonzz:SetPos(10, parentH - 170)
	Buttonzz:SetSize(430, 50)
	Buttonzz:SetText("")
	Buttonzz.Paint = function(s, w, h)
		local col = RUST_ITEM_BG
		if s:IsHovered() then col = RUST_ACCENT end
		surface.SetDrawColor(col)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText("CRAFT", "DermaLarge", w / 2, h / 2, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	Buttonzz.DoClick = function()
		net.Start("CraftingAbility")
		net.WriteTable({ITEM.Weapon})
		net.WriteString(ITEM.Category)
		net.SendToServer()
	end
	return dpanel2
end

function ITEMS.DrawQMenu()
	if IsValid(crafting_frame) then crafting_frame:Remove() end
	local x, y = ScrW(), ScrH()
	crafting_frame = vgui.Create("DFrame")
	crafting_frame:SetSize(x, y)
	crafting_frame:SetPos(0, 0)
	crafting_frame:SetTitle("")
	crafting_frame:MakePopup()
	crafting_frame:ShowCloseButton(false)
	crafting_frame.Paint = function(s, w, h)
		-- Semi-transparent overlay
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
	end

	-- Main container panel
	local pnl = vgui.Create("DPanel", crafting_frame)
	pnl:SetPos(x * 0.05, y * 0.05)
	pnl:SetSize(x * 0.9, y * 0.9)
	pnl.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_DARK)
		surface.DrawRect(0, 0, w, h)
	end

	-- Left side category buttons
	local pnl_dock_btn = vgui.Create("DPanel", pnl)
	pnl_dock_btn:Dock(LEFT)
	pnl_dock_btn:SetWide(220)
	pnl_dock_btn.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_DARKER)
		surface.DrawRect(0, 0, w, h)
	end

	-- Middle/Right content area
	local pnl_dock_Right = vgui.Create("DPanel", pnl)
	pnl_dock_Right:Dock(FILL)
	pnl_dock_Right:DockMargin(2, 0, 0, 0)
	pnl_dock_Right.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_ITEM_BG)
		surface.DrawRect(0, 0, w, h)
	end

	local pnl_dock_Right2 = vgui.Create("DPanel", pnl_dock_Right)
	pnl_dock_Right2:SetPos(0, 0)
	pnl_dock_Right2:SetSize(750, Height * 0.9)
	pnl_dock_Right2.Paint = function(s, w, h)
		surface.SetDrawColor(Color(65, 65, 65))
		surface.DrawRect(0, 0, w, h)
	end

	-- Items container with scroll
	local ItemsContainer = vgui.Create("DPanel", pnl_dock_Right2)
	ItemsContainer:Dock(FILL)
	ItemsContainer:DockMargin(0, 0, 0, 110)
	ItemsContainer.Paint = function() end
	-- Grid for items
	local grid2new = vgui.Create("ThreeGrid", ItemsContainer)
	grid2new:Dock(FILL)
	grid2new:DockMargin(4, 4, 4, 4)
	grid2new:InvalidateParent(true)
	grid2new:SetColumns(5)
	grid2new:SetHorizontalMargin(2)
	grid2new:SetVerticalMargin(2)
	-- Function to load category items
	local function LoadCategory(categoryName)
		grid2new:Clear()
		local itemCount = 0
		for _, v in pairs(ITEMS) do
			if not istable(v) then continue end
			if v.Category ~= nil and string.lower(v.Category) == string.lower(categoryName) then
				itemCount = itemCount + 1
				local itemBtn = vgui.Create("DButton")
				itemBtn:SetSize(0, 150)
				itemBtn:SetText("")
				itemBtn.DoClick = function() RightPanelInfo(pnl_dock_Right, v) end
				itemBtn.Paint = function(s, w, h)
					if s:IsHovered() then
						surface.SetDrawColor(RUST_ITEM_HOVER)
					else
						surface.SetDrawColor(RUST_ITEM_BG)
					end

					surface.DrawRect(0, 0, w, h)
					-- Inner darker box for icon
					surface.SetDrawColor(RUST_DARKER)
					surface.DrawRect(5, 5, w, h)
					-- Draw item icon#
					local mat = Material(v.model, "smooth")
					surface.SetMaterial(mat)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRect(0, 0, w, h)
					-- Draw item name at bottom
					draw.SimpleText(v.Name or "Item", "DermaDefault", w / 2, h - 15, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				grid2new:AddCell(itemBtn)
			end
		end

		if itemCount == 0 then
			local noItems = vgui.Create("DLabel")
			noItems:SetSize(400, 50)
			noItems:SetText("No items in this category")
			noItems:SetFont("DermaLarge")
			noItems:SetTextColor(RUST_TEXT_DIM)
			noItems:SetContentAlignment(5)
			grid2new:AddCell(noItems)
		end
	end

	-- Create category buttons
	local selectedCategory = nil
	for i, k in ipairs(ITEMS.Catergories) do
		local DermaButton = vgui.Create("DButton", pnl_dock_btn)
		DermaButton:SetText("")
		DermaButton:Dock(TOP)
		DermaButton:DockMargin(5, 2, 5, 2)
		DermaButton:SetTall(45)
		DermaButton.DoClick = function()
			selectedCategory = k[1]
			LoadCategory(k[1])
		end

		DermaButton.Paint = function(s, w, h)
			local col = RUST_ITEM_BG
			if selectedCategory == k[1] then
				col = RUST_SELECTED
			elseif s:IsHovered() then
				col = RUST_ITEM_HOVER
			end

			surface.SetDrawColor(col)
			surface.DrawRect(0, 0, w, h)
			-- Draw icon
			if k[2] then
				surface.SetMaterial(k[2])
				surface.SetDrawColor(RUST_TEXT)
				surface.DrawTexturedRect(10, 8, 28, 28)
			end

			-- Draw category name
			draw.SimpleText(k[1], "DermaDefault", 45, h / 2, RUST_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			-- Draw count
			local countz = 0
			if COUNT and COUNT[string.lower(k[1])] then countz = COUNT[string.lower(k[1])] end
			draw.SimpleText(tostring(countz), "DermaDefault", w - 10, h / 2, RUST_TEXT_DIM, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end

	local category = ITEMS.Catergories
	if category[1] then
		selectedCategory = category[1][1]
		timer.Simple(0, function() if IsValid(grid2new) then LoadCategory(category[1][1]) end end)
	end

	-- Bottom crafting queue panel
	Bottom = vgui.Create("DPanel", pnl_dock_Right)
	Bottom:Dock(BOTTOM)
	Bottom:SetTall(110)
	Bottom.Paint = function(s, w, h)
		surface.SetDrawColor(RUST_DARKER)
		surface.DrawRect(0, 0, w, h)
		-- Top border line
		surface.SetDrawColor(RUST_ACCENT)
		surface.DrawRect(0, 0, w, 2)
		draw.SimpleText("CRAFTING QUEUE", "DermaDefaultBold", 15, 15, RUST_TEXT_DIM, TEXT_ALIGN_LEFT)
	end
	-- Load first category by default
end

function ITEMS.DrawQMenuClosed()
	if IsValid(crafting_frame) then crafting_frame:Remove() end
end

hook.Add("OnSpawnMenuClose", "LoadQMenu", ITEMS.DrawQMenuClosed)
hook.Add("OnSpawnMenuOpen", "LoadQMenu", ITEMS.DrawQMenu)