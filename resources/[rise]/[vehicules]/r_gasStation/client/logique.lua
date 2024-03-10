-- Charger le fichier JSON
local file = LoadResourceFile(GetCurrentResourceName(), "GasStations.json")
local data = json.decode(file)
local gasStations = data.GasStations  -- Accéder au tableau GasStations

-- Liste des modèles de pompes à essence
local props = {
    "prop_gas_pump_1d",
    "prop_gas_pump_1a",
    "prop_gas_pump_1b",
    "prop_gas_pump_1c",
    "prop_vintage_pump",
    "prop_gas_pump_old2",
    "prop_gas_pump_old3"
}

local nearPump = false
local soundPlayed = false

-- Fonction pour vérifier si un joueur est proche d'une pompe à essence référencée
function isPlayerNearReferencedPump(player)
    local playerPos = GetEntityCoords(player)
    for _, modelName in ipairs(props) do
        local modelHash = GetHashKey(modelName)
        local pump = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 3.0, modelHash, false, false, false)
        if pump ~= 0 then
            for _, station in ipairs(gasStations) do
                for _, pumpCoord in ipairs(station.pumps) do
                    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, pumpCoord.X, pumpCoord.Y, pumpCoord.Z, true)
                    if distance <= 2.0 then
                        -- Vérifier si un véhicule est près de la pompe
                        local vehicle = GetClosestVehicle(pumpCoord.X, pumpCoord.Y, pumpCoord.Z, 4.0, 0, 70)
                        if vehicle ~= 0 then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- Fonction pour afficher une notification
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Événement pour vérifier la proximité d'une pompe à essence
RegisterNetEvent('checkForGasPump')
AddEventHandler('checkForGasPump', function()
    local player = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(player, false) and isPlayerNearReferencedPump(player) then
        if not nearPump then
            ShowNotification("~y~Appuyez sur E pour faire le plein.")
            nearPump = true  
        end
        if not soundPlayed then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
            soundPlayed = true  
        end
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if IsControlJustReleased(0, 38) then  -- Touche E
                    ShowNotification("~g~Vous faites le plein.") 
                    print("Le joueur a appuyé sur la touche E pour faire le plein.")
                    TriggerEvent("refuel")
                    break
                end
            end
            nearPump = false  
            soundPlayed = false 
        end)
    else
        nearPump = false 
        soundPlayed = false  
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)  -- Continue à vérifier toutes les 3 secondes
        TriggerEvent('checkForGasPump')
    end
end)

-- Définir l'animation de remplissage
function StartRefuelingAnimation(player)
    local dict = "timetable@gardener@filling_can"
    local anim = "gar_ig_5_filling_can"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    
    TaskPlayAnim(player, dict, anim, 8.0, -8, -1, 49, 0, false, false, false)
end

-- Événement pour le processus de ravitaillement
RegisterNetEvent('startRefueling')
AddEventHandler('startRefueling', function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    if vehicle and not IsPedInAnyVehicle(player, true) and isPlayerNearReferencedPump(player) then
        local maxFuelLevel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume')        
        StartRefuelingAnimation(player)        
        Citizen.Wait(5000)
        ClearPedTasksImmediately(player)
        SetVehicleFuelLevel(vehicle, maxFuelLevel)
        TriggerServerEvent('server:UpdateFuelLevel', vehicle, maxFuelLevel)
        ShowNotification("~g~Le véhicule est maintenant plein.")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 38) then -- E key
            local player = GetPlayerPed(-1)
            if isPlayerNearReferencedPump(player) then
                TriggerEvent('startRefueling')
            end
        end
    end
end)


