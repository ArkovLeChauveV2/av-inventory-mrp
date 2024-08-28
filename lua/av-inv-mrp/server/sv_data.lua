hook.Add("DatabaseInitialized", "AVInv:InitTables", function()
    Arkonfig.Inventory:Query(string.format([[
        CREATE TABLE IF NOT EXISTS player_inventories (
            slot_id INTEGER,
            steam_id_64 VARCHAR(17),
            item_id INTEGER NOT NULL,
            amount INTEGER NOT NULL,
            durability INTEGER NOT NULL,
            saved_data TEXT NOT NULL,
            PRIMARY KEY(slot_id, steam_id_64)
        );
    ]]))
end)

/*
    Arkonfig.Inventory:storeItem(nSlot, sSteamId64, tItemData)

    Store an item to a player's inventory.

    @param Number nSlot - The inv slot to fill.
    @param String sSteamId64 - The player's steamid to store item.
    @param List<itemData> tItemData - The itemData to store (amount, durability, item id, and saved data).
*/
function Arkonfig.Inventory:storeItem(nSlot, sSteamId64, tItemData)
    Arkonfig.Inventory:Query("SELECT item_id FROM player_inventories WHERE steam_id_64 LIKE %s AND slot_id = %i", sSteamId64, nSlot, function(tData)
        if #tData == 0 then
            local sTransformedSavedData = util.TableToJSON(tItemData.savedData)
            Arkonfig.Inventory:Query("INSERT INTO player_inventories VALUES(%i, %s, %i, %i, %i, %s)", nSlot, sSteamId64, tItemData.id, tItemData.amount, tItemData.durability, sTransformedSavedData)
        end

        local nStoredId = tData[1].item_id
        if nStoredId != tItemData.id then return end

        Arkonfig.Inventory:Query("UPDATE player_inventories SET amount = %i WHERE slot_id = %i AND steam_id_64 LIKE %s", tItemData.amount, nSlot, sSteamId64)
    end)
end

/*
    Arkonfig.Inventory:removeItemFromDB(nSlot, sSteamId64, nAmount)

    Remove the given amount in the given slot for the given steamid64 into the database.

    @param Number nSlot - The inv slot to remove.
    @param String sSteamId64 - The player's steamid to remove item.
    @param Number nAmount - The amount to remove.
*/
function Arkonfig.Inventory:removeItemFromDB(nSlot, sSteamId64, nAmount)
    Arkonfig.Inventory:Query("SELECT amount FROM player_inventories WHERE steam_id_64 LIKE %s AND slot_id = %i", sSteamId64, nSlot, function(tData)
        if #tData == 0 then return end

        local nStoredAmount = tData[1].amount
        local nNewAmount = nStoredAmount - nAmount

        if nNewAmount > 0 then
            Arkonfig.Inventory:Query("UPDATE player_inventories SET amount = %i WHERE steam_id_64 LIKE %s AND slot_id = %i", nNewAmount, sSteamId64, nSlot)
            return
        end

        Arkonfig.Inventory:Query("DELETE FROM player_inventories WHERE steam_id_64 LIKE %s AND slot_id = %i", sSteamId64, nSlot)
    end)
end

/*
    Arkonfig.Inventory:getInventory(sSteamId64, fCallback)

    Gets the inventory of a player from the database.

    @param String sSteamId64 - The player's steamid to remove item.
    @param function fCallback - The callback to execute with the inventory data.
*/
function Arkonfig.Inventory:getInventory(sSteamId64, fCallback)
    Arkonfig.Inventory:Query("SELECT * FROM player_inventories WHERE steam_id_64 LIKE %s", sSteamId64, fCallback)
end