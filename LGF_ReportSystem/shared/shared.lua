Config = {}


Config.DebugEnabled        = false        -- Print Server/Client side
Config.CommandPannelReport = 'reportmenu' -- Command only for allowedGroups
Config.CommandSendReport   = 'report'     -- Command for send report
Config.WebhookReportScreen = 'https://discord.com/api/webhooks/1217899692982276228/lbg44jw4gYA8ykW5n8qL8RDUJHZFDWvPPysVNuuVasJgmFRkKjpAA9mdDbnWoGBRdqlQ' -- Screen with data report
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
