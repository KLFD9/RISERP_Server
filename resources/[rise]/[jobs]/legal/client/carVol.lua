Citizen.CreateThread(function()
    local pedModel = "a_m_m_business_01" -- Replace with the desired ped model
    local pedCoords = vector3(185.58221435547, -1270.2329101562, 28.19845199585)
    
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(0)
    end
    
    local ped = CreatePed(4, pedModel, pedCoords, false, true)
    SetEntityHeading(ped, 0.0) -- Replace with the desired ped heading

    SetEntityInvincible(ped, true) -- Make the ped invincible
    SetBlockingOfNonTemporaryEvents(ped, true) -- Make the ped ignore player actions
    FreezeEntityPosition(ped, true) -- Make the ped not move

    
    SetModelAsNoLongerNeeded(pedModel)

    -- Draw a 3 meter marker around the ped
    local markerRadius = 3.0
    while true do
        Citizen.Wait(0)
        DrawMarker(1, pedCoords.x, pedCoords.y, pedCoords.z - 1.0, 0, 0, 0, 0, 0, 0, markerRadius, markerRadius, markerRadius, 255, 0, 0, 5, false, true, 2, false, false, false, false)
    end
end)

-- quand un joueur passe dans le marker, on notifie affiche un message si il sort du marker on le retire
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local pedCoords = vector3(185.58221435547, -1270.2329101562, 29.19845199585)
        local distance = #(playerCoords - pedCoords)
        if distance < 3.0 then
            TriggerEvent("r_core:showInteraction", "Appuyez sur ~INPUT_CONTEXT~ pour voler la voiture")
        else
            TriggerEvent("r_core:hideInteraction")
        end
    end
end)
