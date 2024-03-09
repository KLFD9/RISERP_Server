Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)  -- Vitesse en km/h
            local gear = GetVehicleCurrentGear(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local health = GetVehicleEngineHealth(vehicle)
            SendNUIMessage({ type = 'updateSpeed', speed = speed })
            SendNUIMessage({ type = 'updateGear', gear = gear > 0 and tostring(gear) or 'R' })
            SendNUIMessage({ type = 'updateFuel', fuel = math.floor(fuel) })
            SendNUIMessage({ type = 'updateHealth', health = math.floor(health / 10) })

        else
            SendNUIMessage({ type = 'hideSpeedometer' })
        end
    end
end)