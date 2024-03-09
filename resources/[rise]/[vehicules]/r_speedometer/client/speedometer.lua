-- Mise à jour du speedometer
function updateSpeedometer()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)  -- Vitesse en km/h
        local gear = GetVehicleCurrentGear(vehicle)
        gear = gear > 0 and tostring(gear) or 'R'
        local fuel = math.floor(GetVehicleFuelLevel(vehicle))
        local health = math.floor(GetVehicleEngineHealth(vehicle) / 10)

        SendNUIMessage({
            type = 'update',
            speed = speed,
            gear = gear,
            fuel = fuel,
            health = health
        })
    else
        SendNUIMessage({ type = 'hideSpeedometer' })
    end
end

-- Joueur monte dans un véhicule
AddEventHandler('playerEnteredVehicle', function()
    updateSpeedometer()
    Citizen.CreateThread(function()
        while IsPedInAnyVehicle(PlayerPedId(), false) do
            Citizen.Wait(500)
            updateSpeedometer()
        end
    end)
end)

-- Joueur descend du véhicule
AddEventHandler('playerLeftVehicle', function()
    SendNUIMessage({ type = 'hideSpeedometer' })
end)
