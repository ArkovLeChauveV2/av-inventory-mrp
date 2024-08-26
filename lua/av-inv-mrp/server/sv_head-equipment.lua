local Player = FindMetaTable("Player")

/*
    Player:getEquippedHead()

    Gets the equipped head item of the player.

    @return Number - The player's equipped head accessory's id.
    nil if no item equipped.
*/
function Player:getEquippedHead()
    return self.equippedHead
end

/*
    Player:getEquippedHeadEntity()

    Gets the equipped head item entity of the player.

    @return Number - The player's equipped head accessory's entity
    nil if no item equipped.
*/
function Player:getEquippedHeadEntity()
    return self.eHeadAcc
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

    SafeRemoveEntity(self.eHeadAcc)
    self.equippedHead = nil

    local nRemainingItems = self:addToInventory(nEquippedHeadId, 1, nDurability)
    if nRemainingItems == 0 then return end

    DarkRP.notify(self, NOTIFY_GENERIC, 3, Arkonfig.Inventory:getLang("notEnoughSpace"))

    local trace = {}
    trace.start = self:EyePos()
    trace.endpos = trace.start + self:GetAimVector() * 85
    trace.filter = self

    local tr = util.TraceLine(trace)
    local eEnt = Arkonfig.Inventory:spawnItem(tItem, tr.HitPos, angle_zero, self, nDurability)
    DarkRP.placeEntity(eEnt, tr, self)
end