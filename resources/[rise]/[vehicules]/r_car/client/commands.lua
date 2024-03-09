function ShowFreemodeMessage(message, duration)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandPrint(duration, true)
end


-----------------------------------------------------------------------------------------------------------------------
-- Commande pour faire apparaitre un vehicule
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("car", function(source, args)
    local vehicleName = args[1]

    if vehicleName then
        
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local vehicleHash = GetHashKey(vehicleName)

        RequestModel(vehicleHash)
        while not HasModelLoaded(vehicleHash) do
            Citizen.Wait(10)
        end

        local vehicle = CreateVehicle(vehicleHash, playerCoords, heading, true, false)
        SetPedIntoVehicle(playerPed, vehicle, -1)

        
        local initialFuelLevel = 100.0     -- Niveau de carburant initial
        local initialEngineHealth = 1000.0 -- La santé maximale du moteur
        local initialBodyHealth = 1000.0   -- La santé maximale de la carrosserie

        SetVehicleFuelLevel(vehicle, initialFuelLevel)
        DecorSetFloat(vehicle, "_FUEL_LEVEL", initialFuelLevel) 
        SetVehicleEngineHealth(vehicle, initialEngineHealth)
        SetVehicleBodyHealth(vehicle, initialBodyHealth)

        
        local vehicleMaxSpeed = GetVehicleMaxSpeed(vehicle) * 3.6 -- Vitesse maximale en km/h
        TriggerEvent("chat:addMessage", {
            color = {255, 255, 0},
            multiline = true,
            args = {"[Car]", "Vehicle livré: " .. vehicleName .. ", Vitesse max: " .. math.floor(vehicleMaxSpeed) .. " mph"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Car]", "Nom du vehicule invalide"}
        })
    end
end)


-----------------------------------------------------------------------------------------------------------------------
-- Commande pour réparer le véhicule
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix", function()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)

    if DoesEntityExist(vehicle) then        
        local fuelLevel = GetVehicleFuelLevel(vehicle)        
        SetVehicleEngineOn(vehicle, false, false, true)        
        SetVehicleDoorOpen(vehicle, 4, false, false)        
        RequestAnimDict("mini@repair")
        while not HasAnimDictLoaded("mini@repair") do
            Citizen.Wait(0)
        end

        local health = GetEntityHealth(vehicle)
        local repairTime = (1000 - health) * 300 -- 300 ms par unité de santé

        
        ThefeedNextPostBackgroundColor(128)
        SetNotificationTextEntry("STRING")
        AddTextComponentString("Vehicle en cours de réparation, cela prendra " .. repairTime/1000 .. " secondes")
        SetNotificationMessage("CHAR_RICKIE", "CHAR_RICKIE", true, 1, "~y~Le Mécanno", "")
        DrawNotification(false, true)

        local startTime = GetGameTimer()
        SetPlayerControl(PlayerId(), false, 0)
        while GetGameTimer() - startTime < repairTime do
            if not IsEntityPlayingAnim(playerPed, "mini@repair", "fixing_a_ped", 3) then
                TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 49, 0, false, false, false)
            end
            Citizen.Wait(0)
        end

       
        ClearPedTasks(playerPed)
        SetPlayerControl(PlayerId(), true, 0)

        -- Réparer le véhicule
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        SetVehicleFuelLevel(vehicle, fuelLevel)
        ThefeedNextPostBackgroundColor(184)
        SetNotificationTextEntry("STRING")
        AddTextComponentString("Votre véhicule a été réparé, vous pouvez reprendre la route !")
        SetNotificationMessage("CHAR_RICKIE", "CHAR_RICKIE", true, 1, "~y~Le Mécanno", "")
        DrawNotification(false, true)
    else
        ThefeedNextPostBackgroundColor(6)
        SetNotificationTextEntry("STRING")
        AddTextComponentString("Pas de véhicule à proximité, ou le véhicule est trop endommagé pour être réparé !")
        SetNotificationMessage("CHAR_RICKIE", "CHAR_RICKIE", true, 1, "~y~Le Mécanno", "")
        DrawNotification(false, true)
    end
end)

-----------------------------------------------------------------------------------------------------------------------
-- Commande "estimfix" Estimation du temps de réparation
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("estimfix", function()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)

    if DoesEntityExist(vehicle) then
        local health = GetEntityHealth(vehicle)
        local repairTime = (1000 - health) * 300 -- 300 ms par unité de santé
        local time = repairTime/1000
        ThefeedNextPostBackgroundColor(128)
        SetNotificationTextEntry("STRING")
        AddTextComponentString("La réparation du véhicule peut peut prendre : " .. time .. " secondes", 5000)
        SetNotificationMessage("CHAR_RICKIE", "CHAR_RICKIE", true, 1, "~y~CHAR_RICKIE", "")
        DrawNotification(false, true)
    else
        ThefeedNextPostBackgroundColor(6)
        SetNotificationTextEntry("STRING")
        AddTextComponentString("Pas de véhicule à proximité, ou le véhicule est trop endommagé pour être réparé !", 1000)
        SetNotificationMessage("CHAR_RICKIE", "CHAR_RICKIE", true, 1, "~y~Le Mécanno", "")
        DrawNotification(false, true)
    end
end)  

---------------------------------------------------------------------------------------
-- Commande pour nettoyer le vehicule (laver)
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("clean", function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        SetVehicleDirtLevel(vehicle, 0)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"[Car]", "Vehicle nettoyé"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Car]", "Pas de véhicule trouvé"}
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------
-- Commande pour changer la couleur du vehicule
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("color", function(source, args)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local colorPrimary = tonumber(args[1])
    local colorSecondary = tonumber(args[2])

    if DoesEntityExist(vehicle) and colorPrimary and colorSecondary then
        SetVehicleColours(vehicle, colorPrimary, colorSecondary)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"[Car]", "Couleurs du véhicule modifiées"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Car]", "Pas de véhicule trouvé ou couleurs invalides"}
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------
-- Commande pour changer la plaque d'immatriculation
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("plate", function(source, args)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local plateText = args[1]

    if DoesEntityExist(vehicle) and plateText then
        SetVehicleNumberPlateText(vehicle, plateText)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"[Car]", "Plaque d'immatriculation modifiée"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Car]", "Pas de véhicule trouvé ou texte de plaque invalide"}
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------
-- Commande pour verrouiller/déverrouiller le vehicule
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("lock", function()
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 3.0, 0, 70)

    if DoesEntityExist(vehicle) then
        local isLocked = GetVehicleDoorLockStatus(vehicle) > 1
        SetVehicleDoorsLocked(vehicle, isLocked and 1 or 2)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"[Car]", isLocked and "Véhicule déverrouillé" or "Véhicule verrouillé"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Car]", "Pas de véhicule trouvé à proximité"}
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------
-- Commande "sup" pour supprimer le vehicule
-----------------------------------------------------------------------------------------------------------------------
RegisterCommand("sup", function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"[Car]", "Véhicule supprimé"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Car]", "Pas de véhicule trouvé"}
        })
    end
end)

