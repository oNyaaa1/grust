local DPanel
local MapMaterial = ""
local PlayerMaterial = Material("icons/player_marker.png")
-- Auto-calibrating map bounds
local MapBounds = {
	["rust_highland"] = {
		min = Vector(-15544, -15544, 0),
		max = Vector(15544, 15544, 0)
	},
	["rust_fields"] = {
		min = Vector(-15544, -15544, 0),
		max = Vector(15544, 15544, 0)
	}
}

local function MapPosToScreen(pnl, pos)
	local mapName = game.GetMap()
	local bounds = MapBounds[mapName]
	if not bounds then return pnl:GetWide() / 2, pnl:GetTall() / 2 end
	local normalizedX = (pos.x - bounds.min.x) / (bounds.max.x - bounds.min.x)
	local normalizedY = (pos.y - bounds.min.y) / (bounds.max.y - bounds.min.y)
	local screenX = normalizedX * pnl:GetWide()
	local screenY = (1 - normalizedY) * pnl:GetTall()
	return screenX, screenY
end

local function ScreenToMapPos(pnl, screenX, screenY)
	local mapName = game.GetMap()
	local bounds = MapBounds[mapName]
	if not bounds then return Vector(0, 0, 0) end
	
	local normalizedX = screenX / pnl:GetWide()
	local normalizedY = 1 - (screenY / pnl:GetTall())
	
	local worldX = bounds.min.x + normalizedX * (bounds.max.x - bounds.min.x)
	local worldY = bounds.min.y + normalizedY * (bounds.max.y - bounds.min.y)
	
	-- Trace with player-sized hull
	local traceDown = util.TraceHull({
		start = Vector(worldX, worldY, 10000),
		endpos = Vector(worldX, worldY, -10000),
		mins = Vector(-16, -16, 0),
		maxs = Vector(16, 16, 72),
		mask = MASK_SOLID_BRUSHONLY 
	})
	
	-- Access the result the same way
	local worldZ = traceDown.Hit and traceDown.HitPos.z or 0
	
	return Vector(worldX, worldY, worldZ)
end
local MapActive = false
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
		MapActive = true
	end
end)

concommand.Add("-gRust_Map", function(ply)
	if IsValid(DPanel) then
		MapActive = false
		DPanel:Remove()
		return
	end
end)

local CD = 0
hook.Add("PlayerButtonDown", "gRust.OpenMap", function(pl, key)
	if game.GetMap() == "rust_highland" then
		MapMaterial = Material("materials/ui/map.png")
	elseif game.GetMap() == "rust_fields" then
		MapMaterial = Material("materials/ui/zohart/images/map.png")
	end

	if MapActive and key == 107 then
		local x, y = DPanel:CursorPos()
		local worldPos = ScreenToMapPos(DPanel, x, y)
		
		net.Start("gRust_Teleport_Map")
		net.WriteVector(worldPos)
		net.SendToServer()
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