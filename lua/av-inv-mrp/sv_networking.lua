util.AddNetworkString("AVInv:DropItem")
util.AddNetworkString("AVInv:ToggleEquipHeadItem")

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