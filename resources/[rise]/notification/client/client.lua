-- Notifications

function ShowNotification(message, color, flash, saveToBrief)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    ThefeedSetNextPostBackgroundColor(color)
    EndTextCommandThefeedPostTicker(flash, saveToBrief)
end

function ShowAdvancedNotification(title, subject, msg, icon, color)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    SetNotificationMessage(icon, icon, true, 4, title, subject)
    DrawNotification(false, true)
end


