Config = {}


Config.DebugEnabled        = false        -- Print Server/Client side
Config.CommandPannelReport = 'reportmenu' -- Command only for allowedGroups
Config.CommandSendReport   = 'report'     -- Command for send report
Config.WebhookReportScreen = '' -- Screen with data report
Config.CoolDownSendReport  = 15 -- Cooldown between one report and another
Config.RunSql              = true -- Create Sql table for register Report



-- Group ALlowed For Access Report Pannel
Config.allowedGroups       = {
    "admin",
    "mod",
}


-- Type Of Report
Config.TypeReport          = {
    { label = 'Bug',           value = 'bug' },
    { label = 'Report Player', value = 'ReportPlayer' },
    { label = 'Information',   value = 'information' },
}
