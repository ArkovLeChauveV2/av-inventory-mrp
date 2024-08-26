local mKeyMat = Material("av-inv-mrp/key_empty.png")

function draw.KeyMatIndicator(nKey, x, y, w, h)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(mKeyMat)
    surface.DrawTexturedRect(x, y, w, h)

    draw.SimpleText(string.upper(input.GetKeyName(nKey)), "Trebuchet24", x + w / 2, y + h / 2.3, color_white, 1, 1)
end

hook.Add("HUDPaint", "ereer", function()
    local x, y = ScrW() / 1.14, ScrH() / 1.05
    local w, h = ScrW() / 48, ScrH() / 27

    draw.KeyMatIndicator(Arkonfig.Inventory.OpenInv, x, y, w, h)
    draw.SimpleText(Arkonfig.Inventory:getLang("openInv"), "Trebuchet24", x + w * 1.2, y + h / 2.23, color_white, 0, 1)
end)