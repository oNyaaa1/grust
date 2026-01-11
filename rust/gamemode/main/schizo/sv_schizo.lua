local snds_Sound = {"player/footsteps/concrete1.wav", "player/footsteps/concrete2.wav", "player/footsteps/concrete3.wav", "player/footsteps/concrete4.wav", "player/footsteps/dirt1.wav", "player/footsteps/dirt2.wav", "player/footsteps/dirt3.wav", "player/footsteps/dirt4.wav", "ambient/creatures/town_child_scream1.wav", "ambient/creatures/town_moan1.wav", "ambient/creatures/flies1.wav", "ambient/creatures/flies2.wav", "ambient/creatures/flies3.wav", "ambient/creatures/flies4.wav", "ambient/creatures/flies5.wav","ambient/creatures/teddy.wav"}
util.AddNetworkString("Schizo_Grust")
hook.Add("Tick", "SchizoMode", function()
    local rndply = player.GetAll()[math.random(1, #player.GetAll())]
    if not IsValid(rndply) then return end
    local rndschizo = math.random(1, 1000)
    if rndschizo == math.random(1, 1000) then
        net.Start("Schizo_Grust")
        net.WriteString(snds_Sound[math.random(1, #snds_Sound)])
        net.Send(rndply)
    end
end)