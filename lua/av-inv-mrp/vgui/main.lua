local PANEL = {}
local mGradientUp, mGradientDown = Material("vgui/gradient_up"), Material("vgui/gradient_down")

function PANEL:Init()
    self:MakePopup()
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetTitle("")
    self:SetDraggable(false)
    self:ShowCloseButton()
    self:SetAlpha(10)
    self:AlphaTo(255, 0.5, 0)

    local xOffset = self:GetWide() / 25

    self.pClose = vgui.Create("DButton", self)
    self.pClose:SetSize(self:GetWide() / 38.4, self:GetTall() / 21.6)
    self.pClose:SetPos(self:GetWide() - self.pClose:GetWide(), 0)
    self.pClose:SetTextColor(color_white)
    self.pClose:SetFont("Trebuchet24")
    self.pClose:SetText("X")
    self.pClose.Paint = function() end

    self.pClose.DoClick = function()
        self:Remove()
    end

    self.pPlayerView = vgui.Create("DModelPanel", self)
    self.pPlayerView:SetSize(self:GetWide() / 6, self:GetTall() / 1.75)
    self.pPlayerView:CenterVertical()
    self.pPlayerView:SetModel(LocalPlayer():GetModel())
    self.pPlayerView:SetX(self:GetWide() - self.pPlayerView:GetWide() - xOffset)

    local vSpinePos = self.pPlayerView.Entity:GetBonePosition(self.pPlayerView.Entity:LookupBone("ValveBiped.Bip01_Spine"))    
    self.pPlayerView:SetCamPos(vSpinePos-Vector(-40, 0, -5))
    
    function self.pPlayerView:LayoutEntity() end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(color_black)

    surface.SetMaterial(mGradientUp)
    surface.DrawTexturedRect(0, h / 2, w, h / 2)

    surface.SetMaterial(mGradientDown)
    surface.DrawTexturedRect(0, 0, w, h / 2)

    draw.SimpleText(Arkonfig.Inventory:getLang("inventory"), "Trebuchet24", w / 2, h / 100, color_white, 1)
end

vgui.Register("AVInv:Main", PANEL, "DFrame")

//local pInventory = vgui.Create("AVInv:Main")