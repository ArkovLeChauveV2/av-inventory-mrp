net.Receive("AVInv:OpenInv", function()
    local tItemsList = net.ReadItemsData()

    /*local pInventory = vgui.Create("AVInt:Main")
    pInventory:SetSize(ScrW(), ScrH())
    pInventory:Center()
    pInventory:SetInventory(tItemsList)*/
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