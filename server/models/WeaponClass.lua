VORPWeapon = {}

VORPWeapon.name = nil
VORPWeapon.id = nil
VORPWeapon.propietary = nil
VORPWeapon.charId = nil
VORPWeapon.used = false
VORPWeapon.used2 = false
VORPWeapon.ammo = {}
VORPWeapon.components = {}

VORPWeapon.setUsed = function (isUsed)
	self.used = isUsed
end

VORPWeapon.getUsed = function ()
	return self.used
end

VORPWeapon.setUsed2 = function (isUsed)
	self.used2 = isUsed
end

VORPWeapon.getUsed2 = function ()
	return self.used2
end

VORPWeapon.setPropietary = function (propietary)
	self.propietary = propietary
end

VORPWeapon.getPropietary = function ()
	return self.propietary
end

VORPWeapon.setCharid = function (charId)
	self.charId = charId
end

VORPWeapon.getCharid = function ()
	return charId
end

VORPWeapon.setId = function (id)
	self.id = id
end

VORPWeapon.getId = function ()
	return self.id
end

VORPWeapon.setName = function (name)
	self.name = name
end

VORPWeapon.getName = function ()
	return self.name
end

VORPWeapon.getAllAmmo = function ()
	return self.ammo
end

VORPWeapon.getAllComponents = function 
	return self.components
end

VORPWeapon.setComponent = function (component)
	table.insert(self.components, component)
end

VORPWeapon.quitComponent = function (component)
	local componentExists = findIndexOf(self.components, component)
	if componentExists then
		table.remove(self.componentExists, componentExists)
		return true
	end
	return false
end

VORPWeapon.getAmmo = function (type) 
	return self.ammo[type]
end

VORPWeapon.addAmmo = function (type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] + amount
	else
		self.ammo[type] = amount
	end
	exports.ghmattimysql:execute('UPDATE loadout SET ammo = @ammo WHERE id=@id', { ['ammo'] = json.encode(self.getAllAmmo()), ['id'] = self.id}, function(result) end)
end

VORPWeapon.setAmmo = function (type, amount)
	self.ammo[type] = amount
	exports.ghmattimysql:execute('UPDATE loadout SET ammo = @ammo WHERE id=@id', { ['ammo'] = json.encode(self.getAllAmmo()), ['id'] = self.id}, function(result) end)
end

VORPWeapon.subAmmo = function (type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] - amount
		
		if self.ammo[type] <= 0 then
			self.ammo[type] = nil
		end
		exports.ghmattimysql:execute('UPDATE loadout SET ammo = @ammo WHERE id=@id', { ['ammo'] = json.encode(self.getAllAmmo()), ['id'] = self.id}, function(result) end)
	end
end

function VORPWeapon.New (t)
	t = t or {}
	setmetatable(t, self)
	self.__index = self
	return t
end

local findIndexOf = function (table, value)
	for k,v in pairs(table) do
		if v == value then
			return k
		end
	end
	return false
end