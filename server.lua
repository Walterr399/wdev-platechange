ESX = exports["es_extended"]:getSharedObject()

local Config = require "config"

lib.callback.register("wdev-changeplate:server:receive:config", function()
    return Config
end)

RegisterNetEvent("wdev-platechange:server:change", function(netId, oldPlate, newPlate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return
    end

    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(vehicle) then
        return
    end

    local result = MySQL.scalar.await("SELECT plate FROM owned_vehicles WHERE plate = ?", { oldPlate })
    if not result then
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Error!",
            description = "You don't own this vehicle.",
            type = "inform"
        })
        return
    end

    MySQL.update.await("UPDATE owned_vehicles SET plate = ? WHERE plate = ?", {
        newPlate, oldPlate
    })

    SetVehicleNumberPlateText(vehicle, newPlate)

    TriggerClientEvent("ox_lib:notify", src, {
        title = "Success!",
        description = "Plate changed to " .. newPlate,
        type = "inform"
    })
end)