local tAllItems = {}

/*
    Arkonfig.Inventory:getAllItems()

    Get all the registered items.

    @return List<Item> - The list of registered items in av-inv-mrp/items folder.
*/
function Arkonfig.Inventory:getAllItems()
    return tAllItems
end

/*
    Arkonfig.Inventory:getItemById(nId)

    Get an item by its id.

    @param Number nId - The identifier of the item.

    @return Item - The items that uses that id.
    nil if not found
*/
function Arkonfig.Inventory:getItemById(nId)
    return tAllItems[nId]
end

/*
    Arkonfig.Inventory:getItemByClass(sClass)

    Get an item by its entity class.

    @param String sClass - The class of the item.

    @return Item - The items that uses that class.
    nil if not found
*/
function Arkonfig.Inventory:getItemByClass(sClass)
    for _, v in ipairs(tAllItems) do
        if v.class == sClass then
            return v
        end
    end

    return nil
end

/*
    Arkonfig.Inventory:spawnItem(nId)

    Spawns an item by its identifier.

    @param Number nId - The identifier of the item.

    @param Vector vPos - The position to spawn the item.

    @param Angle aAng - The angle to spawn the item.

    @param Player pOwner - The owner of the spawned item.
*/
function Arkonfig.Inventory:spawnItem(nId, vPos, aAng, pOwner)
    local tItem = self:getItemById(nId)

    local eEnt = ents.Create(tItem.class)
    eEnt:SetModel(tItem.model)
    eEnt:SetPos(vPos)
    eEnt:SetAngles(aAng)
    eEnt:CPPISetOwner(pOwner || NULL)
end

local function loadAllItems()
    local tItemsFiles, tItemsFolders = file.Find("av-inv-mrp/items/*", "LUA")
    local tItemsList = tItemsFiles

    for _, sFolderName in ipairs(tItemsFolders) do
        local tFiles = file.Find("av-inv-mrp/items/" .. sFolderName .. "/*", "LUA")
        
        for _, sFileName in ipairs(tFiles) do
            tItemsList[#tItemsList + 1 ] = "av-inv-mrp/items/" .. sFolderName .. "/" .. sFileName
        end
    end

    return tItemsList
end

hook.Add( "PostGamemodeLoaded", "AVInv:LoadItems", function()
    local tItems = loadAllItems()
    
    for _, v in ipairs(tItems) do    
        if SERVER then
            AddCSLuaFile(v)
        end
    
        include(v)

        tItem = setmetatable(tItem, Arkonfig.Inventory.Classes.Item)
        tAllItems[#tAllItems + 1] = tItem
        tItem = nil
    end
end )