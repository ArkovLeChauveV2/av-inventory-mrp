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
    Arkonfig.Inventory:getItemIdByClass(sClass)

    Get an item id by its entity class.

    @param String sClass - The class of the item.

    @return Number - The id of the item that uses that class.
    nil if not found
*/
function Arkonfig.Inventory:getItemIdByClass(sClass)
    for nId, v in ipairs(tAllItems) do
        if v.class == sClass then
            return nId
        end
    end

    return nil
end

/*
    Arkonfig.Inventory:damageItem(eItem)

    Damage an item that is in the world.

    @param Entity eItem - The item to damage.
    @param Player pOwner - (only needed if the item is a swep) The owner of the swep.
*/
function Arkonfig.Inventory:damageItem(eItem, pOwner)
    if !IsValid(eItem) || !eItem.durability || eItem.durability == -1 then return end
    if eItem:IsWeapon() && !IsValid(pOwner) then return end
    
    local tItem = self:getItemByClass(eItem:GetClass())
    if !tItem then return end

    eItem.durability = eItem.durability - 1
    if eItem.durability > 0 then return end

    DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("itemBroke", tItem.name))

    if eItem:IsWeapon() then
        pOwner:StripWeapon(eItem:GetClass())
        return
    end

    eItem:Remove()
end

/*
    Arkonfig.Inventory:spawnItem(tItem, vPos, aAng, pOwner, nDurability)

    Spawns an item by its identifier.

    @param Item tItem - The item to spawn.
    @param Vector vPos - The position to spawn the item.
    @param Angle aAng - The angle to spawn the item.
    @param Player pOwner - The owner of the spawned item.
    @param Number nDurability - The durability of the item

    @return Entity - The spawned item
*/
function Arkonfig.Inventory:spawnItem(tItem, vPos, aAng, pOwner, nDurability)
    local eEnt = ents.Create(tItem.class)
    eEnt:SetModel(tItem.model)
    eEnt:SetPos(vPos)
    eEnt:SetAngles(aAng)
    eEnt:CPPISetOwner(pOwner || NULL)
    eEnt:Spawn()
    eEnt.nDurability = tItem.durability

    return eEnt
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