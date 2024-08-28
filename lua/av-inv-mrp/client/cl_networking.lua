Arkonfig.Inventory.LocalPlayerInv = {}

net.Receive("AVInv:SyncInv", function()
    local bIsSendingAll = net.ReadBool()

    if bIsSendingAll then
        Arkonfig.Inventory.LocalPlayerInv = net.ReadItemsData()
        return 
    end

    local bIsRemove = net.ReadBool()

    if bIsRemove then
        local nSlot = net.ReadUInt(16)
        local nAmount = net.ReadUInt(16)

        Arkonfig.Inventory.LocalPlayerInv[nSlot] = Arkonfig.Inventory.LocalPlayerInv[nSlot] || {amount = 0}

        local nNewAmount = Arkonfig.Inventory.LocalPlayerInv[nSlot].amount - nAmount

        Arkonfig.Inventory.LocalPlayerInv[nSlot] = nNewAmount > 0 && nNewAmount || nil

        return
    end

    local nSlot = net.ReadUInt(16)
    local tItem = net.ReadItemData()

    Arkonfig.Inventory.LocalPlayerInv[nSlot] = tItem
end)

/*
    Arkonfig.Inventory:dropItem(nSlot, nAmount)

    Drop an item from the inventory.

    @param Number nSlot - The inv slot to drop
    @param Number nAmount - The amount to drop
*/
function Arkonfig.Inventory:dropItem(nSlot, nAmount)
    net.Start("AVInv:DropItem")
        net.WriteUInt(nSlot, 16)
        net.WriteUInt(nAmount, 16)
    net.SendToServer()
end

/*
    Arkonfig.Inventory:equipItem(nSlot)

    Equip an item from the inventory

    @param Number nSlot - The inv slot to equip
*/
function Arkonfig.Inventory:equipItem(nSlot)
    net.Start("AVInv:ToggleEquipHeadItem")
        net.WriteBool(true)
        net.WriteUInt(nSlot, 16)
    net.SendToServer()
end

/*
    Arkonfig.Inventory:unequipItem()

    Unequip the equiped item from the inventory
*/
function Arkonfig.Inventory:unequipItem()
    net.Start("AVInv:ToggleEquipHeadItem")
        net.WriteBool(false)
    net.SendToServer()
end