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

net.Receive("gRustAngleRocks", function()
    local entz = net.ReadEntity()
    for i = 1, 4 do
        print(entz:GetModel())
        local csEnt = ents.CreateClientProp()
        csEnt:SetPos(entz:GetPos() + Vector(0, 0, 40))
        csEnt:SetModel(entz:GetModel())
        csEnt:PhysicsInit(SOLID_VPHYSICS)
        csEnt:Spawn()
        csEnt:PhysWake()
        csEnt:SetSkin(entz:GetSkin())
        local scale = Vector(0.2,0.2,0.2)
        local mat = Matrix()
        mat:Scale(scale)
        csEnt:EnableMatrix("RenderMultiply", mat)
        timer.Simple(5, function() if IsValid(csEnt) then csEnt:Remove() end end)
    end
end)