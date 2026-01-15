local Upgrade = {
    ["sent_way_door_spanner"] = {
        Model = "models/building/wood_gframe.mdl",
    },
}

net.Receive("gRust_ServerModel_new", function(len, ply)
    local nwstr = net.ReadString()
    local ent = ply:GetEyeTrace().Entity
    local toUpdate = Upgrade[ent:GetClass()]
    if nwstr == "Wood" then ent:SetModel(toUpdate.Model) end
    if nwstr == "Rotate" then
        local ang = ent:GetAngles()
        ang:RotateAroundAxis(ent:GetUp(), -180)
        ent:SetAngles(ang)
    end
end)