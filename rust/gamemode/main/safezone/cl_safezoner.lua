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

hook.Add("HUDPaint", "SafeZone", function()
    if safezone then
        surface.SetFont("BigSafeZoneSign")
        surface.SetTextColor(255,255,255)
        surface.SetTextPos(ScrW() * 0.90, ScrH() * 0.85)
        surface.DrawText("SafeZone")
    end
end)