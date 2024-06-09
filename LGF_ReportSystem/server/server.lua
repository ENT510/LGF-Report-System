Functions = {}

local NetEvent = RegisterNetEvent
local Core = require("shared.core")


if Config.RunSql then
    function Functions:GenerateSql()
        local result = MySQL.query.await('SHOW TABLES LIKE ?', { 'lgf_report' })
        if #result > 0 then
            print("The [^4lgf_report^7] table already exists in the database")
        else
            MySQL.query([[
                CREATE TABLE IF NOT EXISTS `lgf_report` (
                    `id` int(11) NOT NULL AUTO_INCREMENT,
                    `identifier` varchar(255) NOT NULL,
                    `player_name` varchar(255) NOT NULL,
                    `tipo_report` varchar(255) NOT NULL,
                    `motivo` longtext NOT NULL,
                    `data` date NOT NULL,
                    PRIMARY KEY (`id`)
                  ) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
            ]])
            print("The [^4lgf_report^7] table has been created in the database")
        end
    end
end



lib.callback.register('ent510:AllReport', function(source, zone)
    local DataReport = MySQL.query.await('SELECT * FROM `lgf_report`')
    return DataReport or warn('missing data')
end)


function Functions:ExtractIdentifiers(playerId)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local id = GetPlayerIdentifier(playerId, i)
        if string.find(id, "discord:") then
            identifiers['discord'] = id
        elseif string.find(id, "steam:") then
            identifiers['steam'] = id
        elseif string.find(id, "ip:") then
            identifiers['ip'] = id
        end
    end
    return identifiers
end

NetEvent('ent510:sendReport', function(tipoReport, motivo, imageUrl)
    local _source = source
    local playerIdentifier = Core:GetPlayerIdentifier(_source)
    local playerName = Core:GetPlayerName(_source)
    local currentDate = os.date('%Y-%m-%d %H:%M:%S')

    local insertId = MySQL.insert.await(
        'INSERT INTO lgf_report (identifier, player_name, tipo_report, motivo, data) VALUES (?, ?, ?, ?, ?)',
        { playerIdentifier, playerName, tipoReport, motivo, currentDate }
    )

    local identifiers = Functions:ExtractIdentifiers(_source)
    local discordEmbed = {
        title = string.format(Traduction.NewReportTitle, insertId),
        description = string.format(Traduction.NewReportDescription,
            identifiers['discord'] and "<@" .. identifiers['discord']:gsub("discord:", "") .. ">" or 'N/A'),
        fields = {
            { name = Traduction.PlayerField,     value = playerName,                    inline = true },
            { name = Traduction.ReportTypeField, value = tipoReport,                    inline = true },
            { name = Traduction.ReasonField,     value = motivo,                        inline = true },
            { name = Traduction.LicenseField,      value = Core:GetPlayerIdentifier(_source) or 'N/A', inline = true },
            { name = Traduction.IpField,         value = identifiers['ip'] or 'N/A',    inline = true },
        },
        color = 16711680,
        image = { url = imageUrl },
        footer = {
            text = "Creato da ENT510 • " .. currentDate,
        }
    }

    local discordEmbedJson = json.encode({ embeds = { discordEmbed } })

    PerformHttpRequest(Config.WebhookReportScreen, function(statusCode, response, headers)
    end, 'POST', discordEmbedJson, { ['Content-Type'] = 'application/json' })
end)

NetEvent('LGF_ReportSystem:DeleteReport', function(reportId)
    MySQL.rawExecute.await('DELETE FROM lgf_report WHERE id = ?', { reportId },
        function(rowsChanged)
        end)
end)

lib.callback.register('ent510:getGroupReport', function(source, name)
    local playerGroup =  Core:GetPlayerGroup(source)
    print(playerGroup)
    return playerGroup
end)

NetEvent('LGF_ReportSystem:SendNotificationAdmin', function()
    for _, playerId in ipairs(GetPlayers()) do
        local playerGroup = Core:GetPlayerGroup(playerId)
        for _, group in ipairs(Config.allowedGroups) do
            if playerGroup == group then
                TriggerClientEvent('ox_lib:notify', playerId,
                    {
                        icon = 'comments',
                        title = 'New Report',
                        position = 'top-right',
                        description = 'A new report has arrived',
                        duration = 6000
                    })
                break
            end
        end
    end
end)
