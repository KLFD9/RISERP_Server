-- crer la command noclip afin de se deplacer librement dans la map
local noclip = false
local noclip_speed = 1.0

function toggleNoclip()
    noclip = not noclip
    local ped = PlayerPedId()
    if noclip then -- activé
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
    else -- désactivé
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
    end
end

function isNoclip()
    return noclip
end

-- thread noclip
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if noclip then
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped, true)) -- Remplace tvRP.getPosition()
            local dx,dy,dz = GetCamDirection() -- Remplace tvRP.getCamDirection()
            local speed = noclip_speed

            -- reset de la vitesse de déplacement
            SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

            -- déplacement
            if IsControlPressed(0, 32) then -- W
                x = x+speed*dx
                y = y+speed*dy
                z = z+speed*dz
            end
            if IsControlPressed(0, 269) then -- S
                x = x-speed*dx
                y = y-speed*dy
                z = z-speed*dz
            end

            -- hauteur
            if IsControlPressed(0, 10) then -- PAGEUP
                z = z+speed
            end
            if IsControlPressed(0, 11) then -- PAGEDOWN
                z = z-speed
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
    end
end)

-- Fonction pour obtenir la direction de la caméra
function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end


RegisterCommand('noclip', function(source, args, rawCommand)
    toggleNoclip()
end, false)