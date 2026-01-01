AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*
Fixed not being able to hit trees properly
Fixed bug being able to select weapon on slot picking
Fixed bug in item drop
Added TC [Authorized]

*/
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

