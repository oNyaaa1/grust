ENT.Type = "brush"
ENT.Base = "base_brush"
function ENT:Initialize()
end

function ENT:StartTouch(ply)
    if ply:IsPlayer() then ply:EnterSafeZone(true) end
end

function ENT:EndTouch(ply)
    if ply:IsPlayer() then ply:EnterSafeZone(false) end
end

