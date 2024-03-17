-- Verification si le joueur est dans un véhicule
local speedFactor = 3.83496 -- Facteur de conversion ressenti

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = math.floor(GetEntitySpeed(vehicle) * speedFactor)  -- Vitesse "ressentie" en km/h
            local gear = GetVehicleCurrentGear(vehicle)
            gear = gear > 0 and tostring(gear) or 'R'
            local fuel = math.floor(GetVehicleFuelLevel(vehicle))
            local health = math.floor(GetVehicleEngineHealth(vehicle) / 10)
            SendNUIMessage({
                type = 'speedometer',
                speed = speed,
                gear = gear,
                fuel = fuel,
                health = health
            })
        else
            SendNUIMessage({ type = 'hideSpeedometer' }) 
        end
    end
end)