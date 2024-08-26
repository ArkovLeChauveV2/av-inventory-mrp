/*
    itemData = {
        id: Number - the identifier of the possessed item
        amount: Number - the amount of the possessed item
    }
*/

/*
    net.WriteItem(tItem)

    Prepare an item to be networked.

    @param itemData tItem - The item to network.
*/
function net.WriteItem(tItem)
    net.WriteUInt(tItem.id, 16)
    net.WriteUInt(tItem.amount, 16)
end

/*
    net.ReadItem()

    Reads a networked item.

    @return itemData tItem - The networked item
*/
function net.ReadItem()
    local tItem = {}
    tItem.id = net.ReadUInt(16)
    tItem.amount = net.ReadUInt(16)

    return tItem
end

/*
    net.WriteItems(tItemsList)

    Prepare a list of items to be networked.

    @param List<itemData> tItemsList - The networked items list.
*/
function net.WriteItems(tItemsList)
    local nItemsCount = table.Count(tItemsList)

    net.WriteUInt(nItemsCount, 16)
    
    for idx, tItem in pairs(tItemsList) do
        net.WriteItem(tItem)
    end
end

/*
    net.ReadItems()

    Reads a list of networked items.

    @return List<itemData> tItemsList - The networked items list
*/
function net.ReadItems()
    local tItemsList = {}
    local nItemsCount = net.ReadUInt(16)

    for i = 1, nItemsCount do
        tItemsList[#tItemsList + 1] = net.ReadItem()
    end

    return tItemsList
end