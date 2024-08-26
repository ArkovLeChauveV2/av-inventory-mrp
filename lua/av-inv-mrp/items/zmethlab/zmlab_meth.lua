tItem = {}
tItem.name = "Meth"
tItem.class = "base_darkrp"
tItem.model = "models/zerochain/zmlab/zmlab_methbag.mdl"
tItem.MaxItemStack = 5

function tItem:doSave(eEnt)
	local tSavedData = {
		amount = eEnt:GetMethAmount()
	}

	return tSavedData
end

function tItem:onSpawn(eEnt, tData)
	eEnt:SetMethAmount(tData.amount)
end