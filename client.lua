local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, garage in ipairs(Config.Garages) do
            local distance = #(playerCoords - garage.coords)

            if distance < 10.0 then
                DrawMarker(1, garage.coords.x, garage.coords.y, garage.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)

                if distance < 1.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to access the garage')

                    if IsControlJustReleased(0, 38) then
                        OpenGarageMenu(garage)
                    end
                end
            end
        end
    end
end)

function OpenGarageMenu(garage)
    ESX.UI.Menu.CloseAll()

    ESX.TriggerServerCallback('garajeSystem:getVehicles', function(vehicles)
        local elements = {}

        for _, vehicle in ipairs(vehicles) do
            table.insert(elements, {
                label = vehicle.vehicle_model .. ' [' .. vehicle.plate .. ']',
                value = vehicle.plate
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
            title = garage.name,
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            SpawnVehicle(data.current.value, garage.spawnPoint)
        end, function(data, menu)
            menu.close()
        end)
    end, garage.name)
end

function SpawnVehicle(plate, spawnPoint)
    ESX.TriggerServerCallback('garajeSystem:spawnVehicle', function(vehicleProps)
        if vehicleProps then
            ESX.Game.SpawnVehicle(vehicleProps.model, spawnPoint, spawnPoint.w, function(vehicle)
                ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
        else
            ESX.ShowNotification('Vehicle not found!')
        end
    end, plate)
end