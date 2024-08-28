util.AddNetworkString("AVInv:DropItem")
util.AddNetworkString("AVInv:ToggleEquipHeadItem")
util.AddNetworkString("AVInv:SyncInv")

/*
    Arkonfig.Inventory:SyncRemoveInv(pPly, nSlot, nAmount)

    Update the inventory for the client: send an item removal.

    @param Player pPly - The player to send the sync.
    @param Number nSlot - The inv slot to remove.
    @param Number nAmount - The amount to remove.
*/
function Arkonfig.Inventory:SyncRemoveInv(pPly, nSlot, nAmount)
    net.Start("AVInv:SyncInv")
        net.WriteBool(false)
        net.WriteBool(false)
        net.WriteUInt(nSlot, 16)
        net.WriteUInt(nAmount, 16)
    net.Send(pPly)
end

/*
    Arkonfig.Inventory:SyncAddInv(pPly, nSlot, tItem)

    Update the inventory for the client: send an item adding.

    @param Player pPly - The player to send the sync.
    @param Number nSlot - The inv slot to add.
    @param itemData tItem - The item to add.
*/
function Arkonfig.Inventory:SyncAddInv(pPly, nSlot, tItem)
    net.Start("AVInv:SyncInv")
        net.WriteBool(false)
        net.WriteBool(true)
        net.WriteUInt(nSlot, 16)
        net.WriteItemData(tItem) 
    net.Send(pPly)
end

net.Receive("AVInv:DropItem", function(_, pPly)
    local nSlotId = net.ReadUInt(16)
    local nAmount = net.ReadUInt(16)

    pPly:dropItem(nSlotId, nAmount)
end)

net.Receive("AVInv:ToggleEquipHeadItem", function(_, pPly)
    local bIsEquipping = net.ReadBool()

    if bIsEquipping then
        local nSlotId = net.ReadUInt(16)
        pPly:equipHeadItem(nSlotId)
    else
        pPly:unequipHeadItem()
    end
end)