include("shared.lua")
function ENT:Draw()
    self:DrawModel()
end
net.Receive("gRustFurnace", function()
    local ent = net.ReadEntity()
end)