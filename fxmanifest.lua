fx_version "cerulean"
game "rdr3"
author 'VORP @BlackPegasus' -- refactored by outsider
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."

shared_script "@vorp_lib/import.lua"

client_scripts {
    "client.lua"
}

files {
    "imaps_with_coords_and_heading.lua",
}
