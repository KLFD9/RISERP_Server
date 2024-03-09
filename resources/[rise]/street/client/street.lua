Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local player = GetPlayerPed(-1)
        local playerPos = GetEntityCoords(player)

        local streetHash, crossingHash = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
        local streetName = GetStreetNameFromHashKey(streetHash)
        local crossingName = GetStreetNameFromHashKey(crossingHash)

        local zoneName = GetNameOfZone(playerPos.x, playerPos.y, playerPos.z)

        local heading = GetEntityHeading(player)
        local direction
        if heading < 45 or heading > 315 then
            direction = "N"
        elseif heading > 45 and heading < 135 then
            direction = "W"
        elseif heading > 135 and heading < 225 then
            direction = "S"
        elseif heading > 225 and heading < 315 then
            direction = "E"
        end

        
        SendNUIMessage({
            streetName = streetName,
            crossingName = crossingName,
            zoneName = zoneName,
            direction = direction
        })
    end
end)