RegisterCommand("changeplate", function()
    local Config = lib.callback.await("wdev-changeplate:server:receive:config")

    if Config.DiscordPerms then
        if not exports["discordperms"]:hasplategroup() then
            lib.notify({
                title = "Error!",
                description = "This is exclusively for VIP it's not available to everyone.",
                type = "inform"
            })
            return
        end
    end

    local vehicle = GetVehiclePedIsIn(cache.ped, false)

    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= cache.ped then
        lib.notify({
            title = "Error!",
            description = "You must be the driver of a vehicle.",
            type = "inform"
        })
        return
    end

    local input = lib.inputDialog("Change Plate", {
        { type = "input", label = "New Plate", placeholder = "e.g. NEW123", required = true }
    })

    if not input then
        return
    end

    local newPlate = string.upper(input[1])

    if #newPlate < 1 or #newPlate > 8 or newPlate:find("[^A-Z0-9]") then
        lib.notify({
            title = "Error!",
            description = "Plate must be 1-8 characters (A-Z, 0-9 only).",
            type = "inform"
        })
        return
    end

    local oldPlate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent("wdev-platechange:server:change", VehToNet(vehicle), oldPlate, newPlate)
end)