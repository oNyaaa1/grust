--
net.Receive("Schizo_Grust", function()
    LocalPlayer():EmitSound(net.ReadString())
    timer.Simple(2, function() LocalPlayer():EmitSound("ambient/creatures/town_scared_breathing1.wav") end)
end)