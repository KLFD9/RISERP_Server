Citizen.CreateThread(function()
	while true do
		Wait(1000) -- Augmenter cette valeur
		if NetworkIsSessionStarted() then
			TriggerServerEvent('hardcap:playerActivated')
			return
		end
	end
end)