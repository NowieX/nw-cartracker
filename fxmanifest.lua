fx_version 'cerulean'

Description 'nw-cartracker created by nw'

game 'gta5'

ui_page "web/index.html"

shared_script {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua',
}

files {
	"web/index.html",
	"web/style.css",
	"web/script.js",
}

escrow_ignore {
	'config.lua',
	'web/index.html',
	'web/style.css',
}

lua54 'yes'