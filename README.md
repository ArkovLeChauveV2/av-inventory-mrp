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
- Go into the addon, and lua/av-inv-mrp/sh_mysql_config.lua
- If you wanna use a database for that addon:
```lua
Arkonfig.Inventory.UseMySQLoo = true
```
- Configure the db credentials and reboot your server if it's online