fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ent510'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/traduction.lua',
    'shared/shared.lua',
}

client_scripts {
    'client/function.lua',
    'client/menureport.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
}

files {
    'shared/core.lua'
}
