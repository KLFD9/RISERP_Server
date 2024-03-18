

-- commande weather
RegisterCommand('meteo', function(source, args)
    if IsPlayerAdmin() then
        if args[1] then
            local weather = args[1]
            if weather == "clear" then
                weather = "EXTRASUNNY"
            elseif weather == "rain" then
                weather = "RAIN"
            elseif weather == "thunder" then
                weather = "THUNDER"
            elseif weather == "smog" then
                weather = "SMOG"
            elseif weather == "fog" then
                weather = "FOGGY"
            elseif weather == "overcast" then
                weather = "OVERCAST"
            elseif weather == "clouds" then
                weather = "CLOUDS"
            elseif weather == "clearing" then
                weather = "CLEARING"
            elseif weather == "neutral" then
                weather = "NEUTRAL"
            elseif weather == "snow" then
                weather = "SNOW"
            elseif weather == "blizzard" then
                weather = "BLIZZARD"
            elseif weather == "snowlight" then
                weather = "SNOWLIGHT"
            elseif weather == "xmas" then
                weather = "XMAS"
            elseif weather == "halloween" then
                weather = "HALLOWEEN"
            end
            SetWeatherTypeNowPersist(weather)
            SetWeatherTypeNow(weather)
            SetOverrideWeather(weather)
        end
    end
end)

-- commande time hour only format 24h
RegisterCommand('time', function(source, args)
    if IsPlayerAdmin() then
        if args[1] then
            local hour = tonumber(args[1])
            if hour then
                NetworkOverrideClockTime(hour, 0, 0)
            end
        end
    end
end)

--setadmin 
RegisterCommand('setadmin', function(source, args)
    if IsPlayerAdmin() then
        if args[1] then
            local player = GetPlayerFromServerId(tonumber(args[1]))
            if player then
                TriggerServerEvent("r_admin:setadmin", GetPlayerServerId(player))
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


