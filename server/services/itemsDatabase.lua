---@alias sourceId string
---@alias itemId string
---@alias weaponId string
---@alias invId string
---@alias identifier string
---@alias charId number

---@type table<invId, table<sourceId, table<itemId, Item>>|table<itemId, Item>>
UsersInventories = {
	default = {}
}

---@type table<invId, table<weaponId, Weapon>>
UsersWeapons = {
	default = {}
}

-- The array UserWeaponsByCharId is optimized to allow fast access instead of looping through all the weapons to filter
-- them by the identifier and char id. If the server knows thousands of weapons (cached in UsersWeapons) each time if
-- e.g. InventoryAPI.getUserWeapons() is called, it would have to loop through all the weapons to filter them and this
-- would take a lot of time.
--
-- Important: UserWeaponsByCharId store the weaponId instead of the whole weapon object. This is because the weapon
-- object is already stored in UsersWeapons and it would be redundant to store it again.

---@type table<invId, table<charId, table<weaponId,boolean>>>
UserWeaponsByCharId = {
    default = {}
}

---@param invId invId
---@param weapon Weapon
function _addWeaponToCache(invId, weapon)

    local weaponId = weapon:getId()
    local charId = weapon:getCharId()

    if not UsersWeapons[invId] then
        UsersWeapons[invId] = {}
    end

    UsersWeapons[invId][weaponId] = weapon

    if not UserWeaponsByCharId[invId] then
        UserWeaponsByCharId[invId] = {}
    end

    if not UserWeaponsByCharId[invId][charId] then
        UserWeaponsByCharId[invId][charId] = {}
    end

    UserWeaponsByCharId[invId][charId][weaponId] = true
end

---@param invId invId
---@param weapon Weapon
function _removeWeaponFromCache(invId, weapon)

    if not weapon then
        return
    end

    weapon:setPropietary('') -- Reset identifier (old way to delete weapons)

    local weaponId = weapon:getId()
    local charId = weapon:getCharId()

    if _existsWeaponInCache(invId, weaponId) then
        UsersWeapons[invId][weaponId] = nil
    end

    if _existsWeaponInCache(invId, charId, weaponId) then
        UserWeaponsByCharId[invId][charId][weaponId] = nil
    end
end

---@param invId invId
---@param charId number
---@return Weapon[]
function _getWeaponsFromCacheByCharId(invId, charId)

    local weaponsIdsOfChar = (UserWeaponsByCharId[invId] or {})[charId] or {}

    ---@type Weapon[]
    local charWeapons = {}

    for weaponId, _ in pairs(weaponsIdsOfChar) do
        if UsersWeapons[invId] and UsersWeapons[invId][weaponId] then
            table.insert(charWeapons, UsersWeapons[invId][weaponId])
        end
    end

    return charWeapons
end

---@param invId invId
---@param weaponId weaponId
---@return boolean
function _existsWeaponInCache(invId, weaponId)
    return UsersWeapons[invId] ~= nil and UsersWeapons[invId][weaponId] ~= nil
end

---@param invId invId
---@param charId charId
---@param weaponId weaponId
---@return boolean
function _existsCharWeaponInCache(invId, charId, weaponId)
    return UserWeaponsByCharId[invId] ~= nil and UserWeaponsByCharId[invId][charId] ~= nil and UserWeaponsByCharId[invId][charId][weaponId] == true
end

---@param weaponId weaponId
---@param sourceInvId invId
---@param targetInvId invId
---@param targetCharId charId
---@param targetIdentifier identifier|nil
function _transferCachedWeapon(weaponId, sourceInvId, targetInvId, targetCharId, targetIdentifier)

    local weapon = UsersWeapons[sourceInvId][weaponId]
    _removeWeaponFromCache(sourceInvId, weaponId)

    weapon:setCurrInv(targetInvId)
    weapon:setCharId(targetCharId)

    if targetIdentifier then
        weapon:setPropietary(targetIdentifier)
    end

    _addWeaponToCache(targetInvId, weapon)
end

---@type table<string, Item>
svItems = {}


function LoadDatabase(charid)
	local result = MySQL.query.await('SELECT * FROM loadout WHERE charidentifier = ? ', { charid })
	if next(result) then
		for _, db_weapon in pairs(result) do
			if db_weapon.charidentifier then
				local ammo = json.decode(db_weapon.ammo)
				local comp = json.decode(db_weapon.components)
				local used = false
				local used2 = false

				if db_weapon.used == 1 then
					used = true
				end

				if db_weapon.used2 == 1 then
					used2 = true
				end

				if db_weapon.dropped == 0 then
					local weapon = Weapon:New({
						id = db_weapon.id,
						propietary = db_weapon.identifier,
						name = db_weapon.name,
						ammo = ammo,
						components = comp,
						used = used,
						used2 = used2,
						charId = db_weapon.charidentifier,
						currInv = db_weapon.curr_inv,
						dropped = db_weapon.dropped
					})

                    _addWeaponToCache(db_weapon.curr_inv, weapon)
				else
					-- delete any droped weapons
					MySQL.query('DELETE FROM loadout WHERE id = ?', { db_weapon.id })
				end
			end
		end
	end
end

-- load weapons only for the character that its joining
RegisterNetEvent("vorp:SelectedCharacter", function(source, character)
	local charid = character.charIdentifier
	LoadDatabase(charid)
end)

if Config.DevMode then
	RegisterNetEvent("DEV:loadweapons", function()
		local _source = source
		local character = Core.getUser(_source).getUsedCharacter
		local charid = character.charIdentifier
		LoadDatabase(charid)
	end)
end

-- load all items from database
Citizen.CreateThread(function()
	MySQL.query('SELECT * FROM items', {}, function(result)
		if next(result[1]) then
			for _, db_item in pairs(result) do
				local item = Item:New({
					id = db_item.id,
					item = db_item.item,
					metadata = db_item.metadata or {},
					label = db_item.label,
					limit = db_item.limit,
					type = db_item.type,
					canUse = db_item.usable,
					canRemove = db_item.can_remove,
					desc = db_item.desc
				})
				svItems[item.item] = item
			end
		end
	end)
end)
