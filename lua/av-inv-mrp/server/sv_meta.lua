/*
    itemData = {
        id: Number - the identifier of the possessed item
        amount: Number - the amount of the possessed item
        durability: Number - the durability of the possessed item (-1 if no durability)
        savedData: JSON - We don't network it, we only need it on the serverside
    }
*/

local Player = FindMetaTable("Player")

/*
    Player:getInventory()

    Gets the inv of the player.

    @return List<itemData> - The player's inventory.
*/
function Player:getInventory()
    return self.tInv
end

/*
    Player:getItemBySlot(nSlot)

    Gets the item's inventory of a player by slot

    @param Number nSlot - The slot to get the item.

    @return itemData - The player's item linked to the given slot.
    nil if no item found.
*/
function Player:getItemBySlot(nSlot)
    return self:getInventory()[nSlot]
end

/*
    Player:removeToSlot(nSlot, nAmount)

    Remove an item by slot from the player's inventory.

    @param Number nSlot - The inv slot to remove
    @param Number nAmount - The amount to remove

    @return Boolean - Was the remove operation successfully done ?
*/
function Player:removeToSlot(nSlot, nAmount)
    local nNewAmount = self:getInventory()[nSlot].amount - nAmount
    if self:getInventory()[nSlot] <= 0 || nNewAmount < 0 then return false end

    self:getInventory()[nSlot].amount = nNewAmount == 0 && nil || nNewAmount
    self:getInventory()[nSlot].savedData[#self:getInventory()[nSlot].savedData] = nil
    Arkonfig.Inventory:SyncRemoveInv(self, nSlot, nAmount)
    Arkonfig.Inventory:removeItemFromDB(nSlot, self:SteamID64(), nAmount)

    return true
end

/*
    Player:getSlotForItem(nId, nDurability)

    Get the better slot for an item into the inventory.

    @param Number nId - The identifier of the item.
    @param Number nDurability - The durability of the item.
    @param List tSavedData - (optional) The list of saved datas

    @return Number - An available slot in the inventory.
    nil if no slot available
*/
function Player:getSlotForItem(nId, nDurability, tSavedData)
    for i = 1, Arkonfig.Inventory.MaxInventorySize do
        local tItemData = self:getItemBySlot(i)
        if !tItemData then return i end

        local tItemConfig = Arkonfig.Inventory:getItemById(nId)
        if !tItemConfig then continue end

        if tItemData.id != nId then continue end
        if tItemData.amount >= tItemConfig.MaxItemStack then continue end
        if tItemData.durability != nDurability then continue end
        if tItemData.savedData != tSavedData then continue end

        return i
    end
    
    return nil
end

/*
    Player:addToInventory(nId, nAmount, nDurability, bShouldNotif)

    Add an item to the player's inv

    @param Number nId - The identifier of the item.
    @param Number nAmount - The amount of that item to add in the inventory.
    @param Number nDurability - The durability of the item (-1 if no durability).
    @param List tSavedData - (optional) The list of saved datas
    @param Boolean bShouldNotif - (optional) Should a notif be sent ?

    @return Number - The remaining amount that cannot be stored
*/
function Player:addToInventory(nId, nAmount, nDurability, tSavedData, bShouldNotif)
    bShouldNotif = bShouldNotif == nil && true || bShouldNotif

    local tItem = Arkonfig.Inventory:getItemById(nId)
    if !tItem then return nAmount end

    local bAllItemsStocked = false
    
    if bShouldNotif then DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("gettingItem", tItem.name, nAmount)) end

    while !bAllItemsStocked do
        local nSlot = self:getSlotForItem(nId, nDurability, tSavedData)
        if !nSlot then bAllItemsStocked = true return nAmount end
        
        local nActualAmount = self:getInventory()[nSlot].amount
        local nNewAmount = math.min(nActualAmount + nAmount, tItem.MaxItemStack)
        local tNewItem = {id = nId, amount = nNewAmount, durability = nDurability, savedData = tSavedData}

        self.tInv[nSlot] = tNewItem
        Arkonfig.Inventory:SyncAddInv(pPly, nSlot, tNewItem)
        Arkonfig.Inventory:storeItem(nSlot, self:SteamID64(), tNewItem)

        // Time to find another slot for the remaining items to store
        nAmount = nAmount - nNewAmount
    end

    return nAmount
end

/*
    Player:pickupItem(eEnt)

    Pickups an item in the player's inventory.

    @param Entity eEnt - The entity to pickup.
*/
function Player:pickupItem(eEnt)
    local tItem = Arkonfig.Inventory:getItemByClass(eEnt:GetClass())
    if !tItem then return end

    local tSavedData = tItem:doSave(eEnt)
    self:addToInventory(tItem.id, 1, eEnt.nDurability || -1, tSavedData)

    eEnt:Remove()
end

/*
    Player:dropItem(nSlot, nAmount)

    Drops an item to the ground.

    @param Number nSlot - The item's slot to drop from the inv.
    @param Number nAmount - The amount to drop.
*/
function Player:dropItem(nSlot, nAmount)
    local tItem = self:getItemBySlot(nSlot)
    if !tItem then return end

    local bSucceed = self:removeToSlot(nSlot, nAmount)
    if !bSucceed then return end
    
    DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("droppingItem", tItem.name, nAmount))

    for i = 1, nAmount do
        local trace = {}
        trace.start = ply:EyePos()
        trace.endpos = trace.start + ply:GetAimVector() * 85
        trace.filter = ply
    
        local tr = util.TraceLine(trace)

        local eEnt = Arkonfig.Inventory:spawnItem(tItem, tr.HitPos, angle_zero, self, tItem.durability)
        DarkRP.placeEntity(eEnt, tr, ply)
        tItem:onSpawn(eEnt, self.tInv[nSlot].savedData)
    end
end

/*
    Player:damageItem(nSlot, nDamage)

    Damage an item from the inventory

    @param Number nSlot - The item's slot to damage.
    @param Number nDamage - The amount of durability to remove.
*/
function Player:damageItem(nSlot, nDamage)
    local tSaveItem = self:getItemBySlot(nSlot)
    if !tSaveItem then return end

    local tItem = Arkonfig.Inventory:getItemById(tSaveItem.id)
    if !tItem then return end

    tSaveItem.durability = tSaveItem.durability - nDamage
    if tSaveItem.durability > 0 then return end
    
    DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("itemBroke", tItem.name))
    self:removeToSlot(nSlot, 1)
end