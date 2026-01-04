-- Server-side prop and inventory save system with weekly auto-wipe
-- Place this in lua/autorun/server/sv_save_system.lua
local PLAYER = FindMetaTable("Player")
-- Configuration
local SAVE_INTERVAL = 300 -- Auto-save every 5 minutes
local WIPE_INTERVAL = 604800 -- 7 days in seconds (7 * 24 * 60 * 60)
local DATA_FOLDER = "sandbox_saves"
-- Network strings
util.AddNetworkString("sAndbox_WipeNotification")
-- Ensure data folder exists
if not file.Exists(DATA_FOLDER, "DATA") then file.CreateDir(DATA_FOLDER) end
-- ============================================
-- INVENTORY SAVE/LOAD SYSTEM
-- ============================================
function PLAYER:SaveInventory()
    if not self:IsValid() then return false end
    local steamID = self:SteamID64()
    local data = {
        inventory = self.Inventory or {},
        timestamp = os.time()
    }

    local json = util.TableToJSON(data)
    if not json then return false end
    file.Write(DATA_FOLDER .. "/inventory_" .. steamID .. ".txt", json)
    return true
end

function PLAYER:LoadInventory()
    if not self:IsValid() then return false end
    local steamID = self:SteamID64()
    local filePath = DATA_FOLDER .. "/inventory_" .. steamID .. ".txt"
    if not file.Exists(filePath, "DATA") then return false end
    local json = file.Read(filePath, "DATA")
    if not json then return false end
    local data = util.JSONToTable(json)
    if not data or not data.inventory then return false end
    -- Restore inventory
    self.Inventory = data.inventory
    -- Give all weapons back to player
    for slot, item in pairs(self.Inventory) do
        if item and item.Weapon then
            if not self:HasWeapon(item.Weapon) then
                self:LoadInventoryItem({
                    Weapon = item.Weapon,
                    Mats = item.Mats,
                }, true)
            end

            -- Send to client
            net.Start("sAndbox_GridSize_Inventory")
            net.WriteTable(item)
            net.WriteFloat(slot)
            net.WriteBool(true)
            net.Send(self)
            net.Start("DAtaSendGrust")
            net.Send(self)
        end
    end
    return true
end

-- ============================================
-- PROP SAVE/LOAD SYSTEM
-- ============================================
local function SaveProps()
    local props = {}
    -- Find all props to save
    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and ent:GetClass() ~= "player" and ent:GetClass() ~= "worldspawn" then
            -- Save socketed entities and props
            if ent:GetSocket() or ent:GetClass():find("sent_") then
                table.insert(props, {
                    class = ent:GetClass(),
                    model = ent:GetModel(),
                    pos = ent:GetPos(),
                    ang = ent:GetAngles(),
                    owner = ent:GetNWString("Owner", ""),
                    color = ent:GetColor(),
                    material = ent:GetMaterial(),
                    skin = ent:GetSkin(),
                    socket = ent:GetSocket() or false,
                    -- Save custom entity data for rust items
                    count = ent.GetCount and ent:GetCount() or nil,
                    item = ent.GetItem and ent:GetItem() or nil,
                    image = ent.GetImage and ent:GetImage() or nil,
                })
            end
        end
    end

    local data = {
        props = props,
        timestamp = os.time(),
        map = game.GetMap()
    }

    local json = util.TableToJSON(data)
    if not json then return false, 0 end
    file.Write(DATA_FOLDER .. "/props_" .. game.GetMap() .. ".txt", json)
    return true, #props
end

local function LoadProps()
    local filePath = DATA_FOLDER .. "/props_" .. game.GetMap() .. ".txt"
    if not file.Exists(filePath, "DATA") then return false, 0 end
    local json = file.Read(filePath, "DATA")
    if not json then return false, 0 end
    local data = util.JSONToTable(json)
    if not data or not data.props then return false, 0 end
    -- Clear existing props first
    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and ent:GetClass() ~= "player" and ent:GetClass() ~= "worldspawn" then if ent:GetSocket() or ent:GetClass():find("prop_") or ent:GetClass():find("rust_") or ent:GetClass():find("sandbox_") or ent:GetClass():find("sent_") then ent:Remove() end end
    end

    -- Restore props
    local count = 0
    for _, prop in ipairs(data.props) do
        local ent = ents.Create(prop.class)
        if IsValid(ent) then
            if prop.model then ent:SetModel(prop.model) end
            ent:SetPos(prop.pos)
            ent:SetAngles(prop.ang)
            if prop.owner then ent:SetNWString("Owner", prop.owner) end
            if prop.color then ent:SetColor(prop.color) end
            if prop.material then ent:SetMaterial(prop.material) end
            if prop.skin then ent:SetSkin(prop.skin) end
            -- Restore socket status
            if prop.socket and ent.SetSocket then ent:SetSocket(true) end
            -- Restore custom entity data
            if prop.count and ent.SetCount then ent:SetCount(prop.count) end
            if prop.item and ent.SetItem then ent:SetItem(prop.item) end
            if prop.image and ent.SetImage then ent:SetImage(prop.image) end
            ent:Spawn()
            ent:Activate()
            -- Weld to world for socketed entities
            if prop.socket then constraint.Weld(ent, game.GetWorld(), 0, 0, 0, true, true) end
            count = count + 1
        end
    end
    return true, count
end

-- ============================================
-- SAVE ALL DATA
-- ============================================
-- Global function for immediate structure save (called by building tool)
sAndbox = sAndbox or {}
function sAndbox.SaveStructure()
    SaveProps()
end

local function SaveAll()
    -- Save all player inventories
    local playerCount = 0
    for _, ply in ipairs(player.GetAll()) do
        if ply:SaveInventory() then playerCount = playerCount + 1 end
    end

    -- Save props
    local success, propCount = SaveProps()
    print("[Save System] Saved " .. playerCount .. " inventories and " .. (propCount or 0) .. " props")
    return true
end

-- ============================================
-- WIPE SYSTEM
-- ============================================
local function WipeAllPlayerData()
    local files = file.Find(DATA_FOLDER .. "/inventory_*.txt", "DATA")
    local count = 0
    for _, fileName in ipairs(files) do
        file.Delete(DATA_FOLDER .. "/" .. fileName)
        count = count + 1
    end
    return count
end

local function WipeProps()
    local count = 0
    -- Remove all props
    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and ent:GetClass() ~= "player" and ent:GetClass() ~= "worldspawn" then
            if ent:GetSocket() or ent:GetClass():find("prop_") or ent:GetClass():find("rust_") or ent:GetClass():find("sandbox_") or ent:GetClass():find("sent_") then
                ent:Remove()
                count = count + 1
            end
        end
    end

    -- Delete prop save file
    local filePath = DATA_FOLDER .. "/props_" .. game.GetMap() .. ".txt"
    if file.Exists(filePath, "DATA") then file.Delete(filePath) end
    return count
end

local function WipeAll()
    -- Wipe all player inventories
    for _, ply in ipairs(player.GetAll()) do
        ply.Inventory = {}
        ply:StripWeapons()
        ply:Give("rust_e_hands") -- Give default hands
    end

    local invCount = WipeAllPlayerData()
    local propCount = WipeProps()
    -- Delete wipe timer file
    if file.Exists(DATA_FOLDER .. "/next_wipe.txt", "DATA") then file.Delete(DATA_FOLDER .. "/next_wipe.txt") end
    -- Set new wipe time
    local nextWipe = os.time() + WIPE_INTERVAL
    file.Write(DATA_FOLDER .. "/next_wipe.txt", tostring(nextWipe))
    -- Notify all players
    for _, ply in ipairs(player.GetAll()) do
        net.Start("sAndbox_WipeNotification")
        net.WriteString("WEEKLY WIPE! " .. invCount .. " inventories and " .. propCount .. " props removed")
        net.Send(ply)
    end

    print("[Wipe System] Weekly wipe executed - removed " .. invCount .. " inventories and " .. propCount .. " props")
    print("[Wipe System] Next wipe in 7 days")
    return invCount, propCount
end

local function GetNextWipeTime()
    if not file.Exists(DATA_FOLDER .. "/next_wipe.txt", "DATA") then
        -- No wipe time set, create one
        local nextWipe = os.time() + WIPE_INTERVAL
        file.Write(DATA_FOLDER .. "/next_wipe.txt", tostring(nextWipe))
        return nextWipe
    end

    local nextWipe = tonumber(file.Read(DATA_FOLDER .. "/next_wipe.txt", "DATA"))
    return nextWipe or (os.time() + WIPE_INTERVAL)
end

local function CheckWipe()
    local nextWipe = GetNextWipeTime()
    local timeLeft = nextWipe - os.time()
    if timeLeft <= 0 then
        -- Time to wipe!
        WipeAll()
    else
        -- Calculate time remaining
        local days = math.floor(timeLeft / 86400)
        local hours = math.floor((timeLeft % 86400) / 3600)
        local minutes = math.floor((timeLeft % 3600) / 60)
        print("[Wipe System] Next wipe in " .. days .. "d " .. hours .. "h " .. minutes .. "m")
    end
end

-- ============================================
-- HOOKS
-- ============================================
-- Auto-save timer
timer.Create("sAndbox_AutoSave", SAVE_INTERVAL, 0, function() SaveAll() end)
-- Check for wipe every hour
timer.Create("sAndbox_WipeCheck", 3600, 0, function() CheckWipe() end)
-- Save on player disconnect
hook.Add("PlayerDisconnected", "sAndbox_SaveOnDisconnect", function(ply) ply:SaveInventory() end)
-- Load on player spawn
hook.Add("PlayerInitialSpawn", "sAndbox_LoadOnSpawn", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then
            if not ply:LoadInventory() then
                -- Initialize empty inventory if no save exists
                ply.Inventory = {}
            end
        end
    end)
end)

-- Load props on map start
hook.Add("Initialize", "sAndbox_LoadProps", function()
    timer.Simple(2, function()
        local success, count = LoadProps()
        if success then print("[Save System] Loaded " .. count .. " props") end
        -- Check wipe status
        CheckWipe()
    end)
end)

-- Save on shutdown
hook.Add("ShutDown", "sAndbox_SaveOnShutdown", function() SaveAll() end)
-- ============================================
-- CONSOLE COMMANDS (Admin Only)
-- ============================================
concommand.Add("sandbox_save", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then
        ply:ChatPrint("You must be an admin to use this command!")
        return
    end

    SaveAll()
    if IsValid(ply) then
        ply:ChatPrint("Save complete!")
    else
        print("Save complete!")
    end
end)

concommand.Add("sandbox_load", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then
        ply:ChatPrint("You must be an admin to use this command!")
        return
    end

    -- Load props
    local success, propCount = LoadProps()
    -- Reload all player inventories
    for _, pl in ipairs(player.GetAll()) do
        pl:LoadInventory()
    end

    if IsValid(ply) then
        ply:ChatPrint("Load complete! Loaded " .. propCount .. " props")
    else
        print("Load complete! Loaded " .. propCount .. " props")
    end
end)

concommand.Add("sandbox_wipe", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then
        ply:ChatPrint("You must be an admin to use this command!")
        return
    end

    local invCount, propCount = WipeAll()
    if IsValid(ply) then
        ply:ChatPrint("Complete wipe executed! " .. invCount .. " inventories and " .. propCount .. " props removed")
    else
        print("Complete wipe executed!")
    end
end)

concommand.Add("sandbox_wipe_status", function(ply, cmd, args)
    local nextWipe = GetNextWipeTime()
    local timeLeft = nextWipe - os.time()
    local days = math.floor(timeLeft / 86400)
    local hours = math.floor((timeLeft % 86400) / 3600)
    local minutes = math.floor((timeLeft % 3600) / 60)
    local msg = "Next wipe in: " .. days .. " days, " .. hours .. " hours, " .. minutes .. " minutes"
    if IsValid(ply) then
        ply:ChatPrint(msg)
    else
        print(msg)
    end
end)

print("[Save System] Loaded - Auto-save every " .. SAVE_INTERVAL .. " seconds, Weekly wipe every 7 days")