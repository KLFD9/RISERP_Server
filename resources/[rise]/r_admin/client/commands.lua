--global config
Config = {
    Admins = {}
}

-- is player admin  
function IsPlayerAdmin()
    local admin = false
    for k, v in pairs(Config.Admins) do
        if GetPlayerServerId(PlayerId()) == v then
            admin = true
            break
        end
    end
    return admin
end

-- command attribuer un role admin à un joueur
RegisterCommand('setadmin', function(source, args)
    if IsPlayerAdmin() then
        if args[1] then
            local player = GetPlayerFromServerId(tonumber(args[1]))
            if player then
                table.insert(Config.Admins, GetPlayerServerId(player))
                TriggerEvent("chat:addMessage", {
                    color = {0, 255, 0},
                    multiline = true,
                    args = {"[Admin]", "Joueur ajouté à la liste des admins"}
                })
            else
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[Admin]", "Joueur introuvable"}
                })
            end
        end
    end
end)

-- command admin noclip
RegisterCommand('noclip', function()
    if IsPlayerAdmin() then
        noclip = not noclip
        if noclip then
            SetEntityInvincible(PlayerPedId(), true)
            SetEntityVisible(PlayerPedId(), false, false)
        else
            SetEntityInvincible(PlayerPedId(), false)
            SetEntityVisible(PlayerPedId(), true, false)
        end
    end
end)

-- command admin godmode
RegisterCommand('godmode', function()
    if IsPlayerAdmin() then
        godmode = not godmode
        if godmode then
            SetEntityInvincible(PlayerPedId(), true)
        else
            SetEntityInvincible(PlayerPedId(), false)
        end
    end
end)

-- command admin heal
RegisterCommand('heal', function()
    if IsPlayerAdmin() then
        SetEntityHealth(PlayerPedId(), 200)
    end
end)

-- command heal non admin 
RegisterCommand('heal', function()
    SetEntityHealth(PlayerPedId(), 200)
end)

-- command admin tp
RegisterCommand('tp', function(source, args)
    if IsPlayerAdmin() then
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        if args[1] then
            x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
            if args[1] == "me" then
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
            elseif args[1] == "waypoint" then
                local waypoint = GetFirstBlipInfoId(8)
                if DoesBlipExist(waypoint) then
                    local waypointCoords = GetBlipInfoIdCoord(waypoint)
                    x, y, z = table.unpack(waypointCoords)
                else
                    TriggerEvent("chat:addMessage", {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"[Admin]", "Aucun waypoint trouvé"}
                    })
                end
            else
                local player = GetPlayerFromServerId(tonumber(args[1]))
                if player then
                    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(player)))
                else
                    TriggerEvent("chat:addMessage", {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"[Admin]", "Joueur introuvable"}
                    })
                end
            end
        end
        SetEntityCoordsNoOffset(PlayerPedId(), x, y, z, false, false, false, true)
    end
end)

-- command admin give weapon
RegisterCommand('giveweapon', function(source, args)
    if IsPlayerAdmin() then
        if args[1] and args[2] then
            local player = GetPlayerFromServerId(tonumber(args[1]))
            if player then
                local weapon = GetHashKey(args[2])
                GiveWeaponToPed(GetPlayerPed(player), weapon, 1000, false, true)
            else
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[Admin]", "Joueur introuvable"}
                })
            end
        end
    end
end)

-- command admin give money
RegisterCommand('givemoney', function(source, args)
    if IsPlayerAdmin() then
        if args[1] and args[2] then
            local player = GetPlayerFromServerId(tonumber(args[1]))
            if player then
                local amount = tonumber(args[2])
                if amount then
                    TriggerServerEvent("r_admin:giveMoney", GetPlayerServerId(player), amount)
                end
            else
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[Admin]", "Joueur introuvable"}
                })
            end
        end
    end
end)

-- command admin kick
RegisterCommand('kick', function(source, args)
    if IsPlayerAdmin() then
        if args[1] then
            local player = GetPlayerFromServerId(tonumber(args[1]))
            if player then
                TriggerServerEvent("r_admin:kick", GetPlayerServerId(player))
            else
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[Admin]", "Joueur introuvable"}
                })
            end
        end
    end
end)

-- command admin ban
RegisterCommand('ban', function(source, args)
    if IsPlayerAdmin() then
        if args[1] then
            local player = GetPlayerFromServerId(tonumber(args[1]))
            if player then
                TriggerServerEvent("r_admin:ban", GetPlayerServerId(player))
            else
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[Admin]", "Joueur introuvable"}
                })
            end
        end
    end
end)

-- command admin unban
RegisterCommand('unban', function(source, args)
    if IsPlayerAdmin() then
        if args[1] then
            local player = GetPlayerFromServerId(tonumber(args[1]))
            if player then
                TriggerServerEvent("r_admin:unban", GetPlayerServerId(player))
            else
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[Admin]", "Joueur introuvable"}
                })
            end
        end
    end
end)

-- Afficher la position du joueur en format vector3 dans la console client
RegisterCommand('pos', function()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    print("vector3(" .. x .. ", " .. y .. ", " .. z .. ")")
end)

-- supprimer le vehicule le plus proche du joueur
RegisterCommand('dv', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    else
        local pos = GetEntityCoords(ped)
        local nearVeh = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)
        if nearVeh ~= 0 then
            SetEntityAsMissionEntity(nearVeh, true, true)
            DeleteVehicle(nearVeh)
        end
    end
end)