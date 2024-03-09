-- Enregistrement des informations du joueur si premiere connexion

local function savePlayerInfo(player)
    -- Check if the player is already registered
    local query = string.format("SELECT * FROM players WHERE steamID = '%s'", player.steamID)
    local result = MySQL.Sync.fetchAll(query)
    
    if #result > 0 then
        -- Player is already registered, update the last login time
        local query = string.format("UPDATE players SET dernierLogin = NOW() WHERE steamID = '%s'", player.steamID)
        MySQL.Sync.execute(query)
        print("Player info updated for steamID: " .. player.steamID)
    else
        -- Player is not registered, insert a new record
        local query = string.format("INSERT INTO players (steamID, nom, dateInscription, dernierLogin) VALUES ('%s', '%s', NOW(), NOW())",
                                    player.steamID, player.rockstarAccountId, player.nom)
        MySQL.Sync.execute(query)
        print("New player info inserted for steamID: " .. player.steamID)
    end
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local player = {
        steamID = GetPlayerIdentifier(source),
        nom = playerName,
        id = GetPlayerIdentifier(source)
    }
    
    savePlayerInfo(player)
    print("Player connecting: " .. playerName)
end)

-- A la deconnexion du joueur on met a jour les informations de position et de temps de jeu
RegisterServerEvent('r_spawn:playerDropped')
AddEventHandler('r_spawn:playerDropped', function(coords)
    local player = {
        steamID = GetPlayerIdentifier(source),
        nom = GetPlayerName(source),
        id = GetPlayerIdentifier(source)
    }
    
    local query = string.format("UPDATE players SET position = '%s', tempsDeJeu = tempsDeJeu + %d WHERE steamID = '%s'",
                                json.encode(coords), GetGameTimer(), player.steamID)
    MySQL.Sync.execute(query)
    print("Player dropped: " .. player.nom)
end)


MySQL.ready(function ()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS players (
            steamID VARCHAR(255) NOT NULL,
            nom VARCHAR(255) NOT NULL,
            prenom VARCHAR(255) NOT NULL,
            argent INT NOT NULL,
            position VARCHAR(255),
            tempsDeJeu INT,
            dateInscription TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            dernierLogin TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (steamID)
        )
    ]])
end)