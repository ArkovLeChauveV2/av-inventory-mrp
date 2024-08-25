local Player = FindMetaTable("Player")

/*
    Player:getInventory()

    Gets the inv of the player.

    @return List<Item> - The player's inventory.
*/
function Player:getInventory()
    self.tInv = self.tInv || {}
    return self.tInv
end

/*
    Player:getItemBySlot(nSlot)

    Gets the item's inventory of a player by slot

    @return Item - The player's item linked to the given slot.
    nil if no item found.
*/
function Player:getItemBySlot(nSlot)
    return self:getInventory()[nSlot]
end

/*
    Player:pickupItem(eEnt)

    Pickups an item in the player's inventory.

    @param Entity eEnt - The entity to pickup.
*/
function Player:pickupItem(eEnt)
    

    eEnt:Remove()
end

/*
    Player:dropItem(nSlot)

    Drops an item to the ground.

    @param Number nSlot - The item's slot to drop from the inv
*/
function Player:dropItem(nSlot)

end

/*
    Player:equipItem(nSlot)

    Equips an item to the ground.

    @param Number nSlot - The item's slot to equip from the inv
*/
function Player:equipItem(nSlot)

end