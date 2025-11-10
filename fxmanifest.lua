-- ServerBeats v1.1.0 by SEYA CODING
-- Discord: seya_coding #6497
-- Community: https://discord.gg/RT3uJRdXSC
fx_version 'cerulean'
game 'gta5'

author 'SEYA CODING'
description 'ServerBeats - Global YouTube Radio for FiveM Servers'
version '1.1.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/logo_default.gif',
    'server_logo.gif' -- optional, auto-loads server’s own logo if present
}

server_scripts {
    'config.lua',
    'server.lua'
}

client_scripts {
    'config.lua',
    'client.lua'
}
