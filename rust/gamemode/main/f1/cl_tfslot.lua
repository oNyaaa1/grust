local F1Frame
sAndbox.Items = sAndbox.Items or {}
function Inventory()
end

local function OpenF1Menu()
    if IsValid(F1Frame) then F1Frame:Remove() end
    local w, h = ScrW(), ScrH()
    F1Frame = vgui.Create("DFrame")
    F1Frame:SetSize(w, h)
    F1Frame:Center()
    F1Frame:SetTitle("gRust Menu")
    F1Frame:MakePopup()
    F1Frame:SetDeleteOnClose(false)
    F1Frame.Paint = function(s, w, h) draw.RoundedBox(12, 0, 0, w, h, color_black) end
    F1FrameP = vgui.Create("DPanel", F1Frame)
    F1FrameP:SetSize(w, h - 30)
    F1FrameP:SetPos(0, 25)
    F1FrameP.Paint = function(s, w, h) draw.RoundedBox(12, 0, 0, w, h, Color(0, 0, 0, 0)) end
    local sheet = vgui.Create("DPropertySheet", F1FrameP)
    sheet:Dock(FILL)
    sheet:AddSheet("F1 Items", sheet, "icon16/box.png")
    return sheet
end

local nextToggle = 0 -- Open menu
hook.Add("PlayerButtonDown", "gRustF1Menu", function(ply, button)
    if button == KEY_F1 and ply == LocalPlayer() then
        if CurTime() < nextToggle then return end
        nextToggle = CurTime() + 0.3 -- 0.3s cooldown
        if IsValid(F1Frame) then
            F1Frame:Remove()
            F1Frame = nil
        else
            OpenF1Menu()
        end
    end
end)