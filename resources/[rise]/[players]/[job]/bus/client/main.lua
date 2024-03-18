-- Initialisation des blips pour les arrêts de bus au démarrage du script
Citizen.CreateThread(function()
    local depotCoords = vector3(464.38, -622.16, 28.5)
    createDepotBlip(depotCoords)
    addBusStopBlips() -- Appelle la fonction pour ajouter les blips
end)

-- Gère les interactions principales du joueur, y compris commencer le travail et gérer les arrêts de bus
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local jobStartCoords = vector3(442.7, -594.1, 28.5)
        if IsControlJustReleased(0, 38) and isPlayerInArea(jobStartCoords, 1.0) then
            if not onDuty then
                spawnBusAtCoords(vector3(449.48, -583.37, 28.5))
                onDuty = true
                nextStop = math.random(1, #stops) -- Sélection initiale d'un arrêt aléatoire
                proceedToNextStop() -- Immédiatement guidé vers le premier arrêt
            end
        end

        if onDuty then
            handleServiceManagement()
            DrawText3D(jobStartCoords.x, jobStartCoords.y, jobStartCoords.z, "Appuyez sur E pour commencer le travail")
        else
            DrawMarker(1, jobStartCoords.x, jobStartCoords.y, jobStartCoords.z - 1.0001, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        end
    end
end)

-- Fonction pour créer un blip pour le dépôt de bus
function createDepotBlip(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 513)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.5)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Dépôt de Bus")
    EndTextCommandSetBlipName(blip)
end

-- Gère le démarrage du travail du joueur
function handleJobStart()
    local jobStartCoords = vector3(442.7, -594.1, 28.5)
    if isPlayerInArea(jobStartCoords, 1.0) and IsControlJustReleased(0, 38) then
        spawnBusAtCoords(vector3(449.48, -583.37, 28.5))
    end
end

-- Vérifie si le joueur est dans une zone spécifiée
function isPlayerInArea(coords, radius)
    return IsEntityInArea(PlayerPedId(), coords.x - radius, coords.y - radius, coords.z - radius, coords.x + radius, coords.y + radius, coords.z + radius, true, true, 0)
end

-- Fait apparaître un bus et met le joueur dedans
function spawnBusAtCoords(coords)
    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.0) then
        local model = GetHashKey("bus")
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, -90.0, true, false)
        SetVehicleOnGroundProperly(vehicle)
        SetModelAsNoLongerNeeded(model)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
end

-- Liste des points d'arrêt
local stops = {
    vector3(307.18, -766.03, 29.82), vector3(111.00, -783.56, 31.95),
    vector3(-509.27, 19.47, 45.20), vector3(784.75, -774.98, 26.96),
    vector3(771.18, -943.68, 26.23), vector3(787.75, -1369.13, 27.00),
}

blips = {}

-- Fonction pour ajouter des blips pour les arrêts de bus
function addBusStopBlips()
    for i, stop in ipairs(stops) do
        local blip = AddBlipForCoord(stop.x, stop.y, stop.z)
        SetBlipSprite(blip, 513) -- Choisissez une icône appropriée pour les arrêts de bus
        SetBlipDisplay(blip, 4) -- Affiche le blip sur la carte et le minimap
        SetBlipScale(blip, 0.6) -- Définit la taille du blip
        SetBlipColour(blip, 2) -- Définit la couleur du blip; 2 est le bleu
        SetBlipAsShortRange(blip, true) -- Fait en sorte que le blip n'apparaisse que lorsqu'on est proche
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Arrêt de bus #"..i)
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip) -- Stocke le blip créé dans le tableau blips si vous avez besoin de les référencer plus tard
    end
end


-- Gère le service en cours, y compris les arrêts de bus et la fin de service
function handleServiceManagement()
    if onDuty then
        local playerPed = PlayerPedId()
        local currentStop = stops[nextStop]
        guideToNextStop(currentStop)
        if hasReachedStop(playerPed, currentStop) then proceedToNextStop() end
    end
end

-- Sélectionne aléatoirement le prochain arrêt de bus et met à jour le waypoint GPS
function proceedToNextStop()
    local currentStop = nextStop
    repeat
        nextStop = math.random(1, #stops)
    until nextStop ~= currentStop -- S'assure que le prochain arrêt n'est pas le même que l'arrêt actuel

    local nextStopCoords = stops[nextStop]
    showScreenMessage("Dirigez-vous vers l'arrêt de bus #" .. nextStop, 5000)
    SetNewWaypoint(nextStopCoords.x, nextStopCoords.y)
    PlaySoundFrontend(-1, "Bus_Arrive_At_Stop", "DLC_IND_BUS2_Sounds", true)
end

-- Affiche un message à l'écran
function showScreenMessage(message, duration)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandPrint(duration, true)
end

-- Fonction pour dessiner un texte 3D dans le monde
function DrawText3D(x, y, z, text)
    -- La logique de dessin du texte 3D reste inchangée
end

-- Gère le service en cours, y compris les arrêts de bus et la fin de service
function handleServiceManagement()
    local currentStop = stops[nextStop]
    guideToNextStop(currentStop)
    if hasReachedStop(PlayerPedId(), currentStop) then
        proceedToNextStop() -- Sélection et guidage vers le prochain arrêt aléatoire
    end
end

-- Guide le joueur vers le prochain arrêt de bus et affiche un marqueur au sol
function guideToNextStop(stop)
    DrawMarker(1, stop.x, stop.y, stop.z - 1.0001, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5, 255, 255, 0, 100, false, true, 2, false, false, false, false)
end

-- Vérifie si le joueur est dans une zone spécifiée autour d'un arrêt
function hasReachedStop(playerPed, stop)
    return IsEntityInArea(playerPed, stop.x-1.0, stop.y-1.0, stop.z-1.0, stop.x+1.0, stop.y+1.0, stop.z+1.0, true, true, 0)
end