local Hud = {}
local w, h = ScrW(), ScrH()
Hud.Posx, Hud.Posy = w * 0.85, h * 0.88
local health = Material("icons/health.png", "noclamp smooth")
local water = Material("icons/cup.png", "noclamp smooth")
local food = Material("icons/food.png", "noclamp smooth")
local function zSetHealth(icon, name, length, x, y, col)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    local lgnth = 180
    draw.RoundedBox(4, Hud.Posx + x, Hud.Posy + y, lgnth + 30, 26, Color(64, 64, 64, 100))
    draw.RoundedBox(4, Hud.Posx + x + 30, Hud.Posy + y, lgnth * length, 26, col)
    x = x or 0
    y = y or 0
    surface.SetMaterial(icon)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(Hud.Posx + x, Hud.Posy + y, 24, 24)
end

hook.Add("HUDPaint", "MrRustHud", function()
    local ply = LocalPlayer()
    zSetHealth(health, "Health: ", ply:Health() / ply:GetMaxHealth(), 1, 1, Color(136, 179, 58))
    zSetHealth(water, "Health: ", ply:GetThirst() / 280, 1, 30, Color(69, 148, 205))
    zSetHealth(food, "Health: ", ply:GetHunger() / 280, 1, 60, Color(193, 109, 53))
end)