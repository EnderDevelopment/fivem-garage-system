Config = {}

-- Garage configuration
Config.Garages = {
    {
        name = 'Central Garage',
        coords = vector3(215.1, -810.3, 30.7),
        spawnPoint = vector4(228.1, -800.3, 30.5, 160.0),
        vehicles = {}
    },
    {
        name = 'Airport Garage',
        coords = vector3(-796.8, -2024.0, 9.2),
        spawnPoint = vector4(-796.8, -2024.0, 9.2, 160.0),
        vehicles = {}
    }
}

-- Database configuration
Config.Database = {
    tableName = 'garage_vehicles'
}