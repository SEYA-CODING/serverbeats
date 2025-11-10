-- ServerBeats v1.1.0 by SEYA CODING
-- Discord: seya_coding #6497
-- Community: https://discord.gg/RT3uJRdXSC

local nuiOpen = false
local localVolume = Config.DefaultVolume or 0.6
local currentPlaying = nil
local currentGlobalVolume = Config.DefaultVolume or 0.6
local allowVolume = true

print("ServerBeats v1.1.0 by SEYA CODING - Client initialized.")

RegisterNetEvent('serverbeats:openNui', function(info)
    if not Config.Enabled then return end
    SetNuiFocus(true, true)
    nuiOpen = true
    allowVolume = info.allowVolume
    SendNUIMessage({
        action = 'open',
        serverName = info.serverName or GetConvar('sv_hostname', 'FiveM Server'),
        defaultVolume = info.defaultVolume or Config.DefaultVolume,
        allowVolume = allowVolume
    })
end)

RegisterNetEvent('serverbeats:clientPlay', function(data)
    if not Config.Enabled then return end
    currentPlaying = data.url
    currentGlobalVolume = tonumber(data.volume) or Config.DefaultVolume
    SendNUIMessage({
        action = 'play',
        url = currentPlaying,
        globalVolume = currentGlobalVolume
    })
end)

RegisterNetEvent('serverbeats:clientStop', function()
    if not Config.Enabled then return end
    currentPlaying = nil
    SendNUIMessage({ action = 'stop' })
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    nuiOpen = false
    cb('ok')
end)

RegisterNUICallback('ownerPlay', function(data, cb)
    TriggerServerEvent('serverbeats:serverPlay', { url = data.url, volume = data.volume })
    cb('ok')
end)

RegisterNUICallback('ownerStop', function(_, cb)
    TriggerServerEvent('serverbeats:serverStop')
    cb('ok')
end)

RegisterNUICallback('setLocalVolume', function(data, cb)
    localVolume = tonumber(data.volume) or localVolume
    SendNUIMessage({ action = 'setLocalVolume', localVolume = localVolume })
    cb('ok')
end)

AddEventHandler('onClientResourceStop', function(res)
    if res == GetCurrentResourceName() then
        SendNUIMessage({ action = 'stop' })
    end
end)
