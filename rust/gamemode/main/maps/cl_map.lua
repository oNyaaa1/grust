local DPanel
local MapMaterial = ""
local PlayerMaterial = Material("icons/player_marker.png")
-- Auto-calibrating map bounds
local MapBounds = {
	["rust_highland_v1_3a"] = {
		min = Vector(-15544, -15544, 0),
		max = Vector(15544, 15544, 0)
	},
	["rust_fields"] = {
		min = Vector(-15544, -15544, 0),
		max = Vector(15544, 15544, 0)
	}
}

local function MapPosToScreen(pnl, pos)
	if calibrationMode then
		if not calibrationData.min then
			calibrationData.min = Vector(pos.x, pos.y, 0)
			calibrationData.max = Vector(pos.x, pos.y, 0)
		else
			calibrationData.min.x = math.min(calibrationData.min.x, pos.x)
			calibrationData.min.y = math.min(calibrationData.min.y, pos.y)
			calibrationData.max.x = math.max(calibrationData.max.x, pos.x)
			calibrationData.max.y = math.max(calibrationData.max.y, pos.y)
		end
	end

	local mapName = game.GetMap()
	local bounds = MapBounds[mapName]
	if not bounds then return pnl:GetWide() / 2, pnl:GetTall() / 2 end
	local normalizedX = (pos.x - bounds.min.x) / (bounds.max.x - bounds.min.x)
	local normalizedY = (pos.y - bounds.min.y) / (bounds.max.y - bounds.min.y)
	local screenX = normalizedX * pnl:GetWide()
	local screenY = (1 - normalizedY) * pnl:GetTall()
	return screenX, screenY
end

-- Draws a textured rect with custom pivot (x0, y0)
function DrawTexturedAngle(x, y, w, h, rot, x0, y0)
	local c = math.cos(math.rad(rot))
	local s = math.sin(math.rad(rot))
	local newx = x0 * c - y0 * s
	local newy = x0 * s + y0 * c
	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end

concommand.Add("+gRust_Map", function(ply)
	if IsValid(DPanel) then DPanel:Remove() end
	DPanel = vgui.Create("DPanel")
	DPanel:SetSize(ScrW(), ScrH())
	DPanel:SetPos(0, 0)
	function DPanel:Paint(w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(MapMaterial)
		surface.DrawTexturedRect(0, 0, w, h)
		local ToPos = LocalPlayer():GetPos()
		local x, y = MapPosToScreen(DPanel, ToPos)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(PlayerMaterial)
		DrawTexturedAngle(x, y, 32, 32, LocalPlayer():GetAngles().y - 90, 0, 0)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawLine(x - 10, y, x + 10, y)
		surface.DrawLine(x, y - 10, x, y + 10)
	end
end)

concommand.Add("-gRust_Map", function(ply)
	if IsValid(DPanel) then
		DPanel:Remove()
		return
	end
end)

local CD = 0
hook.Add("PlayerButtonDown", "gRust.OpenMap", function(pl, key)
	if game.GetMap() == "rust_highland_v1_3a" then
		MapMaterial = Material("materials/misc/map.png")
	elseif game.GetMap() == "rust_fields" then
		MapMaterial = Material("materials/ui/zohart/images/map.png")
	end

	if key == KEY_G and CD <= CurTime() and MapMaterial ~= "" then
		CD = CurTime() + 0.5
		RunConsoleCommand("+gRust_Map")
		gui.EnableScreenClicker(true)
	end
end)

hook.Add("PlayerButtonUp", "gRust.CloseMap", function(pl, key)
	if key == KEY_G and MapMaterial ~= "" then
		RunConsoleCommand("-gRust_Map")
		gui.EnableScreenClicker(false)
	end
end)