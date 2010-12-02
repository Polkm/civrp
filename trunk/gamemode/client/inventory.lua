function CIVRP_Item_Data_Update(usmg)
	local Selected = usmg:ReadLong()
	local slot = usmg:ReadLong()
	local Item = usmg:ReadString()

	if LocalPlayer().ItemData == nil then
		LocalPlayer().ItemData = {}
	end
	LocalPlayer().ItemData["SELECTED"] = Selected
	LocalPlayer().ItemData[slot] = CIVRP_Item_Data[Item] or "empty"
	PrintTable(LocalPlayer().ItemData)
end
usermessage.Hook("CIVRP_Item_Data_Update", CIVRP_Item_Data_Update )
