RegisterNetEvent('server:UpdateFuelLevel')
AddEventHandler('server:UpdateFuelLevel', function(vehicleNetId, fuelLevel)
    local _source = source
    -- Trouve l'ID du véhicule sur le serveur à partir de l'ID du réseau envoyé par le client
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    -- Vérifie si l'entité est bien un véhicule
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        -- Mets à jour le niveau de carburant du véhicule
        -- Note: La fonction 'SetVehicleFuelLevel' est fictive et doit être remplacée par ta propre logique de gestion de carburant
        -- Ceci pourrait être une mise à jour de variable, une écriture dans un fichier, ou autre chose selon ton système
        print("Mise à jour du niveau de carburant pour le véhicule avec Net ID:", vehicleNetId, "au niveau de carburant:", fuelLevel)

        -- Envoyer une confirmation au client si nécessaire
        TriggerClientEvent('client:UpdateFuelLevelSuccess', _source, fuelLevel)
    else
        print("Erreur: Le véhicule avec le Net ID", vehicleNetId, "n'a pas été trouvé ou n'est pas un véhicule.")
    end
end)
