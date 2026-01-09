AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[
calculations are now correct for wood
e.g sandbox_wood_give "Wood" 300 to give wood or an item u need
Fixed wood resetting when getting wood etc
Fixed another wood bug
Fixed wood where you could hit a player and gain wood xD
Fixed dropping items not showing there number only true xD
Hopefully fixed dropping system
sandbox_wipe to fix the spawning of stuff
Can now discover when near rust_ores on the map!
]]
resource.AddSingleFile("models/player/spike/rustguy_grust.mdl")
resource.AddSingleFile("materials/mapz/map.png")
for k, v in pairs(file.Find("materials/tree/*", "GAME")) do
    resource.AddFile("materials/tree/" .. v)
end

for k, v in pairs(file.Find("sound/laced/*", "GAME")) do
    resource.AddFile("sound/laced/" .. v)
end

for k, v in pairs(file.Find("sound/rmusic/*", "GAME")) do
    resource.AddFile("sound/rmusic/" .. v)
end

for k, v in pairs(file.Find("sound/rsounds/*", "GAME")) do
    resource.AddFile("sound/rsounds/" .. v)
end