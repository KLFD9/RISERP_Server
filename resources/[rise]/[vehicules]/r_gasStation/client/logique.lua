-- Charger le fichier JSON des stations d'essence
local file = LoadResourceFile(GetCurrentResourceName(), "GasStations.json")
local gasStations = json.decode(file).GasStations

-- Liste des modèles de pompes à essence
local props = {
    "prop_gas_pump_1d", "prop_gas_pump_1a", "prop_gas_pump_1b",
    "prop_gas_pump_1c", "prop_vintage_pump", "prop_gas_pump_old2",
    "prop_gas_pump_old3"
}

-- Fonction pour vérifier si le joueur est près d'une pompe à essence
function isPlayerNearPump()
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player)
    for _, modelName in ipairs(props) do
        local modelHash = GetHashKey(modelName)
        local pump = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 2.0, modelHash, false, false, false)
        if pump ~= 0 then
            return true, GetEntityCoords(pump)
        end
    end
    return false
end

-- Affiche une notification
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Démarrer l'animation de remplissage
function StartRefuelingAnimation()
    local dict = "timetable@gardener@filling_can"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, "gar_ig_5_filling_can", 8.0, -8, -1, 49, 0, false, false, false)
end

-- Processus de remplissage simplifié
function RefuelProcess(vehicle)
    if not vehicle or vehicle == 0 then
        ShowNotification("Aucun véhicule détecté.")
        return
    end

    StartRefuelingAnimation()
    Citizen.Wait(2000) -- Durée de l'animation réduite à 2 secondes
    ClearPedTasksImmediately(PlayerPedId())
    
    -- Simuler le remplissage à 100%
    local maxFuelLevel = 100
    -- Pas besoin de plaque, opération directe sur l'entité du véhicule
    SetVehicleFuelLevel(vehicle, maxFuelLevel)
    ShowNotification("~g~Le véhicule est maintenant plein.")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local isNear, pumpPos = isPlayerNearPump()
        if isNear then
            local vehicle = GetClosestVehicleToPump(pumpPos)
            if vehicle and not IsPedInAnyVehicle(PlayerPedId(), false) then
                ShowNotification("~y~Appuyez sur E pour faire le plein.")
                if IsControlJustReleased(0, 38) then -- Touche E
                    RefuelProcess(vehicle)
                end
            end
        end
    end
end)

-- Fonction pour obtenir le véhicule le plus proche de la pompe à essence
function GetClosestVehicleToPump(pumpPos)
    local vehicles = GetVehiclesInArea(pumpPos, 5.0) -- Ajuste la portée au besoin
    local closestVehicle = nil
    local minDistance = math.huge

    for _, vehicle in pairs(vehicles) do
        local vehiclePos = GetEntityCoords(vehicle)
        local distance = #(vehiclePos - pumpPos)
        if distance < minDistance then
            closestVehicle = vehicle
            minDistance = distance
        end
    end
    
    return closestVehicle
end

-- Fonction pour obtenir une liste des véhicules dans une zone donnée
function GetVehiclesInArea(center, radius)
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        if #(GetEntityCoords(vehicle) - center) <= radius then
            table.insert(vehicles, vehicle)
        end
    end
    return vehicles
end

-- Itérateur pour véhicules
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

-- Fonction générique d'itération sur des entités
function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor, enum.handle = nil, nil
    end
}
