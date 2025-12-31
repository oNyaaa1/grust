-- Material(v.Mats, "noclamp nobips")
local ls = 0
hook.Add("LoadInventory", "Inventory", function(pnl, sbox_pnl1, frm, inventory, slot)
	if IsValid(frm.btnClose) then frm.btnClose:Hide() end
	if IsValid(frm.btnMaxim) then frm.btnMaxim:Hide() end
	if IsValid(frm.btnMinim) then frm.btnMinim:Hide() end
	if IsValid(frm) then frm:SetSizable(false) end
	if IsValid(frm) then frm:SetDraggable(false) end
	
end)

sAndbox.HudHide({"CHudHealth", "CHudAmmo", "CHudWeaponSelection", "CHudSecondaryAmmo", "CHudDamageIndicator", "CHudVoiceStatus"})
hook.Add("ScoreboardShow", "MyInventory", function()
	sAndbox.InventoryMain()
	return true
end)

hook.Add("ScoreboardHide", "MyInventory", function()
	local frame = sAndbox.InventoryMain()
	if IsValid(frame) then
		frame:Remove()
		frame = nil
	end
	return true
end)