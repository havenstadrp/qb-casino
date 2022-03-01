fx_version 'cerulean'
game 'gta5'

description 'QB-Casino'
version '1.0.0'

shared_script 'config.lua'

client_scripts{
	'@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
	'client/*.lua'
}

server_script 'server/main.lua'

dependency 'qb-blackjack'

lua54 'yes'