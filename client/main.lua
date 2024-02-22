local function DebugPrinter(message)
    if NW.Debug then 
        print("^1["..GetCurrentResourceName().."]: ^4"..message)
    end
end

local function CreateBlip(data)
    DebugPrinter("Creating cartracker blip.")
    carTrackerBlip = AddBlipForCoord(data.coords)

	SetBlipSprite(carTrackerBlip, NW.BlipInformation["CartrackerBlip"].Sprite)
	SetBlipColour(carTrackerBlip, NW.BlipInformation["CartrackerBlip"].Colour)
	SetBlipAsShortRange(carTrackerBlip, true)
	SetBlipScale(carTrackerBlip, NW.BlipInformation["CartrackerBlip"].Scale)
    SetBlipRoute(carTrackerBlip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(NW.BlipInformation["CartrackerBlip"].Translation)
	EndTextCommandSetBlipName(carTrackerBlip)
    DebugPrinter("Cartracker blip created.")
end

local function CreateVehicle(randomSpawnLocation, vehicle)
    while true do
        Wait(2500) 
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local distance = #(randomSpawnLocation.coords - playerCoords)

        if distance < 50 then
            local networkId = NetworkGetNetworkIdFromEntity(vehicle)
            exports.ox_target:addEntity(networkId, {
                {
                    label = NW.VehicleModel.targetText,
                    name = "placeCarTracker",
                    distance = NW.VehicleModel.targetDistance,
                    onSelect = function()
                        TriggerEvent('nw-cartracker:client:startPlacingTracker', networkId, randomSpawnLocation, vehicle)
                    end,
                    icon = 'fa fa-microchip',
                    bones = NW.VehicleModel.targetBone,
                }
            })
            DebugPrinter("Entity zone created for the vehicle.")
            break
        end
    end
end

CreateThread(function()
    DebugPrinter("Creating npc and box zone for script.")
    for k, v in ipairs(NW.NPC) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1)
        end

        local npc = CreatePed(2, v.model, v.location.x, v.location.y, v.location.z, v.heading,  false, true)
            
        SetPedFleeAttributes(npc, 0, false)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)

        TaskStartScenarioInPlace(npc, 'WORLD_HUMAN_DRUG_DEALER', 0, true)

        exports.ox_target:addBoxZone({
            coords = vec3(NW.NPC[1].location.x, NW.NPC[1].location.y, NW.NPC[1].location.z + 1),
            size = vec3(1, 1, 1),
            rotation = 45,
            options = {
                {
                    name = 'carTracker',
                    onSelect = function()
                        TriggerEvent('nw-cartracker:triggerUIon')
                    end,
                    distance = NW.NPC[1].targetDistance,
                    icon = 'fa fa-microchip',
                    label = 'Cartracker',
                },
            }
        })
    end
    DebugPrinter("NPC and target zone created. Works fine!")
end)

RegisterNetEvent('nw-cartracker:triggerUIon')
AddEventHandler('nw-cartracker:triggerUIon', function()
    DebugPrinter("UI event triggered, the UI should be created now.")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
    })
    DebugPrinter("UI Created.")
end)

RegisterNUICallback("nw-cartracker:client:closeUI", function()
    SetNuiFocus(false,false)
    DebugPrinter("UI Closed.")
end)

RegisterNuiCallback("nw-cartracker:client:giveCarTracker", function()
    SetNuiFocus(false,false)
    TriggerServerEvent('nw-cartracker:server:giveCarTrackerItem')
    TriggerServerEvent('nw-cartracker:server:lockMission')
    DebugPrinter("Cartracker should be given to player right now.")
end)

RegisterNetEvent("nw-cartracker:client:startMission")
AddEventHandler("nw-cartracker:client:startMission", function()
    DebugPrinter("Mission starting now.")
    local randomSpawnLocation = NW.CarSpawnLocations[math.random(#NW.CarSpawnLocations)]
    CreateBlip(randomSpawnLocation)
    TriggerEvent('nw-cartracker:client:checkForDistancePlayer', randomSpawnLocation)
    lib.notify({
        title = NW.Notifies["NotifyTitle"],
        description = NW.Translations["goodLuckMission"],
        duration = NW.Notifies["NotifyTimer"],
        position = NW.Notifies["NotifyPosition"],
        type = 'info',
        icon = 'fa fa-comments-dollar', 
    })
    DebugPrinter("Made a random spawn location for the vehicle: "..randomSpawnLocation.coords.." with a heading of: "..randomSpawnLocation.heading)
    DebugPrinter("Created a blip and triggered the event to check the distance of the player.")
end)

RegisterNetEvent('nw-cartracker:client:checkForDistancePlayer')
AddEventHandler('nw-cartracker:client:checkForDistancePlayer', function(randomSpawnLocation)
    DebugPrinter("Checking for the distance of the player.")
    while true do
        Wait(1000)
        local player = PlayerPedId()
        local player_coords = GetEntityCoords(player)
        local distance = #(player_coords - randomSpawnLocation.coords)
        if distance < 280 then
            DebugPrinter("Player is in distance of the vehicle and the vehicle can be spawned.")
            TriggerServerEvent('nw-cartracker:server:spawnVehicleToPutTrackerOn', randomSpawnLocation)
            DebugPrinter("Vehicle spawned.")
            break
        end
    end
end)

RegisterNetEvent('nw-cartracker:client:addZoneForVehicle')
AddEventHandler('nw-cartracker:client:addZoneForVehicle', function(randomSpawnLocation, vehicle)
    DebugPrinter("Creating box zone for on the vehicle it's tire.")
    CreateVehicle(randomSpawnLocation, vehicle)
end)

RegisterNetEvent('nw-cartracker:client:startPlacingTracker')
AddEventHandler('nw-cartracker:client:startPlacingTracker', function(networkId, randomSpawnLocation, vehicle)
    DebugPrinter("Police is notified right now.")
    TriggerServerEvent('nw-cartracker:server:PoliceNotification', randomSpawnLocation)
    Wait(100)
    exports.ox_target:removeEntity(networkId, "placeCarTracker")
    DebugPrinter("Removed entity zone of the vehicle.")

    DebugPrinter("Starting progressbars right now.")
    lib.progressBar(
        {
            duration = NW.Animations["Inspecting"].duration, 
            label = NW.Animations["Inspecting"].text,
            anim = {
                dict = NW.Animations["Inspecting"].animDictionary,
                clip = NW.Animations["Inspecting"].animClip,
                flag = 1,
                lockX = true, 
                lockY = true, 
                lockZ = true
            }
        })
    
    lib.progressBar(
        {
            duration = NW.Animations['PlacingTracker'].duration, 
            label = NW.Animations['PlacingTracker'].text,
            anim = {
                dict = NW.Animations['PlacingTracker'].animDictionary, 
                clip = NW.Animations['PlacingTracker'].animClip,
                flag = 1,
                lockX = true, 
                lockY = true, 
                lockZ = true
            }
        })
    DebugPrinter("Progressbars done. Triggering server events to remove the tracker item from the player and giving the player his money.")
    TriggerServerEvent("nw-cartracker:server:removeCarTrackerItem")
    TriggerServerEvent('nw-cartracker:server:playerCashOut', randomSpawnLocation, vehicle)
    RemoveBlip(carTrackerBlip)
    DebugPrinter("Player got his reward and removed the blip of the cartracker.")
end)

RegisterNetEvent('nw-cartracker:client:PoliceBlip')
AddEventHandler('nw-cartracker:client:PoliceBlip', function(randomSpawnLocation)
    DebugPrinter("Creating police blip.")
    PoliceBlip = AddBlipForCoord(randomSpawnLocation.coords)
    SetBlipSprite(PoliceBlip, NW.BlipInformation['PoliceBlip'].Sprite)
    SetBlipScale(PoliceBlip, NW.BlipInformation['PoliceBlip'].Scale)
    SetBlipColour(PoliceBlip, NW.BlipInformation['PoliceBlip'].Colour)
    SetBlipRoute(PoliceBlip, NW.BlipInformation['PoliceBlip'].Route)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(NW.BlipInformation['PoliceBlip'].Translation)
    EndTextCommandSetBlipName(PoliceBlip)
    DebugPrinter("Police blip created.")
end)

RegisterNetEvent('nw-cartracker:client:RemovePoliceBlip')
AddEventHandler('nw-cartracker:client:RemovePoliceBlip', function()
    Citizen.Wait(NW.PoliceInformation.removeBlipTimer * 1000)
    RemoveBlip(PoliceBlip)
    DebugPrinter("Removed police blip.")
end)

TriggerServerEvent('nw-cartracker:server:PrintToServer')
