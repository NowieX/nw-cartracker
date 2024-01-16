local playersInMission = {
    locked = false
}

RegisterServerEvent('nw-cartracker:server:PrintToServer', function()
    print("Script made by: ^5NW Scripts®^0, ^6discord: https://discord.gg/JrKzCqJJjQ")
end)

RegisterServerEvent('nw-cartracker:server:lockMission', function()
    playersInMission.locked = true
end)

function unlockMission()
    playersInMission.locked = false
end

RegisterNetEvent('esx:playerDropped', function(playerId, reason)
    unlockMission()
    print("nw-cartracker is available again for players. A player was doing the mission but left the server.")
end)

RegisterServerEvent("nw-cartracker:server:removeCarTrackerItem", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local trackerItem = NW.TrackerItem

    xPlayer.removeInventoryItem(trackerItem.item, trackerItem.amount)
end)

RegisterServerEvent('nw-cartracker:server:spawnVehicleToPutTrackerOn', function(randomSpawnLocation)
    local src = source
    local model = NW.VehicleModel.vehicle
    
    ESX.OneSync.SpawnVehicle(model, randomSpawnLocation.coords, randomSpawnLocation.heading, {fuelLevel = 0}, function(NetworkId)
        local getEntityId = NetworkGetEntityFromNetworkId(NetworkId)
        SetVehicleDoorsLocked(getEntityId, 2)
        TriggerClientEvent('nw-cartracker:client:addZoneForVehicle', src, randomSpawnLocation, NetworkId)
    end)
end)

function RemoveVehicle(vehicle)
    Wait(500)
    local getEntityId = NetworkGetEntityFromNetworkId(vehicle)
    DeleteEntity(getEntityId)
end

RegisterServerEvent('nw-cartracker:server:playerCashOut', function(randomSpawnLocation, vehicle)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    TriggerClientEvent('ox_lib:notify', src, {
        title = NW.Notifies["NotifyTitle"],
        description = NW.Translations["getAwayAndPaid"], 
        duration = NW.Notifies["NotifyTimer"], 
        position = NW.Notifies["NotifyPosition"], 
        type = 'warning',
        icon = 'fa fa-circle-check',
    })
    while true do
        Wait(2500)
        local player_location = xPlayer.getCoords(true)
        local distance = #(player_location - randomSpawnLocation.coords)

        if distance > (NW.Paying.range) then
            xPlayer.addAccountMoney(NW.Paying.payout.account, NW.Paying.payout.amount)
            TriggerClientEvent('ox_lib:notify', src, {
                title = NW.Notifies["NotifyTitle"],
                description = NW.Translations["getPaid"], 
                duration = NW.Notifies["NotifyTimer"], 
                position = NW.Notifies["NotifyPosition"], 
                type = 'success',
                icon = 'fa fa-circle-check',
            })
            unlockMission()
            RemoveVehicle(vehicle)
            TriggerClientEvent('nw-cartracker:client:RemovePoliceBlip', src)
            if NW.Paying.discordMessage.enabled then 
                sendDiscordMessage(NW.Paying.discordMessage.message, NW.Paying.discordMessage.webhookURL)
            end
            return
        end
    end
end)

RegisterServerEvent('nw-cartracker:server:giveCarTrackerItem', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local carTrackerItem = NW.TrackerItem
    local npc_location = NW.NPC[1].location
    local player_location = xPlayer.getCoords(true)
    local distance = #(player_location - npc_location)
    local PolicePlayers = ESX.GetExtendedPlayers('job', 'police')

    if playersInMission.locked then 
        TriggerClientEvent('ox_lib:notify', source, {title = NW.Notifies["NotifyTitle"], description = NW.Translations["missionLocked"], duration = NW.Notifies["NotifyTimer"], position = NW.Notifies["NotifyPosition"], type = 'error', icon = 'fa fa-circle-exclamation', })
        return
    end

    if #PolicePlayers >= NW.PoliceInformation.numberRequired then
        if distance > (NW.NPC[1].targetDistance + 5) then
            sendDiscordMessage(NW.HackingInfo.message, NW.HackingInfo.webhookURL)
            if NW.HackingInfo.dropPlayer then
                xPlayer.kick(NW.HackingInfo.dropMessage)
            end
            return
        end
    
        xPlayer.addInventoryItem(carTrackerItem.item, carTrackerItem.amount)
        TriggerClientEvent('nw-cartracker:client:startMission', src)
    else
        TriggerClientEvent('ox_lib:notify', source, {description = NW.Translations["noPolice"], duration = NW.Notifies["NotifyTimer"], position = NW.Notifies["NotifyPosition"], type = 'error', icon = 'fa fa-handcuffs', })
    end
end)

RegisterServerEvent('nw-cartracker:server:PoliceNotification', function(randomSpawnLocation)
    local source = source
    local PolicePlayers = ESX.GetExtendedPlayers('job', 'police')
        
    for i = 1, #(PolicePlayers) do
        local policePlayer = PolicePlayers[i]
        TriggerClientEvent('ox_lib:notify', source, {
            title = NW.Translations["policeNotify"].title, 
            description = NW.Translations["policeNotify"].description, 
            duration = NW.Notifies["NotifyTimer"], 
            position = NW.Notifies["NotifyPosition"], 
            type = 'warning', 
            icon = 'fa fa-bell'})
        TriggerClientEvent('nw-cartracker:client:PoliceBlip', policePlayer.source, randomSpawnLocation)
    end
end)

function sendDiscordMessage(message, webhookUrl)
    local identifiers = GetPlayerIdentifiers(source)
    local steamName = GetPlayerName(source)
    local steamid = identifiers[1]
    local discordID = identifiers[2]
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local message = message
    local embedData = {{
        ['title'] = "nw-cartracker",
        ['color'] = 0,
        ['footer'] = {
            ['icon_url'] = ""
        },
        ['description'] = message,
        ['fields'] = {
            {
                name = "",
                value = "",
            },

            {
                name = "ID",
                value = "SpelerID: "..xPlayer.source,
            },

            {
                name = "",
                value = "",
            },


            {
                name = "Steam Identifier",
                value = "Steam"..steamid,
                inline = true
            },

            {
                name = "",
                value = "",
            },

            {
                name = "Steam Naam",
                value = "Steamnaam: "..steamName,
            },

            {
                name = "",
                value = "",
            },

            {
                name = "Discord Identifier",
                value = discordID,
            },
        },
    }}
    
    local webhookUrl = webhookUrl

    PerformHttpRequest(webhookUrl, nil, 'POST', json.encode({
        username = 'nw-cartracker logs',
        embeds = embedData
    }), {
        ['Content-Type'] = 'application/json'
    })
end