local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('garajeSystem:getVehicles', function(source, cb, garageName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM garage_vehicles WHERE owner = @owner AND garage_name = @garageName AND stored = 1', {
        ['@owner'] = identifier,
        ['@garageName'] = garageName
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('garajeSystem:spawnVehicle', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM garage_vehicles WHERE owner = @owner AND plate = @plate AND stored = 1', {
        ['@owner'] = identifier,
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local vehicleProps = json.decode(result[1].vehicle_props)
            cb(vehicleProps)

            MySQL.Async.execute('UPDATE garage_vehicles SET stored = 0 WHERE plate = @plate', {
                ['@plate'] = plate
            })
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('garajeSystem:storeVehicle')
AddEventHandler('garajeSystem:storeVehicle', function(plate, vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.execute('INSERT INTO garage_vehicles (owner, plate, vehicle_model, garage_name, vehicle_props, stored) VALUES (@owner, @plate, @vehicleModel, @garageName, @vehicleProps, 1) ON DUPLICATE KEY UPDATE stored = 1', {
        ['@owner'] = identifier,
        ['@plate'] = plate,
        ['@vehicleModel'] = vehicleProps.model,
        ['@garageName'] = 'Central Garage',
        ['@vehicleProps'] = json.encode(vehicleProps)
    })
end)