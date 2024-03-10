-- Charger le fichier JSON
local file = LoadResourceFile(GetCurrentResourceName(), "GasStations.json")
local gasStations = json.decode(file).GasStations

-- Créer un blip pour chaque station d'essence
for _, station in ipairs(gasStations) do
    local blip = AddBlipForCoord(station.coordinates.X, station.coordinates.Y, station.coordinates.Z)
    SetBlipSprite(blip, 361) 
    SetBlipDisplay(blip, 4)  
    SetBlipScale(blip, 1.0)  
    SetBlipColour(blip, 1)  
    SetBlipAsShortRange(blip, true)  
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Station essence")  
    EndTextCommandSetBlipName(blip)
end