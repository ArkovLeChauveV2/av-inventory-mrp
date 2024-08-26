// Base item metatable
// Every items follows that schema
Arkonfig.Inventory.Classes.Item = {}
Arkonfig.Inventory.Classes.Item.__index = {}

Arkonfig.Inventory.Classes.Item.__index.name = "Test Item"
Arkonfig.Inventory.Classes.Item.__index.class = "prop_physics"
Arkonfig.Inventory.Classes.Item.__index.model = "models/props_interiors/pot02a.mdl"
Arkonfig.Inventory.Classes.Item.__index.MaxItemStack = 10
Arkonfig.Inventory.Classes.Item.__index.category = Arkonfig.Inventory.Enums.Categories.MISC

Arkonfig.Inventory.Classes.Item.__index.pos = vector_origin // for head accessories

Arkonfig.Inventory.Classes.Item.__index.ang = angle_zero // for head accessories

Arkonfig.Inventory.Classes.Item.__index.onEquip = function(pPly)

end

Arkonfig.Inventory.Classes.Item.__index.onUnequip = function(pPly)

end

Arkonfig.Inventory.Classes.Item.__index.onSpawn = function(eEnt)

end

Arkonfig.Inventory.Classes.Item.__index.doSave = function(eEnt)

end