hook.Add("PlayerButtonDown", "AVInv:PickupItem", function(pPly, nKey)
    if nKey != Arkonfig.Inventory.PickupItem then return end

    local eEnt = pPly:GetEyeTrace().Entity
    if !IsValid(eEnt) then return end

    pPly:pickupItem(eEnt)
end)

hook.Add("EntityTakeDamage", "AVInv:DurabilityOnHeadgears", function(pTarget, tDmgInfo)
    if !IsValid(pTarget) || !pTarget:IsPlayer() then return end

    local eHeadEntity = pTarget:getEquippedHeadEntity()
    if !IsValid(eHeadEntity) then return end

    Arkonfig.Inventory:damageItem(eHeadEntity, pTarget)
end)

hook.Add("PlayerInitialSpawn", "AVInv:SyncInv", function(pPly)
    Arkonfig.Inventory:getInventory(pPly:SteamID64(), function(tData)
        pPly.tInv = tData

        net.Start("AVInv:SyncInv")
            net.WriteBool(true)
            net.WriteItemsData(pPly.tInv)
        net.Send(pPly)
    end)
end)