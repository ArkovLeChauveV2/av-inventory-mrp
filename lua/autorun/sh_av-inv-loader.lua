Arkonfig = Arkonfig || {}
Arkonfig.Inventory = {}

if SERVER then
    local color_green = Color(0, 255, 0)
    MsgC(color_green, "======================================\n")
    MsgC(color_green, "====     AV Inventory MangaRP     ====\n")
    MsgC(color_green, "======================================\n")

    MsgC(color_green, "[av-inv-mrp] Loading base files.\n")

    resource.AddFile("materials/av-inv-mrp/key_empty.png")

    AddCSLuaFile("av-inv-mrp/sh_config.lua")

    include("av-inv-mrp/sh_config.lua")
    include("av-inv-mrp/sv_mysql_config.lua")
    include("av-inv-mrp/sv_data.lua")
else
    include("av-inv-mrp/sh_config.lua")
end