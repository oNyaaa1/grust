-- Material(v.Mats, "noclamp nobips")
hook.Add("LoadInventory", "Inventory", function(pnl, sbox_pnl1, sbox_pnl2, frm, inventory)
	if IsValid(frm.btnClose) then frm.btnClose:Hide() end
	if IsValid(frm.btnMaxim) then frm.btnMaxim:Hide() end
	if IsValid(frm.btnMinim) then frm.btnMinim:Hide() end
	frm:SetSizable(false)
	frm:SetDraggable(false)
	for k, v in pairs(inventory) do
		local slot = v.Slot
		if not sAndbox.tnkSlots[slot] then
			print(v.Mats,slot)
			//local img = vgui.Create("DImageButton", sbox_pnl2[v.Slot])
			//img:SetImage(v.Mats)
			//img:SetSize(90, 86)
			//sAndbox.tnkSlots[slot] = true
		end
	end
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