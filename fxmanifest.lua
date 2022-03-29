game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
ui_page 'html/ui.html'


files{
   'html/**/*'
}


client_scripts{
  'client/handler/*.lua',
  'client/*.lua',
}
server_scripts {
  'server/handler/*.lua',
  'server/*.lua',
}

shared_scripts {
  "config.lua",
}
server_exports{'vorp_inventoryApi'} 
