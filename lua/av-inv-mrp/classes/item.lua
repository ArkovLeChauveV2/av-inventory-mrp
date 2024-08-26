// Base item metatable
// Every items follows that schema
Arkonfig.Inventory.Classes.Item = {}
Arkonfig.Inventory.Classes.Item.__index = {}


Arkonfig.Inventory.Classes.Item.__index.id = -1
// The item name will appear in the inventory
Arkonfig.Inventory.Classes.Item.__index.name = "Test Item"
// The ent class of the item (used on the item spawn)
Arkonfig.Inventory.Classes.Item.__index.class = "prop_physics"
// The model for the item (used on the item spawn)
Arkonfig.Inventory.Classes.Item.__index.model = "models/props_interiors/pot02a.mdl"
// Maximum item per stack (e.g. by default, you can make stack of 10 items)
Arkonfig.Inventory.Classes.Item.__index.MaxItemStack = 10
// Category of that item (see enums/categories.lua to see more categories)
Arkonfig.Inventory.Classes.Item.__index.category = Arkonfig.Inventory.Enums.Categories.MISC

// For head accessories, used when you equip headgears
Arkonfig.Inventory.Classes.Item.__index.pos = vector_origin // for head accessories
Arkonfig.Inventory.Classes.Item.__index.ang = angle_zero // for head accessories

// Durability of that item, the item will be destroyed on 0 durability
Arkonfig.Inventory.Classes.Item.__index.durability = -1 // -1 for no durability

// Callback when a player try to equip that item
Arkonfig.Inventory.Classes.Item.__index.onEquip = function(pPly)
end

// Callback when a player try to unequip that item
Arkonfig.Inventory.Classes.Item.__index.onUnequip = function(pPly)
end

// Callback when the item spawns (e.g. you drop that item from your inventory)
Arkonfig.Inventory.Classes.Item.__index.onSpawn = function(eEnt, tData)
end

// Callback when the item will be saved into the inventory (you should store the entities data here)
// You should return the data to store 
Arkonfig.Inventory.Classes.Item.__index.doSave = function(eEnt)
end