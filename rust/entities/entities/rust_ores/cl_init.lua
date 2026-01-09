include("shared.lua")
for i = 1, 4 do
    util.PrecacheModel("models/environment/ores/ore_node_stage" .. i .. ".mdl")
end

local Flare = Material("decals/flare_ore")
function ENT:Draw()
    self:DrawModel()
    if self:GetPos():Distance(LocalPlayer():GetPos()) > 5000 then return end
    local StrongSpot = self:GetNWVector("StrongSpot")
    if StrongSpot ~= vector_origin then
        cam.Start3D()
        render.SetMaterial(Flare)
        render.DrawSprite(StrongSpot, 64, 64, color_white)
        cam.End3D()
    end
end