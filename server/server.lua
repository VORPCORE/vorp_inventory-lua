---@diagnostic disable: undefined-global

Core = {}
TriggerEvent("getCore", function(core)
    Core = core
end)

T = TranslationInv.Langs[Lang]

if Config.DevMode then
    Log.Warning("^1[DEV] ^7You are in dev mode, dont use this in production live servers")
end

RegisterServerEvent("syn:stopscene")
AddEventHandler("syn:stopscene", function(x) -- new
    local _source = source
    TriggerClientEvent("inv:dropstatus", _source, x)
end)


RegisterServerEvent("vorpinventory:check_slots")
AddEventHandler("vorpinventory:check_slots", function()
    local _source = tonumber(source)
    local part2 = Config.MaxItemsInInventory.Items
    local User = Core.getUser(_source).getUsedCharacter
    local identifier = User.identifier
    local charid = User.charIdentifier
    local money = User.money
    local gold = User.gold
    local stufftosend = InventoryAPI.getUserTotalCountItems(identifier, charid)

    TriggerClientEvent("syn:getnuistuff", _source, stufftosend, part2, money, gold)
end)


RegisterServerEvent("vorpinventory:getLabelFromId")
AddEventHandler("vorpinventory:getLabelFromId", function(id, item2, cb)
    local _source = id
    InventoryAPI.getInventory(_source, function(inventory)
        local label = "not found"
        for i, item in ipairs(inventory) do
            if item.name == item2 then
                label = item.label
                break
            end
        end
        cb(label)
    end)
end)

RegisterServerEvent("vorpinventory:itemlog")
AddEventHandler("vorpinventory:itemlog", function(_source, targetHandle, itemName, amount)
    local _source = source
	local _target = targetHandle
	local user = Core.getUser(_source)
	local target= Core.getUser(_target)
    local sourceCharacter = user.getUsedCharacter
	local targetCharacter = target.getUsedCharacter
	local _target = sourceCharacter.charIdentifier -- new line
	local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local charname1 = targetCharacter.firstname .. ' ' .. targetCharacter.lastname
    local steamname = GetPlayerName(_source)
    local steamname2 = GetPlayerName(_target)
    local title = T.gaveitem
	local description = "**" ..
		T.WebHookLang.amount .."**: `" ..amount .."`\n **" ..T.WebHookLang.item .."** : `" ..itemName .."`" .. "\n**" ..T.WebHookLang.charname .. ":** `" .. charname .. "` \n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "` \n**" .. T.to .. "** `" .. charname1 .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname2 .. "` \n**"
		Core.AddWebhook(title, Config.webhook, description, color, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:itempickuplog")
AddEventHandler("vorpinventory:itempickuplog", function(_source, data)
    local user = Core.getUser(_source).getUsedCharacter
	local charname = user.firstname .. ' ' .. user.lastname
    local steamname = GetPlayerName(_source)
    local title = T.itempickup
    local description = "**" .. T.WebHookLang.amount .. "** `" ..data.amount .."`\n **" ..T.WebHookLang.item .."** `" .. data.name .. "` \n**" .. T.WebHookLang.charname ..":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
    Core.AddWebhook(title, Config.webhook, description, color, Name, logo, footerlogo,avatar)
end)


RegisterServerEvent("vorpinventory:dropitemlog")
AddEventHandler("vorpinventory:dropitemlog", function(targetHandle,itemname, moneyAmount)
    local _source = source
	local sourceCharacter = Core.getUser(targetHandle).getUsedCharacter
	local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
    local steamname = GetPlayerName(targetHandle)
    local title = T.drop
    local description = "**" ..T.WebHookLang.amount .."** `" ..moneyAmount .."`\n **" ..T.WebHookLang.itemDrop .."**: `" .. itemname .. "`" .. "\n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
    Core.AddWebhook(title, Config.webhook, description, color, name, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:weaponlog")
AddEventHandler("vorpinventory:weaponlog", function(giver,targetHandle, weaponId)
    local _source = giver
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceCharacter2 = Core.getUser(targetHandle).getUsedCharacter
    local steamname = GetPlayerName(_source)
    local steamname2 = GetPlayerName(targetHandle)
    local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local charname2 = sourceCharacter2.firstname .. ' ' .. sourceCharacter2.lastname
    local userWeapons = UsersWeapons.default
	local weapon = userWeapons[weaponId]
	local wepname = weapon:getName()
	local serialNumber = weapon:getSerialNumber()
	local desc = weapon:getDesc()
    if desc == nil then
        desc = "Custom Description not set"
        if serialNumber == nil then
            serialNumber = "Serial Number not set"
        end
    end
    local title = T.WebHookLang.gavewep
    local description = "**" ..T.WebHookLang.charname .. ":** `" .. charname .."`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "` \n**"..T.WebHookLang.give .."**  **" .. 1 .. "** \n**" .. T.WebHookLang.Weapontype .. ":** `" .. wepname .."` \n**"..T.WebHookLang.Desc.."** `" ..desc.. "`   **" .. T.to .. "**   \n` " .. charname2 .. "` \n**".. T.WebHookLang.Steamname .."** ` " .. steamname2 .. "`\n **" .. T.WebHookLang.serialnumber .. "** `" .. serialNumber .. "`"

    Core.AddWebhook(title, Config.webhook, description, 1912489, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:dropWeaponlog")
AddEventHandler("vorpinventory:dropWeaponlog", function(targetHandle, wepname, weaponId)
    local _source = targetHandle
    local steamname = GetPlayerName(_source)
    local sourceCharacter = Core.getUser(_source).getUsedCharacter
    local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
    local userWeapons = UsersWeapons.default
    local weapon = userWeapons[weaponId]
    local wepname = weapon:getName()
    local weaponCustomLabel = weapon:getCustomLabel()
    local serialNumber = weapon:getSerialNumber()
    print(serialNumber)
    local title = T.WebHookLang.dropedwep
    local desc = weapon:getCustomDesc()
    if desc == nil then
        desc = "Custom Description not set"
       
    end
    if serialNumber == nil then
        serialNumber = "Serial Number not set"
    end
    local description = "**" ..T.WebHookLang.Weapontype ..":** `" ..wepname .."`\n**" ..T.WebHookLang.charname ..":** `" ..charname .."`\n**" ..T.WebHookLang.serialnumber .."** `" ..serialNumber.. "` \n**" .. T.WebHookLang.Desc .."** `" .. desc .. "` \n **" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"

    Core.AddWebhook(title, Config.webhook, description, color, Name, logo, footerlogo, avatar)
end)


RegisterServerEvent("vorpinventory:weaponpickuplog")
AddEventHandler("vorpinventory:weaponpickuplog", function(_source, weaponId)
    print(weaponId)
	local user = Core.getUser(_source)
    local sourceCharacter = user.getUsedCharacter
	local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
    local userWeapons = UsersWeapons.default
    local weapon = userWeapons[weaponId]
    local wepname = weapon:getName()
    local serialNumber = weapon:getSerialNumber()
    local steamname = GetPlayerName(_source)
    local title = T.weppickup
    local desc = weapon:getCustomDesc()
    if desc == nil then
        desc = "Custom Description not set"
        if serialNumber == nil then
            serialNumber = "Serial Number not set"
        end
    end
    local description = "**" ..T.WebHookLang.Weapontype ..":** `" ..wepname .."`\n**" ..T.WebHookLang.charname ..":** `" ..charname .."`\n**" ..T.WebHookLang.serialnumber .."** `" ..serialNumber .."`\n **" ..T.WebHookLang.Desc .."** `" .. desc .. "` \n **" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"

    Core.AddWebhook(title, Config.webhook, description, 65280, logo, footerlogo, avatar)
end)


RegisterServerEvent("vorpinventory:moneylog")
AddEventHandler("vorpinventory:moneylog", function(targetHandle, moneyAmount)
    local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
    local _source = source
    local steamname = GetPlayerName(_source)
    local title = T.WebHookLang.moneypickup
    local description = "**" ..T.WebHookLang.money ..":** `" .. moneyAmount .. "` `$` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
    Core.AddWebhook(title, Config.webhook, description, color, Name, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:moneypickuplog")
AddEventHandler("vorpinventory:moneypickuplog", function(_source, amount)
    local user = Core.getUser(_source).getUsedCharacter
	local charname = user.firstname .. ' ' .. user.lastname
    local steamname = GetPlayerName(_source)
    local title = T.WebHookLang.moneypickup
	local description = "**" ..T.WebHookLang.money ..":** `" .. amount .. "` `$` \n**" .. T.WebHookLang.charname .. ":** `" .. charname ..  "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`\n"
	Core.AddWebhook(title, Config.webhook, description, color, name, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:dropmoneylog")
AddEventHandler("vorpinventory:dropmoneylog", function(targetHandle, moneyAmount)
	local sourceCharacter = Core.getUser(targetHandle).getUsedCharacter
	local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
    local steamname = GetPlayerName(targetHandle)
    local title = T.dropmoney
    local description = "**" ..T.WebHookLang.money ..":** `" .. moneyAmount .. "` `$` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`\n"
    Core.AddWebhook(title, Config.webhook, description, color, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:givemoneylog")
AddEventHandler("vorpinventory:givemoneylog", function(targetHandle, moneyAmount)
    local _source = source
    local _target = targetHandle
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
    local targetCharacter = target.getUsedCharacter
	local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local charname1 = targetCharacter.firstname .. ' ' .. targetCharacter.lastname
    local steamname = GetPlayerName(_source)
    local steamname2 = GetPlayerName(_target)

    local title = T.givemoney
    local description = "**" ..T.WebHookLang.amount .."**: `" ..moneyAmount .."`\n **" ..T.WebHookLang.charname .. ":** `" .. charname .. "` \n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "` \n**" .. T.to .. "** `" .. charname1 .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname2 .. "` \n**"
		Core.AddWebhook(title, Config.webhook, description, color, name, logo, footerlogo, avatar)
end)




RegisterServerEvent("vorpinventory:netduplog")
AddEventHandler("vorpinventory:netduplog", function()
    local _source = source
    local name = GetPlayerName(_source)
    local description = Config.NetDupWebHook.Language.descriptionstart ..
        name .. Config.NetDupWebHook.Language.descriptionend

    if Config.NetDupWebHook.Active then
        Core.AddWebhook(Config.NetDupWebHook.Language.title, Config.webhook, description, color, name, logo, footerlogo,
            avatar)
    else
        print('[' .. Config.NetDupWebHook.Language.title .. '] ', description)
    end
end)



-- * CUSTOM INVENTORY CHECK IS OPEN * --
local InventoryBeingUsed = {}

Core.addRpcCallback("vorp_inventory:Server:CanOpenCustom", function(source, cb, id)
    local _source = source
    if not InventoryBeingUsed[id] then
        InventoryBeingUsed[id] = _source
        return cb(true)
    end

    return cb(false)
end)

RegisterServerEvent("vorp_inventory:Server:UnlockCustomInv", function()
    local _source = source
    for i, value in pairs(InventoryBeingUsed) do
        if value == _source then
            InventoryBeingUsed[i] = nil
            break
        end
    end
end)


AddEventHandler('playerDropped', function()
    local _source = source
    -- clear ammo
    allplayersammo[_source] = nil

    -- if player is stil in inventory check and remove
    for i, value in ipairs(InventoryBeingUsed) do
        if value == _source then
            table.remove(InventoryBeingUsed, i)
            break
        end
    end

    -- remove weapons from cache on player leave
    local weapons = UsersWeapons.default
    local char = Core.getUser(_source).getUsedCharacter
    if char then
        local charid = char.charIdentifier
        for key, value in pairs(weapons) do
            if value.charId == charid then
                UsersWeapons.default[key] = nil
                break
            end
        end
    end
end)
