RegisterCommand('+openhood', function()
    local playerId = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerId, false) 

    if playerVehicle <= 0 then
        return
    end
    if GetPedInVehicleSeat(playerVehicle, -1) ~= playerId then
        return
    end
        if  GetVehicleDoorAngleRatio(playerVehicle, 4) > 0.1 then
            SetVehicleDoorShut(playerVehicle, 4, false)
        else
            SetVehicleDoorOpen(playerVehicle, 4, false, false)
        end
end)

-- commande pour ouvrir et fermer le coffre du vehicule
RegisterCommand('+opentrunk', function()
    local playerId = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerId, false) 

    if playerVehicle <= 0 then
        return
    end
    if GetPedInVehicleSeat(playerVehicle, -1) ~= playerId then
        return
    end
        if  GetVehicleDoorAngleRatio(playerVehicle, 5) > 0.1 then
            SetVehicleDoorShut(playerVehicle, 5, false)
        else
            SetVehicleDoorOpen(playerVehicle, 5, false, false)
        end
end)

-- Commande pour allumer/éteindre les lumières du véhicule
RegisterCommand('+togglelights', function()
    local playerId = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerId, false)

    if playerVehicle <= 0 then
        return
    end

    local lightsOn, highbeamsOn = GetVehicleLightsState(playerVehicle)
    if lightsOn == 1 and highbeamsOn == 0 then

        SetVehicleFullbeam(playerVehicle, true)
        SetVehicleLights(playerVehicle, 2) 
    elseif highbeamsOn == 1 then
       
        SetVehicleFullbeam(playerVehicle, false)
        SetVehicleLights(playerVehicle, 0)
    else
        
        SetVehicleLights(playerVehicle, 2)
    end
end)


-- Commande pour démarrer/arrêter le moteur du véhicule
RegisterCommand('+toggleengine', function()
    local playerId = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerId, false)

    if playerVehicle <= 0 then
        return
    end

    local engineStatus = GetIsVehicleEngineRunning(playerVehicle)
    SetVehicleEngineOn(playerVehicle, not engineStatus, false, true)
end)


--------------------------------------------------------------------------------
 -- Clignotants et feux de détresse
--------------------------------------------------------------------------------
RegisterCommand('+toggleleftindicator', function()
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if playerVehicle <= 0 then return end
    local vehNetId = NetworkGetNetworkIdFromEntity(playerVehicle)
    if indicatorStatus[vehNetId] == nil then
        indicatorStatus[vehNetId] = {left = false, right = false}
    end
    indicatorStatus[vehNetId].left = not indicatorStatus[vehNetId].left
    SetVehicleIndicatorLights(playerVehicle, 1, indicatorStatus[vehNetId].left)
    UpdateIndicatorStatusToUI(playerVehicle)
end)

-- Activer/désactiver le clignotant droit
RegisterCommand('+togglerightindicator', function()
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if playerVehicle <= 0 then return end
    local vehNetId = NetworkGetNetworkIdFromEntity(playerVehicle)
    if indicatorStatus[vehNetId] == nil then
        indicatorStatus[vehNetId] = {left = false, right = false}
    end
    indicatorStatus[vehNetId].right = not indicatorStatus[vehNetId].right
    SetVehicleIndicatorLights(playerVehicle, 0, indicatorStatus[vehNetId].right)
    UpdateIndicatorStatusToUI(playerVehicle)
end)

-- Activer/désactiver les feux de détresse
RegisterCommand('+togglehazardlights', function()
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if playerVehicle <= 0 then return end
    local vehNetId = NetworkGetNetworkIdFromEntity(playerVehicle)
    if indicatorStatus[vehNetId] == nil then
        indicatorStatus[vehNetId] = {left = false, right = false}
    end
    local newState = not (indicatorStatus[vehNetId].left and indicatorStatus[vehNetId].right) 
    indicatorStatus[vehNetId].left = newState
    indicatorStatus[vehNetId].right = newState
    SetVehicleIndicatorLights(playerVehicle, 1, newState)
    SetVehicleIndicatorLights(playerVehicle, 0, newState)
    UpdateIndicatorStatusToUI(playerVehicle)
end)


--------------------------------------------------------------------------------
-- Régulateur de vitesse (cruise control)
--------------------------------------------------------------------------------

local cruiseControlEnabled = false
local cruiseControlSpeed = 0
local soundId = GetSoundId()

local function disableCruiseControl(reason)
    cruiseControlEnabled = false
    cruiseControlSpeed = 0        
    local soundId = GetSoundId()
    PlaySound(soundId, "CANCEL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
end

-- Activer/désactiver le régulateur de vitesse
RegisterCommand('+togglecruisecontrol', function()
    local playerPed = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    if playerVehicle <= 0 then return end 
    local vehicleClass = GetVehicleClass(playerVehicle)
    if vehicleClass == 8 or vehicleClass == 13 then
        return
    end
    cruiseControlEnabled = not cruiseControlEnabled
    if cruiseControlEnabled then
        cruiseControlSpeed = GetEntitySpeed(playerVehicle)        
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    else
        disableCruiseControl()
    end
end)

-- Maintien de la vitesse du véhicule
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 
        if cruiseControlEnabled then
            local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if playerVehicle ~= 0 and GetIsVehicleEngineRunning(playerVehicle) then
                if IsControlPressed(0, 72) or HasEntityCollidedWithAnything(playerVehicle) then
                    disableCruiseControl()
                else
                    local currentSpeed = GetEntitySpeed(playerVehicle)
                    if math.abs(currentSpeed - cruiseControlSpeed) > 0.01 then
                        
                        if cruiseControlEnabled then
                            SetVehicleForwardSpeed(playerVehicle, cruiseControlSpeed)
                        end
                    end
                end
            else
                disableCruiseControl()
            end
        end
    end
end)

local previousCruiseControlState = false
local function disableCruiseControl(reason)
    previousCruiseControlState = cruiseControlEnabled 
    cruiseControlEnabled = false
    cruiseControlSpeed = 0
    PlaySoundFrontend(-1, "CANCEL", "HUD_MINI_GAME_SOUNDSET", true)
end

--------------------------------------------------------------------------------

RegisterKeyMapping('+togglehazardlights', 'Activer/Désactiver les warnings', 'keyboard', 'up')
RegisterKeyMapping('+togglecruisecontrol', 'Activer/Désactiver le régulateur de vitesse', 'keyboard', 'Y')
RegisterKeyMapping('+toggleleftindicator', 'Activer/Désactiver clignotant gauche', 'keyboard', 'left')
RegisterKeyMapping('+togglerightindicator', 'Activer/Désactiver clignotant droit', 'keyboard', 'right')
RegisterKeyMapping('+openhood', 'Ouvrir le capot', 'keyboard', 'PAGEUP')
RegisterKeyMapping('+opentrunk', 'Ouvrir le coffre', 'keyboard', 'PAGEDOWN')
RegisterKeyMapping('+togglelights', 'Allumer/Éteindre les lumières', 'keyboard', 'H')
RegisterKeyMapping('+toggleengine', 'Démarrer/Arrêter le moteur', 'keyboard', 'G')



----------------------------------------------------------------------------------------
-- Consommation de carburant en fonction de la vitesse et de l'accélération du véhicule
----------------------------------------------------------------------------------------

local updateInterval = 3000 
local lastUpdate = GetGameTimer()
local previousSpeed = 0.0
local previousTimestamp = GetGameTimer()


local consumptionMultiplier = 1.5

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local currentTime = GetGameTimer()
        if currentTime - lastUpdate >= updateInterval then
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if GetIsVehicleEngineRunning(vehicle) then
                    local currentSpeed = GetEntitySpeed(vehicle) * 3.6
                    local fuelLevel = GetVehicleFuelLevel(vehicle)
                    local consumptionRate

                    if currentSpeed < 0.1 then 
                        consumptionRate = 0.0001
                    else
                        
                        local deltaTime = (currentTime - previousTimestamp) / 1000.0 
                        local acceleration = (currentSpeed - previousSpeed) / deltaTime
                        consumptionRate = (0.0010 + acceleration * 0.0025 * currentSpeed) * consumptionMultiplier
                        consumptionRate = math.max(consumptionRate, 0)

                    
                    local newFuelLevel = fuelLevel - consumptionRate
                    newFuelLevel = math.max(newFuelLevel, 0)
                    local maxFuelLevel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume')
                    local fuelPercentage = (newFuelLevel / maxFuelLevel) * 100

                    SetVehicleFuelLevel(vehicle, newFuelLevel)
                    TriggerServerEvent('server:UpdateFuelLevel', newFuelLevel)
                    if newFuelLevel <= 0 then
                        SetVehicleEngineOn(vehicle, false, false, true)
                    end

                    previousSpeed = currentSpeed
                    previousTimestamp = currentTime
                end
            end
            lastUpdate = currentTime 
        end
    end
end)


----------------------------------------------------------------------------------------
-- Mise à jour de la santé globale du véhicule
----------------------------------------------------------------------------------------
local lastOverallHealth = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local normalizedEngineHealth = math.max(0, engineHealth / 10) --Moteur
            local normalizedBodyHealth = math.max(0, bodyHealth / 10) -- Carrosserie
            local overallHealth = math.floor((normalizedEngineHealth + normalizedBodyHealth) / 2) -- Moyenne des deux

            if not lastOverallHealth or math.abs(overallHealth - lastOverallHealth) >= 5 then
                print(overallHealth)
                lastOverallHealth = overallHealth
            end
        else
            if lastOverallHealth ~= nil then 
                lastOverallHealth = nil
            end
        end
    end
end)

