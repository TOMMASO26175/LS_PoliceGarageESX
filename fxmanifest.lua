fx_version 'adamant'
game 'gta5'

author 'TOMMASO26175'

version '1.0.0'

description 'ns-policegarage'

client_scripts{
    "@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
    'client.lua'
}

server_script 'server.lua'
server_script '@mysql-async/lib/MySQL.lua'