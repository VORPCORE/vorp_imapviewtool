fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


author 'VORP @blackPegasus'
description 'A tool to view imaps in your server for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_imapviewtool'

client_scripts {
    "imaps_with_coords_and_heading.lua",
    "client.lua"
}

--dont touch
version '1.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_imapviewtool'
