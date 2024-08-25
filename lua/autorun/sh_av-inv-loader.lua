Arkonfig = Arkonfig || {}
Arkonfig.Inventory = {}

if SERVER then
    local color_green = Color(0, 255, 0)
    MsgC(color_green, "======================================\n")
    MsgC(color_green, "====     AV Inventory MangaRP     ====\n")
    MsgC(color_green, "====      Loading base files      ====\n")
    MsgC(color_green, "======================================\n")

    resource.AddFile("materials/av-inv-mrp/key_empty.png")

    AddCSLuaFile("av-inv-mrp/sh_config.lua")

    include("av-inv-mrp/sh_config.lua")
    include("av-inv-mrp/sv_data.lua")
    include("av-inv-mrp/sv_hooks.lua")
else
    include("av-inv-mrp/sh_config.lua")
end