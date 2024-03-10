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


indicatorStatus = {} 

RegisterCommand('+toggleleftindicator', function()
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if playerVehicle <= 0 then return end
    local vehNetId = NetworkGetNetworkIdFromEntity(playerVehicle)
    if indicatorStatus[vehNetId] == nil then
        indicatorStatus[vehNetId] = {left = false, right = false}
    end
    indicatorStatus[vehNetId].left = not indicatorStatus[vehNetId].left
    SetVehicleIndicatorLights(playerVehicle, 1, indicatorStatus[vehNetId].left)
end)

RegisterCommand('+togglerightindicator', function()
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if playerVehicle <= 0 then return end
    local vehNetId = NetworkGetNetworkIdFromEntity(playerVehicle)
    if indicatorStatus[vehNetId] == nil then
        indicatorStatus[vehNetId] = {left = false, right = false}
    end
    indicatorStatus[vehNetId].right = not indicatorStatus[vehNetId].right
    SetVehicleIndicatorLights(playerVehicle, 0, indicatorStatus[vehNetId].right)
end)

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


--------------------------------------------------------------------------------
-- Mise à jour de la consommation de carburant en fonction de la vitesse
--------------------------------------------------------------------------------

local lastUpdate = 0 
local updateInterval = 1000  
local previousTimestamp = 0  
local previousSpeed = 0  
local consumptionMultiplier = 1  

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
                    end

                    local newFuelLevel = fuelLevel - consumptionRate
                    newFuelLevel = math.max(newFuelLevel, 0)
                    local maxFuelLevel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume')
                    local fuelPercentage = (newFuelLevel / maxFuelLevel) * 100

                    -- Envoyer le niveau de carburant à l'interface utilisateur
                    SendNUIMessage({
                        type = 'update',
                        fuel = fuelPercentage
                    })

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

--------------------------------------------------------------------------------
-- Mise à jour de la santé globale du véhicule avec prise en compte de la vitesse et des impacts
----------------------------------------------------------------------------------------
local lastSpeed = 0
local healthDropOnImpact = 50

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local currentSpeed = GetEntitySpeed(vehicle) * 3.6 
            local speedDifference = math.abs(currentSpeed - lastSpeed)
            
            -- Détecter un impact
            if speedDifference >= 30 then 
                TriggerEvent('vehicleImpact', speedDifference)
            end
            
            lastSpeed = currentSpeed
        end
    end
end)

-- Gérer l'impact sur le véhicule
AddEventHandler('vehicleImpact', function(speedDifference)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle then
        local engineHealth = GetVehicleEngineHealth(vehicle)
        local bodyHealth = GetVehicleBodyHealth(vehicle)

        -- Calculer les dégâts à infliger au véhicule
        local damage = healthDropOnImpact * (speedDifference / 10)
        SetVehicleEngineHealth(vehicle, engineHealth - damage)
        SetVehicleBodyHealth(vehicle, bodyHealth - damage)

        -- Possibilité de perdre une roue sur un très gros impact
        if speedDifference >= 20 and math.random() < 0.5 then 
            local wheelID = math.random(0, 3)
            SetVehicleTyreBurst(vehicle, wheelID, true, 1000.0)
        end

        -- Affichage du niveau de santé après l'impact avec notification
        ShowNotification("~y~Impact Santé: Moteur - " .. math.floor(GetVehicleEngineHealth(vehicle) / 10) .. "%, Carrosserie - " .. math.floor(GetVehicleBodyHealth(vehicle) / 10) .. "%")
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 
        local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if playerVehicle ~= 0 and GetIsVehicleEngineRunning(playerVehicle) then
            local speed = GetEntitySpeed(playerVehicle) * 3.6  -- Convertir la vitesse en km/h
            local gear = GetVehicleCurrentGear(playerVehicle)
            local fuel = GetVehicleFuelLevel(playerVehicle)
            local health = GetVehicleEngineHealth(playerVehicle)

            -- Envoyer les informations au script speedometer
            TriggerEvent('speedometer:update', speed, gear, fuel, health)
        end
    end
end)

