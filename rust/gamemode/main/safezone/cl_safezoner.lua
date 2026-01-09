local ply = LocalPlayer()
local safezone = false
surface.CreateFont("BigSafeZoneSign", {
    font = "Arial",
    extended = false,
    size = 20,
    weight = 1500
})

net.Receive("gRust_SafeZone", function()
    -- Is in player safe zone
    safezone = net.ReadBool()
end)

local mat = Material("materials/ui/zohart/icons/safezone.png", "noclamp nobips")
hook.Add("HUDPaint", "SafeZone", function()
    if safezone then
        local x, y = ScrW() * 0.83, ScrH() * 0.83
        surface.SetDrawColor(145, 193, 20)
        surface.DrawRect(x, y, 210, 40)
        surface.SetMaterial(mat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(x, y + 5, 25, 25)
        surface.SetFont("BigSafeZoneSign")
        surface.SetTextColor(255, 255, 255)
        surface.SetTextPos(x + 60, y + 10)
        surface.DrawText("SAFE ZONE")
    end
end)