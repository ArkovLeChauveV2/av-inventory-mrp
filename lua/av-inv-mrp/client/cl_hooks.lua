hook.Add("PlayerButtonDown", "AVInv:OpenInv", function(pPly, nKey)
    if nKey != Arkonfig.Inventory.OpenInv || !IsFirstTimePredicted() then return end

    local pInventory = vgui.Create("AVInv:Main")
end)