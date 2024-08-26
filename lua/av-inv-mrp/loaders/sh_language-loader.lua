local sSelectedLanguage = Arkonfig.Inventory.SelectedLanguage
local color_green = Color(0, 255, 0)

MsgC(color_green, "======================================\n")
MsgC(color_green, "====     AV Inventory MangaRP     ====\n")
MsgC(color_green, "====    Loading " .. sSelectedLanguage .. " translation    ====\n")
MsgC(color_green, "======================================\n")

if SERVER then
    AddCSLuaFile("av-inv-mrp/languages/" .. sSelectedLanguage .. ".lua")

    include("av-inv-mrp/languages/" .. sSelectedLanguage .. ".lua")
else
    include("av-inv-mrp/languages/" .. sSelectedLanguage .. ".lua")
end

/*
    Arkonfig.Inventory:getLang(phrase, ...)

    Get a translated phrase.

    @param String phrase - The phrase id to translate (e.g. "notEnoughSpace").
    @param varargs<String> - (optional) The words to integrate in the phrase if needed.

    @return String - The translated phrase
*/
function Arkonfig.Inventory:getLang(phrase, ...)
    local sTranslatedPhrase = Arkonfig.Inventory.Lang[phrase]
    if !... then return sTranslatedPhrase end

    return string.format(sTranslatedPhrase, ...)
end