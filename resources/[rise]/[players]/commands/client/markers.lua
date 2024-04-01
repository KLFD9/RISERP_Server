local policeStations = {
    {x = 1851.2, y = 3683.5, z = 34.27},
    {x = -1097.1, y = -819.2, z = 19.27},
    {x = 436.1, y = -982.2, z = 30.69},    
}

Citizen.CreateThread(function()
    for _, station in ipairs(policeStations) do
        local blip = AddBlipForCoord(station.x, station.y, station.z)
        SetBlipSprite(blip, 60) -- Icône de poste de police
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 3) -- Couleur bleue
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Poste de police")
        EndTextCommandSetBlipName(blip)
    end
end)

local fireStations = {
    {x = 204.5, y = -1652.3, z = 29.8},
    {x = 1207.3, y = -1472.6, z = 34.9},
    {x = -372.4, y = 6118.5, z = 31.5},
}

Citizen.CreateThread(function()
    for _, station in ipairs(fireStations) do
        local blip = AddBlipForCoord(station.x, station.y, station.z)
        SetBlipSprite(blip, 61) -- Icône de caserne de pompiers
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 1) -- Couleur rouge
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Caserne de pompiers")
        EndTextCommandSetBlipName(blip)
    end
end)

local hospitalLocations = {
    {x = 1839.6, y = 3672.9, z = 34.27},
    {x = 298.6, y = -584.0, z = 43.27},
    {x = -449.8, y = -340.6, z = 34.27},
}

Citizen.CreateThread(function()
    for _, hospital in ipairs(hospitalLocations) do
        local blip = AddBlipForCoord(hospital.x, hospital.y, hospital.z)
        SetBlipSprite(blip, 153) -- Icône d'hôpital
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 2) -- Couleur verte
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Hôpital")
        EndTextCommandSetBlipName(blip)
    end
end)

local taxiLocations = {
    {x = 903.3, y = -179.5, z = 74.17},
}

Citizen.CreateThread(function()
    for _, taxi in ipairs(taxiLocations) do
        local blip = AddBlipForCoord(taxi.x, taxi.y, taxi.z)
        SetBlipSprite(blip, 198) -- Icône de taxi
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 5) -- Couleur jaune
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Taxi")
        EndTextCommandSetBlipName(blip)
    end
end)

local ammuNationLocations = {
    {x = 1693.4, y = 3759.5, z = 34.7},
    {x = 252.3, y = -50.0, z = 69.9},
    {x = 843.2, y = -1034.0, z = 28.1},
}

Citizen.CreateThread(function()
    for _, ammuNation in ipairs(ammuNationLocations) do
        local blip = AddBlipForCoord(ammuNation.x, ammuNation.y, ammuNation.z)
        SetBlipSprite(blip, 110) -- Icône d'armurerie
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 1) -- Couleur rouge
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Armurerie")
        EndTextCommandSetBlipName(blip)
    end
end)

local clothingStores = {
    {x = 72.3, y = -1399.1, z = 28.4},
    {x = -703.8, y = -152.3, z = 36.4},
    {x = -167.9, y = -299.0, z = 38.7},
}

Citizen.CreateThread(function()
    for _, store in ipairs(clothingStores) do
        local blip = AddBlipForCoord(store.x, store.y, store.z)
        SetBlipSprite(blip, 73) -- Icône de vêtements
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 5) -- Couleur jaune
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Magasin de vêtements")
        EndTextCommandSetBlipName(blip)
    end
end)

local barberShops = {
    {x = -814.3, y = -183.8, z = 37.6},
    {x = 136.8, y = -1708.4, z = 28.3},
    {x = -1282.6, y = -1116.8, z = 6.0},
}

Citizen.CreateThread(function()
    for _, shop in ipairs(barberShops) do
        local blip = AddBlipForCoord(shop.x, shop.y, shop.z)
        SetBlipSprite(blip, 71) -- Icône de coiffeur
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 5) -- Couleur jaune
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Coiffeur")
        EndTextCommandSetBlipName(blip)
    end
end)

local tattooShops = {
    {x = 1322.0, y = -1651.2, z = 52.2},
    {x = -1153.6, y = -1425.6, z = 4.9},
    {x = 322.1, y = 180.4, z = 103.5},
}

Citizen.CreateThread(function()
    for _, shop in ipairs(tattooShops) do
        local blip = AddBlipForCoord(shop.x, shop.y, shop.z)
        SetBlipSprite(blip, 75) -- Icône de tatoueur
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 5) -- Couleur jaune
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Tatoueur")
        EndTextCommandSetBlipName(blip)
    end
end)

local lsCustomsLocations = {
    {x = -365.4, y = -131.1, z = 37.8},
    {x = 732.1, y = -1088.6, z = 21.2},
    {x = 1174.0, y = 2645.7, z = 37.8},
}

Citizen.CreateThread(function()
    for _, lsCustoms in ipairs(lsCustomsLocations) do
        local blip = AddBlipForCoord(lsCustoms.x, lsCustoms.y, lsCustoms.z)
        SetBlipSprite(blip, 72) -- Icône de Los Santos Customs
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 5) -- Couleur jaune
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Los Santos Customs")
        EndTextCommandSetBlipName(blip)
    end
end)

local bankLocations = {
    {x = 150.1, y = -1040.6, z = 29.4},
    {x = -1212.9, y = -330.8, z = 37.8},
    {x = -2962.6, y = 482.5, z = 15.7},
}

Citizen.CreateThread(function()
    for _, bank in ipairs(bankLocations) do
        local blip = AddBlipForCoord(bank.x, bank.y, bank.z)
        SetBlipSprite(blip, 108) -- Icône de banque
        SetBlipDisplay(blip, 4) -- Afficher sur la carte et le radar
        SetBlipScale(blip, 0.8) -- Taille de l'icône
        SetBlipColour(blip, 2) -- Couleur verte
        SetBlipAsShortRange(blip, true) -- Afficher à courte distance
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Banque")
        EndTextCommandSetBlipName(blip)
    end
end)