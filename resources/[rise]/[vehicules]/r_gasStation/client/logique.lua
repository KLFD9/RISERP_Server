-- Charger le fichier JSON
local file = LoadResourceFile(GetCurrentResourceName(), "GasStations.json")
local gasStations = json.decode(file)

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

-- Fonction pour vérifier si un joueur est proche d'une pompe à essence référencée
function isPlayerNearReferencedPump(player)
    local playerPos = GetEntityCoords(player)
    -- Vérifier d'abord si près d'une pompe basée sur les modèles
    for _, modelName in ipairs(props) do
        local modelHash = GetHashKey(modelName)
        local pump = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 3.0, modelHash, false, false, false)
        if pump ~= 0 then
            -- Ensuite, vérifier la proximité avec une pompe référencée dans le JSON
            for _, pumpCoord in ipairs(gasStations.pumps) do
                local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, pumpCoord.X, pumpCoord.Y, pumpCoord.Z, true)
                if distance <= 3.0 then
                    return true
                end
            end
        end
    end
    return false
end

-- Boucle principale pour vérifier la proximité et gérer l'interaction
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)  -- Réduit la fréquence pour économiser les ressources
        local player = GetPlayerPed(-1)
        if isPlayerNearReferencedPump(player) then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"System", "Vous êtes près d'une pompe à essence. Appuyez sur E pour faire le plein."}
            })

            while IsControlJustReleased(0, 38) do  -- Touche E
                print("Le joueur a appuyé sur la touche E pour faire le plein.")  -- Message de débogage
                TriggerEvent("refuel")
                Citizen.Wait(100)  -- Petit délai pour éviter les déclenchements multiples
            end
        end
    end
end)
