-- ServerBeats v1.1.0 by SEYA CODING
-- Discord: seya_coding #6497
-- Community: https://discord.gg/RT3uJRdXSC

if Config.ShowCreditsInConsole then
    print("============================================")
    print(" ServerBeats v1.1.0 by SEYA CODING")
    print(" Discord: seya_coding #6497")
    print(" Community: https://discord.gg/RT3uJRdXSC")
    print("============================================")
end

Framework = nil
FrameworkType = nil

CreateThread(function()
    if Config.ForceFramework == 'qb' or (Config.ForceFramework == 'auto' and GetResourceState('qb-core') == 'started') then
        local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
        if ok and core then
            Framework = core
            FrameworkType = 'qb'
            print('[ServerBeats] QBCore detected.')
            return
        end
    elseif Config.ForceFramework == 'esx' or (Config.ForceFramework == 'auto' and GetResourceState('es_extended') == 'started') then
        TriggerEvent('esx:getSharedObject', function(obj)
            Framework = obj
            FrameworkType = 'esx'
            print('[ServerBeats] ESX detected.')
        end)
        return
    end
    if Config.ForceFramework == 'none' then
        print('[ServerBeats] Framework integration disabled.')
    else
        print('[ServerBeats] No supported framework detected (continuing standalone).')
    end
end)

-- Check if player is an owner
local function isOwner(source)
    if not source then return false end
    local ids = GetPlayerIdentifiers(source)
    for _, id in ipairs(ids) do
        for _, ownerId in ipairs(Config.Owners) do
            if id == ownerId then
                return true
            end
        end
    end
    if IsPlayerAceAllowed(source, "serverbeats.admin") then
        return true
    end
    return false
end

-- Open menu
RegisterNetEvent('serverbeats:openMenu', function()
    local src = source
    if not Config.Enabled then return end
    if isOwner(src) then
        TriggerClientEvent('serverbeats:openNui', src, {
            serverName = GetConvar('sv_hostname', 'FiveM Server'),
            defaultVolume = Config.DefaultVolume,
            allowVolume = Config.AllowPlayerVolume
        })
    else
        TriggerClientEvent('chat:addMessage', src, { args = {'ServerBeats', '^1You are not authorized to open this menu.'} })
    end
end)

-- Broadcast play
RegisterNetEvent('serverbeats:serverPlay', function(data)
    local src = source
    if not Config.Enabled or not isOwner(src) then return end

    local url = tostring(data.url or '')
    local volume = tonumber(data.volume) or Config.DefaultVolume
    if url == '' then
        TriggerClientEvent('chat:addMessage', src, { args = {'ServerBeats', '^1Please enter a valid YouTube link.'} })
        return
    end
    print(('[ServerBeats] Owner (ID %s) playing: %s'):format(src, url))
    TriggerClientEvent('serverbeats:clientPlay', -1, { url = url, volume = volume })
end)

-- Stop broadcast
RegisterNetEvent('serverbeats:serverStop', function()
    local src = source
    if not Config.Enabled or not isOwner(src) then return end
    print(('[ServerBeats] Owner (ID %s) stopped playback.'):format(src))
    TriggerClientEvent('serverbeats:clientStop', -1)
end)

-- /music command
RegisterCommand('music', function(source)
    if source == 0 then
        print('Command not usable from console.')
        return
    end
    if isOwner(source) then
        TriggerClientEvent('serverbeats:openNui', source, {
            serverName = GetConvar('sv_hostname', 'FiveM Server'),
            defaultVolume = Config.DefaultVolume,
            allowVolume = Config.AllowPlayerVolume
        })
    else
        TriggerClientEvent('chat:addMessage', source, { args = {'ServerBeats', '^1You are not authorized to use this command.'} })
    end
end)
