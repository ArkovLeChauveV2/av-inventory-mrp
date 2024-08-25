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

    Arkonfig.Inventory.Classes = {}
    AddCSLuaFile("av-inv-mrp/enums/categories.lua")
    AddCSLuaFile("av-inv-mrp/classes/item.lua")
    AddCSLuaFile("av-inv-mrp/sh_items-loader.lua")

    include("av-inv-mrp/sh_config.lua")
    include("av-inv-mrp/enums/categories.lua")
    include("av-inv-mrp/classes/item.lua")
    include("av-inv-mrp/sh_items-loader.lua")

    include("av-inv-mrp/sv_data.lua")
    include("av-inv-mrp/sv_meta.lua")
else
    include("av-inv-mrp/sh_config.lua")
    
    Arkonfig.Inventory.Classes = {}
    include("av-inv-mrp/enums/categories.lua")
    include("av-inv-mrp/classes/item.lua")
    include("av-inv-mrp/sh_items-loader.lua")
end