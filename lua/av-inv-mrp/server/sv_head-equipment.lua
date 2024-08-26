local Player = FindMetaTable("Player")

/*
    Player:getEquippedHead()

    Gets the equipped head item of the player.

    @return Item - The player's equipped head accessory.
    nil if no item equipped.
*/
function Player:getEquippedHead()
    return self.equippedHead
end

/*
    Player:equipHeadItem(nSlot)

    Equips an item.

    @param Number nSlot - The item's slot to equip from the inv
*/
function Player:equipHeadItem(nSlot)
    self:removeToSlot(nSlot, 1)

    local tItemData = self:getItemBySlot(nSlot)
    if !tItemData then return end

    local tItem = Arkonfig.Inventory:getItemById(tItemData.id)
    if !tItem then return end

    if tItem.onEquip then tItem.onEquip(self) end

    if tItem.category != Arkonfig.Inventory.Enums.Categories.HEAD then return end

    SafeRemoveEntity(self.eHeadAcc)

    self.eHeadAcc = ents.Create(tItem.class)
    self.eHeadAcc:SetPos(tItem.pos)
    self.eHeadAcc:SetAngles(tItem.ang)
    self.eHeadAcc:SetModel(tItem.model)
    self.eHeadAcc:AddEffects(EF_FOLLOWBONE)
    self.eHeadAcc:SetParent(self, self:LookupBone("ValveBiped.Bip01_Head1"))
    self.eHeadAcc:Spawn()
    self.eHeadAcc.durability = tItemData.durability || -1

    self.equippedHead = tItemData.id

    DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("itemEquipped", tItem.name))
end

/*
    Player:unequipHeadItem()

    Unequips the equiped head item.
*/
function Player:unequipHeadItem()
    local nEquippedHeadId = self:getEquippedHead()
    if !nEquippedHeadId then return end

    local tItem = Arkonfig.Inventory:getItemById(tItemData.id)
    if !tItem then return end

    if tItem.onEquip then tItem.onUnequip(self) end

    local nDurability = IsValid(self.eHeadAcc) && self.eHeadAcc.durability || -1

    local bDestroySucceed = self:destroyHeadItem()
    if !bDestroySucceed then return end

    local nRemainingItems = self:addToInventory(nEquippedHeadId, 1, nDurability)
    if nRemainingItems == 0 then return end

    DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("notEnoughSpace"))
end

/*
    Player:destroyHeadItem()

    Destroys the equiped head item.

    @return Boolean - Is the item destroyed ?
*/
function Player:destroyHeadItem()
    local nEquippedHeadId = self:getEquippedHead()
    if !nEquippedHeadId then return false end

    local tItem = Arkonfig.Inventory:getItemById(tItemData.id)
    if !tItem then return false end

    SafeRemoveEntity(self.eHeadAcc)
    self.equippedHead = nil
    
    DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("itemBroke", tItem.name))

    return true
end