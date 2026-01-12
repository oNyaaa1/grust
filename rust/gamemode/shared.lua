gRust = gRust or {}
DeriveGamemode("sandbox")
GM.Name = "gRust | Rust in Garry's Mod"
local includes = function(f)
    if string.find(f, "sv_") then
        return SERVER and include(f)
    elseif string.find(f, "cl_") then
        return SERVER and AddCSLuaFile(f) or CLIENT and include(f)
    elseif string.find(f, "sh_") then
        if SERVER then
            AddCSLuaFile(f)
            return include(f)
        else
            return include(f)
        end
    end
end

IncludeDir = function(dir)
    local fol = dir .. '/'
    local files, folders = file.Find(fol .. '*', "LUA")
    for _, f in ipairs(files) do
        includes(fol .. f)
    end

    for _, f in ipairs(folders) do
        IncludeDir(dir .. '/' .. f)
    end
end

IncludeDir("rust/gamemode/thirdparty")
IncludeDir("rust/gamemode/extra")
IncludeDir("rust/gamemode/main")
local meta = FindMetaTable("Player")
function meta:GetWood()
    return 0
end