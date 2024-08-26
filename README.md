# av-inventory-mrp
Inventory addon made for the certification in MangaRP server.

## Requirements
If you wanna link the addon to a sql database, you'll have to use mysqloo.

Click [here](https://github.com/FredyH/MySQLOO) to open the mysqloo repository.

## Installation
- Put the addon into your addons folder

## Base configuration
- Go into the addon, and lua/av-inv-mrp/sh_config.lua
- Update the configuration, the configuration is documented

## Database configuration
By default, the addon is running on sqlite (sv.db from the server root) but you can link that addon with a database.
- Go into the addon, and lua/av-inv-mrp/sh_config.lua
- If you wanna use a database for that addon:
```lua
Arkonfig.Inventory.UseMySQLoo = true
```
- Launch your server, you should have that error if you configure it for the first time:
```
[av-inv-mrp] Empty database credentials.
[av-inv-mrp] Goto mangarp/av-inv-mrp-credentials.json and fill the credentials.
[av-inv-mrp] The addon will use sqlite until you'll fix that.
```
- Goto data/mangarp/av-inv-mrp-credentials.json and fill your credentials

## Create an item
To create an item, go into lua/av-inv-mrp/items, and you can either create your lua file here, or into a folder if you wanna correctly organize your items.

To see all the variables you can put into an item, go to lua/av-inv-mrp/classes/item.lua (the file is documented).

## Create a new language
Goto lua/av-inv-mrp/languages, copy/paste an existing language file (e.g. en.lua) and change en to your country code.
When your language is ready, update the config
```lua
Arkonfig.Inventory.SelectedLanguage = "put your country code here"
```

## Manually manage durability of item
- If the item is in the world (on the player's head, or sweps) use that function:
```lua
Arkonfig.Inventory:damageItem(eItem, pOwner)
```
Works with sweps and entities.
If the durability reaches 0, the item will be removed.
If the durability is equal to -1 (no durability on item) nothing happens.

- If the item is in the player's inventory use that function:
```lua
Player:damageItem(nSlot, nDamage)
```
Be careful, if there is more than one item on the given slot, the damaged item will change slot.
If there is not enough space in the inventory, the item will get back on the ground.

## Compatibility with other addons
If you wanna create an entity that should store values (e.g. If you wanna create an inventory item for the meth from Zero's Methlab, you should store his weight and his purity percent).

By default, the compatibility with zero's drug lab 1 is provided.