FNCS = {}


function FNCS:IsGroupAllowed(group)
    for _, allowedGroup in ipairs(Config.allowedGroups) do
        if allowedGroup == group then
            return true
        end
    end
    return false
end

function FNCS:GetAdminPlayers()
    local admins = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        local playerGroup = lib.callback.await('ent510:getGroupReport', playerId)
        for _, allowedGroup in ipairs(Config.allowedGroups) do
            if playerGroup == allowedGroup then
                table.insert(admins, playerId)
                print(allowedGroup)
                break
            end
        end
    end

    return admins
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



