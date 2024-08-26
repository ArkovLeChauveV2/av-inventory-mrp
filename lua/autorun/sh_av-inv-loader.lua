Arkonfig = Arkonfig || {}
Arkonfig.Inventory = {}

if SERVER then
    local color_green = Color(0, 255, 0)
    MsgC(color_green, "======================================\n")
    MsgC(color_green, "====     AV Inventory MangaRP     ====\n")
    MsgC(color_green, "====      Loading base files      ====\n")
    MsgC(color_green, "======================================\n")

    resource.AddFile("materials/av-inv-mrp/key_empty.png")

    AddCSLuaFile("av-inv-mrp/shared/sh_config.lua")
    AddCSLuaFile("av-inv-mrp/loaders/sh_language-loader.lua")
    AddCSLuaFile("av-inv-mrp/shared/sh_utils.lua")

    Arkonfig.Inventory.Classes = {}
    AddCSLuaFile("av-inv-mrp/enums/categories.lua")
    AddCSLuaFile("av-inv-mrp/classes/item.lua")
    AddCSLuaFile("av-inv-mrp/loaders/sh_items-loader.lua")

    AddCSLuaFile("av-inv-mrp/client/cl_networking.lua")
    AddCSLuaFile("av-inv-mrp/client/cl_draw.lua")

    include("av-inv-mrp/shared/sh_config.lua")
    include("av-inv-mrp/loaders/sh_language-loader.lua")

    include("av-inv-mrp/shared/sh_utils.lua")
    include("av-inv-mrp/enums/categories.lua")
    include("av-inv-mrp/classes/item.lua")
    include("av-inv-mrp/loaders/sh_items-loader.lua")

    include("av-inv-mrp/server/sv_sql.lua")
    include("av-inv-mrp/server/sv_data.lua")
    include("av-inv-mrp/server/sv_head-equipment.lua")
    include("av-inv-mrp/server/sv_meta.lua")
    include("av-inv-mrp/server/sv_hooks.lua")
    include("av-inv-mrp/server/sv_networking.lua")
else
    include("av-inv-mrp/shared/sh_config.lua")
    include("av-inv-mrp/loaders/sh_language-loader.lua")
    include("av-inv-mrp/shared/sh_utils.lua")
    
    Arkonfig.Inventory.Classes = {}
    include("av-inv-mrp/enums/categories.lua")
    include("av-inv-mrp/classes/item.lua")
    include("av-inv-mrp/loaders/sh_items-loader.lua")

    include("av-inv-mrp/client/cl_networking.lua")
    include("av-inv-mrp/client/cl_draw.lua")
end