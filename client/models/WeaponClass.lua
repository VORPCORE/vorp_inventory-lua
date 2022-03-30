VORPWeapon = {}

VORPWeapon.name = nil
VORPWeapon.id = nil
VORPWeapon.propietary = nil
VORPWeapon.ammo = {}
VORPWeapon.used = false
VORPWeapon.used2 = false

VORPWeapon.UnequipWeapon = function ()
	local hash = GetHashKey(self.name)
	self.setUsed(false)
	self.setUsed2(false)

	TriggerServerEvent("vorpinventory:setUsedWeapon", id, self.getUsed(), self.getUsed2())
	self.RemoveWeaponFromPed()

	VORPUtils.cleanAmmo(self.id)
end

VORPWeapon.RemoveWeaponFromPed = function ()
	RemoveWeaponFromPed(PlayerPedId(), GetHashKey(self.name), true, 0)
end

VORPWeapon.loadAmmo = function ()
	-- Completar al final
end

VORPWeapon.getUsed = function ()
	return self.used
end

VORPWeapon.getUsed2 = function ()
	return self.used2 
end

VORPWeapon.setUsed = function (used)
	self.used = used
	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, used, self.used2)
end

VORPWeapon.setUsed2 = function (used2)
	self.used2 = used2
	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, self.used, used2)
end

VORPWeapon.getPropietary = function ()
	return self.propietary
end

VORPWeapon.setPropietary = function (propietary)
	self.propietary = propietary
end

VORPWeapon.getId = function ()
	return self.id
end

VORPWeapon.setId = function (id)
	self.id = id
end

VORPWeapon.getName = function ()
	return self.name
end

VORPWeapon.setName = function (name)
	self.name = name
end

VORPWeapon.getAllAmmo = function ()
	return self.ammo
end

VORPWeapon.getAmmo = function (type)
	if self.ammo[type] ~= nil then
		return self.ammo[type]
	end
	return 0
end

VORPWeapon.setAmmo = function (type, amount)
	self.ammo[type] = amount
	TriggerServerEvent("vorpinventory:setWeaponBullets", self.id, type, amount)
end

VORPWeapon.addAmmo = function (type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] + amount
	else
		self.ammo[type] = amount
	end
end

VORPWeapon.subAmmo = function (type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] - amount

		if self.ammo[type] <= 0 then
			self.ammo[type] = nil
		end
	end
end