/*
    itemData = {
        id: Number - the identifier of the possessed item
        amount: Number - the amount of the possessed item
    }
*/

/*
    net.WriteItemData(tItem)

    Prepare an item to be networked.

    @param itemData tItem - The item to network.
*/
function net.WriteItemData(tItem)
    net.WriteUInt(tItem.id, 16)
    net.WriteUInt(tItem.amount, 16)
end

/*
    net.ReadItemData()

    Reads a networked item.

    @return itemData - The networked item
*/
function net.ReadItemData()
    local tItem = {}
    tItem.id = net.ReadUInt(16)
    tItem.amount = net.ReadUInt(16)

    return tItem
end

/*
    net.WriteItemsData(tItemsList)

    Prepare a list of items to be networked.

    @param List<itemData> tItemsList - The networked items list.
*/
function net.WriteItemsData(tItemsList)
    local nItemsCount = table.Count(tItemsList)

    net.WriteUInt(nItemsCount, 16)
    
    for idx, tItem in pairs(tItemsList) do
        net.WriteItem(tItem)
    end
end

/*
    net.ReadItemsData()

    Reads a list of networked items.

    @return List<itemData> - The networked items list
*/
function net.ReadItemsData()
    local tItemsList = {}
    local nItemsCount = net.ReadUInt(16)

    for i = 1, nItemsCount do
        tItemsList[#tItemsList + 1] = net.ReadItem()
    end

    return tItemsList
end