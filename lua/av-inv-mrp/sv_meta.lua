/*
    itemData = {
        id: Number - the identifier of the possessed item
        amount: Number - the amount of the possessed item
        durability: Number - the durability of the possessed item (-1 if no durability)
    }
*/

local Player = FindMetaTable("Player")

/*
    Player:getInventory()

    Gets the inv of the player.

    @return List<itemData> - The player's inventory.
*/
function Player:getInventory()
    self.tInv = self.tInv || {}
    return self.tInv
end

/*
    Player:getItemBySlot(nSlot)

    Gets the item's inventory of a player by slot

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

    return true
end

/*
    Player:getSlotForItem(nId)

    Get the better slot for an item into the inventory.

    @param Number nId - The identifier of the item.

    @return Number - An available slot in the inventory.
    nil if no slot available
*/
function Player:getSlotForItem(nId)
    for i = 1, Arkonfig.Inventory.MaxInventorySize do
        local tItemData = self:getItemBySlot(i)
        if !tItemData then return i end

        local tItemConfig = Arkonfig.Inventory:getItemById(nId)
        if !tItemConfig then continue end

        if tItemData.id != nId then continue end
        if tItemData.amount >= tItemConfig.MaxItemStack then continue end

        return i
    end
    
    return nil
end

/*
    Player:addToInventory(nId, nAmount, nDurability)

    Add an item to the player's inv

    @param Number nId - The identifier of the item.
    @param Number nAmount - How much items do you wanna add ?.
    @param Number nDurability - The durability of the item (-1 if no durability).
*/
function Player:addToInventory(nId, nAmount, nDurability)
    local tItem = Arkonfig.Inventory:getItemById(nId)
    if !tItem then return end

    local bAllItemsStocked = false

    while !bAllItemsStocked do
        local nSlot = self:getSlotForItem(nId)
        if !nSlot then bAllItemsStocked = true return end
        
        local nActualAmount = self:getInventory()[nSlot].amount
        local nNewAmount = math.min(nActualAmount + nAmount, tItem.MaxItemStack)
        self.tInv[nSlot] = {id = nId, amount = nNewAmount, durability = nDurability}
    end
end

/*
    Player:pickupItem(eEnt)

    Pickups an item in the player's inventory.

    @param Entity eEnt - The entity to pickup.
*/
function Player:pickupItem(eEnt)
    local nId = Arkonfig.Inventory:getItemIdByClass(eEnt:GetClass())
    if !nId then return end

    self:addToInventory(nId, 1, eEnt.nDurability || -1)

    eEnt:Remove()
end

/*
    Player:dropItem(nSlot)

    Drops an item to the ground.

    @param Number nSlot - The item's slot to drop from the inv.
    @param Number nAmount - The amount to drop.
*/
function Player:dropItem(nSlot, nAmount)
    local tItem = self:getItemBySlot(nSlot)
    if !tItem then return end

    local bSucceed = self:removeToSlot(nSlot, nAmount)
    if !bSucceed then return end

    for i = 1, nAmount do
        local trace = {}
        trace.start = ply:EyePos()
        trace.endpos = trace.start + ply:GetAimVector() * 85
        trace.filter = ply
    
        local tr = util.TraceLine(trace)

        local eEnt = Arkonfig.Inventory:spawnItem(tItem, tr.HitPos, angle_zero, self, tItem.durability)

        DarkRP.placeEntity(eEnt, tr, ply)
    end
end