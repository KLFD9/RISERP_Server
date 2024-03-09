local spawnPos = vector3(686.245, 577.950, 130.461)

AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        exports.spawnmanager:spawnPlayer({
            x = spawnPos.x,
            y = spawnPos.y,
            z = spawnPos.z,
            model = 's_m_y_blackops_01'
        }, function()
            TriggerEvent('chat:addMessage', {
                args = { 'Welcome to R.I.S.E!' }
            })
        end)
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

AddEventHandler('playerDropped', function(reason)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('r_spawn:playerDropped', coords)
end)