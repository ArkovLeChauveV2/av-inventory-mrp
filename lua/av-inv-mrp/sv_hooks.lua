/*hook.Add("DatabaseInitialized", "AVInv:InitTables", function()
end)*/

hook.Add("PlayerButtonDown", "AVInv:PickupItem", function(pPly, nKey)
    if nKey != Arkonfig.Inventory.PickupItem then return end

    local eEnt = pPly:GetEyeTrace().Entity
    if !IsValid(eEnt) then return end

    pPly:pickupItem(eEnt)
end)

hook.Add("PlayerButtonDown", "AVInv:OpenInv", function(pPly, nKey)
    if nKey != Arkonfig.Inventory.OpenInv then return end

    pPly.nOpenInvCdown = pPly.nOpenInvCdown || 0
    if pPly.nOpenInvCdown <= CurTime() then return end

    pPly.nOpenInvCdown = CurTime() + 1

    net.Start("AVInv:OpenInv")
        net.WriteItemsData(pPly:getInventory())
    net.Send(pPly)
end)