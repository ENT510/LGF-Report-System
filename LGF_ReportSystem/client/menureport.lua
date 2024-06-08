---@diagnostic disable: missing-parameter
local isCommandAvailable = true
local cooldownTimer = Config.CoolDownSendReport
local lastCommandTime = 0
local Core = require('shared.core')


local ServerEvent = TriggerServerEvent

RegisterCommand(Config.CommandSendReport, function(source, args, rawCommand)
    if not isCommandAvailable then
        local playerId = source
        local currentTime = GetGameTimer()
        local elapsedTime = math.floor((currentTime - lastCommandTime) / 1000)
        local remainingTime = cooldownTimer - elapsedTime

        local notificationText = string.format(Traduction.NotifyCoolDown, remainingTime)
        FNCS:Notification(notificationText)
        return
    end

    local playerId = source

    local activePlayers = GetActivePlayers()
    local PlayerName = Core:GetName()

    local playerText = Traduction.OnlinePlayersLabel .. ' ' .. tostring(#activePlayers)

    local report = lib.inputDialog(Traduction.SelectReportType, {
        {
            type = 'select',
            label = Traduction.SelectReportType,
            options = Config.TypeReport,
            description = Traduction.SelectReportTypeDesc,
            required = true
        },
        { type = 'textarea', label = Traduction.ProvideReasonTitle, description = Traduction.ProvideReason, required = true },
        { type = 'input',    label = Traduction.NameLabel,          placeholder = PlayerName,               disabled = true, description = Traduction.NameLabelDesc },
        { type = 'input',    label = Traduction.OnlinePlayersLabel, placeholder = playerText,               disabled = true, description = Traduction.OnlinePlayersLabel },
        { type = 'checkbox', required = true,                       label = Traduction.ConfirmReportLabel },
    })

    if not report then return end

    local reportType = report[1]
    local reason = report[2]

    exports['screenshot-basic']:requestScreenshotUpload(
        'https://discord.com/api/webhooks/1216562567955087502/Yhi_d2s7VcaCxFjI9hnMaVcVodssSGmpxFQae1xrGP7MFbrLmL4iOQb3x69fqOim0ObY',
        'files[]', function(data)
            local resp = json.decode(data)

            if resp then
                local imageUrl = resp.attachments[1].url
                ServerEvent('ent510:sendReport', reportType, reason, imageUrl)

                FNCS:Notification(Traduction.NotifyReportSent, Traduction.NotifyReportSent, 'inform',
                    'fa-regular fa-envelope', 'top', playerId)


                ServerEvent('LGF_ReportSystem:SendNotificationAdmin')

                print("Screenshot uploaded successfully.")
            else
                print("Error uploading the screenshot.")
            end
        end)

    lastCommandTime = GetGameTimer()

    isCommandAvailable = false
    SetTimeout(cooldownTimer * 1000, function()
        isCommandAvailable = true
    end)
end)



RegisterCommand(Config.CommandPannelReport, function(source, args, rawCommand)
    local playerId = source
print('dwadwa')
    local playerGroup = lib.callback.await('ent510:getGroupReport', playerId)

    if FNCS:IsGroupAllowed(playerGroup) then
        local reports = lib.callback.await('ent510:AllReport', false)

        if reports and next(reports) ~= nil then
            local menuOptions = {}

            for index, report in ipairs(reports) do
                local icon = "fa-solid fa-info"
                local iconColor = '#FFFFFF'
                local label = string.format("#%d - %s: %s | %s: %s", report.id, Traduction.SelectReportType,
                    report.tipo_report,
                    Traduction.NameLabel, report.player_name)
                if report.tipo_report == 'ReportPlayer' then
                    icon = 'fas fa-user'
                    iconColor = '#FF0000'
                elseif report.tipo_report == 'bug' then
                    icon = 'fas fa-bug'
                    iconColor = '#808080'
                end

                local menuOption = {
                    label = label,
                    icon = icon,
                    iconColor = iconColor,
                    args = { reportId = report.id }
                }

                menuOption.onSelected = function(selected, _, args)
                    print("Selected Report:", args.reportId)
                    local Allert = lib.alertDialog({
                        header = Traduction.ReportDetailsHeader,
                        content = 'ID: ' .. tostring(report.id) .. '                        \n' ..
                            Traduction.ReportedByLabel .. ': ' .. report.player_name .. '              \n' ..
                            Traduction.ReportTypeLabel .. ': ' .. report.tipo_report .. '                         \n' ..
                            Traduction.ReportReasonLabel .. ': ' .. report.motivo,
                        centered = true,
                        size = 'xs',
                        cancel = true,
                        labels = {
                            confirm = Traduction.DeleteReportConfirm,
                            cancel = Traduction.Cancel
                        }
                    })


                    if Allert == 'cancel' then
                        return print('Report viewing canceled.')
                    else
                        local AllertConfirm = lib.alertDialog({
                            header = Traduction.DeleteReportHeader,
                            content = 'ID: ' .. tostring(report.id),
                            centered = true,
                            size = 'xs',
                            cancel = true,
                            labels = {
                                confirm = Traduction.DeleteReportConfirm .. ' #' .. tostring(report.id),
                                cancel = Traduction.Cancel
                            }
                        })
                        if AllertConfirm == 'cancel' then return end
                        FNCS:Notification(Traduction.ReportDeletedNotify, Traduction.ReportDeletedNotify, 'inform',
                            'fa-regular fa-envelope', 'top')
                        ServerEvent('LGF_ReportSystem:DeleteReport', args.reportId)
                    end
                end

                table.insert(menuOptions, menuOption)
            end

            local menuCallback = function(selected, _, args)
                menuOptions[selected].onSelected(selected, _, args)
            end

            lib.registerMenu({
                id = 'menuReport',
                title = Traduction.ReportMenuTitle,
                position = 'top-left',
                options = menuOptions
            }, menuCallback)

            lib.showMenu('menuReport')
        else
            FNCS:Notification(Traduction.NoReportsTitle, Traduction.NoReportsMessage, 'inform', 'fa-regular fa-envelope',
                'top')
        end
    else
        FNCS:Notification(Traduction.NoAccessTitle, Traduction.NoAccessMessage, 'warning',
            "fa-solid fa-triangle-exclamation")
    end
end)
