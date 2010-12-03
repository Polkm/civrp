local META = FindMetaTable("Entity")

function CIVRP_SELECTED_Update(ply) 
	umsg.Start("CIVRP_SELECTED_Update", self)
		umsg.Long(ply.ItemData["SELECTED"])
	umsg.End()	
end

function CIVRP_Item_Data_Update(ply,slot,itemstr) 
	umsg.Start("CIVRP_Item_Data_Update", self)
		umsg.Long(ply.ItemData["SELECTED"])
		umsg.Long(slot)
		if itemstr == nil then
			itemstr = "empty"
		end
		umsg.String(itemstr)
	umsg.End()	
end
 
function META:AddItem(strItem,amount)
	if CIVRP_Item_Data[strItem] == nil then
		return false
	end
	if amount == nil then
		local amount = 1
	end
	if self.ItemData == nil then
		self.ItemData = {}
	end
	local itemtbl = CIVRP_Item_Data[strItem]
	itemtbl.Class = strItem
	for slot,itemdata in pairs(self.ItemData) do
		if slot != "SELECTED" && itemdata.Class == nil then
			self.ItemData[slot] = itemtbl
			if self:IsPlayer() then
				CIVRP_Item_Data_Update(self,slot,itemtbl.Class)
			end
			break
		end
	end
	PrintTable(self.ItemData)
end

function META:RemoveItem(strItem,amount,slot)
	if amount == nil then
		local amount = 1
	end	
	if self.ItemData == nil then
		self.ItemData = {}
	end
	if slot != nil then
		self.ItemData[slot] = {}
		if self:IsPlayer() then
			CIVRP_Item_Data_Update(self,slot)
		end
	else
		for slot,itemdata in pairs(self.ItemData) do
			if slot != "SELECTED" && itemdata.Class == strItem then
				self.ItemData[slot] = {}
				if self:IsPlayer() then
					CIVRP_Item_Data_Update(self,slot,"empty")
				end
				break
			end
		end
	end
	PrintTable(self.ItemData)
	print("Removed")
end

