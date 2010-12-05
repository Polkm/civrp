function _R.Player:SelectItem(strItem)
	if self.ItemData == nil then
		self.ItemData = {}
		return false
	end
	for slot,itemdata in pairs(self.ItemData) do
		if slot != "SELECTED" && itemdata.Class == strItem then
			self.ItemData["SELECTED"] = slot
			break
		end
	end
	if self:GetActiveWeapon():GetClass() == "civrp_hands" then
		self:GetActiveWeapon():LoadWeapon(self.ItemData[self.ItemData["SELECTED"]])
	end
end