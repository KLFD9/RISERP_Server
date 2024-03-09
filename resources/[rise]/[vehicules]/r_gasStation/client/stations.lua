-- Charger le fichier JSON
local file = LoadResourceFile(GetCurrentResourceName(), "GasStations.json")
local gasStations = json.decode(file).GasStations

-- Créer un blip pour chaque station d'essence
for _, station in ipairs(gasStations) do
    local blip = AddBlipForCoord(station.coordinates.X, station.coordinates.Y, station.coordinates.Z)
    SetBlipSprite(blip, 361)  -- Définir l'icône du blip
    SetBlipDisplay(blip, 4)  -- Faire en sorte que le blip soit toujours visible
    SetBlipScale(blip, 1.0)  -- Définir la taille du blip
    SetBlipColour(blip, 1)  -- Définir la couleur du blip (1 pour rouge)
    SetBlipAsShortRange(blip, true)  -- Le blip ne sera visible que dans un court rayon
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Station essence")  -- Définir le nom du blip
    EndTextCommandSetBlipName(blip)
end