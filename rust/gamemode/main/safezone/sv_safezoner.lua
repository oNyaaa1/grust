util.AddNetworkString("gRust_SafeZone")
local meta = FindMetaTable("Player")
function meta:EnterSafeZone(bool)
    if bool == true then self:SelectWeapon("rust_e_hands") end
    net.Start("gRust_SafeZone")
    net.WriteBool(bool and true or false)
    net.Send(self)
    self.SafeZone = bool
    for k, v in pairs(ents.FindByClass("sent_*")) do
        v:Remove()
    end
end