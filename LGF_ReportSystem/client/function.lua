FNCS = {}


function FNCS:IsGroupAllowed(group)
    for _, allowedGroup in ipairs(Config.allowedGroups) do
        if allowedGroup == group then
            return true
        end
    end
    return false
end



function FNCS:Notification(title, msg, type, icon, position)
    lib.notify({
        title = title or nil,
        description = msg,
        type = type,
        position = 'top-right',
        icon = icon,
        duration = 6 * 1000
    })
end



