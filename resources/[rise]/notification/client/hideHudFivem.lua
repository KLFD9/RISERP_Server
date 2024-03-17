Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 

        -- Cacher les composants de l'HUD d'Origine
        HideHudComponentThisFrame(6)  -- Vehicle Name
        HideHudComponentThisFrame(7)  -- Area Name
        HideHudComponentThisFrame(8)  -- Vehicle Class
        HideHudComponentThisFrame(9)  -- Street Name
    end
end)