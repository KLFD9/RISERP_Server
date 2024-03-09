-- Charger le fichier JSON
local file = LoadResourceFile(GetCurrentResourceName(), "GasStations.json")
local gasStations = json.decode(file)

if gasStations then
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"System", "Le fichier GasStations.json a été chargé avec succès."}
    })
else
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"System", "Erreur lors du chargement du fichier GasStations.json."}
    })
end

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

-- Fonction pour vérifier si un joueur est proche d'une pompe à essence
function isPlayerNearGasPump(player)
    local playerPos = GetEntityCoords(player)
    for _, modelName in ipairs(props) do
        local modelHash = GetHashKey(modelName)
        local pump = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 5.0, modelHash, false, false, false)
        if pump ~= 0 then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)  -- Attendre 1 frame

        local player = GetPlayerPed(-1)

        if isPlayerNearGasPump(player) then
            print("Le joueur est près d'une pompe à essence.")  -- Message de débogage
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"System", "Vous êtes près d'une pompe à essence. Appuyez sur E pour faire le plein."}
            })

            if IsControlJustReleased(0, 38) then  -- 38 est le code de la touche E
                TriggerEvent("refuel")
            end
        end
    end
end)