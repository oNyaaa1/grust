--
net.Receive("Schizo_Grust", function()
    local ply = LocalPlayer()
    if IsValid(ply) then
        ply:EmitSound(net.ReadString())
        timer.Simple(2, function() ply:EmitSound("ambient/creatures/town_scared_breathing1.wav") end)
    end
end)