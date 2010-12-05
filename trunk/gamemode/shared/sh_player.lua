local _R.Player = Player

function Player:SelectItem(strItem)
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

function Player:RestoreHealth(amount)
	if self:Health() < self:GetMaxHealth() then
		self:SetHealth(math.Clamp(self:Health() + amount, 0, self:GetMaxHealth()))
		return true
	end
	return false
end

function Player:PlaySound(strSound, volume, pitch)
	self:EmitSound(strSound, volume or 100, pitch or 100)
end

function Player:FireBullets(intNumber, intSpread, intDamage)
	local tblBullet = {}
	tblBullet.Num = intNumber or 1
	tblBullet.Src = self:GetShootPos()
	tblBullet.Dir = self:GetAngles():Forward()
	tblBullet.Spread = Vector(intSpread or 0.01, intSpread or 0.01, 0)
	tblBullet.Tracer = 2
	tblBullet.Force = intDamage or 1
	tblBullet.Damage = intDamage or 1
	self:FireBullets(tblBullet)
end