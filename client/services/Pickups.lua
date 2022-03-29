--------------------------------------------------------------------------------------------------
--------------------------------------- PICKUPS --------------------------------------------------
-- TODO add debug to confing false or true
-- check updated inventory add whats missing or remove what's not needed 
-- not checked yet




VORPpickups = {}


local PickPrompt = nil
local WorldPickups = {}
local WorldMoneyPickups = {}

local active = false
local active2 = false
local dropAll = false
local lastCoords = {}


------------------- CONFIG --------------------------
local DropOnRespawnMoney = Config.DropOnRespawn.Money
local DropOnRespawnItems = Config.DropOnRespawn.Items
local DropOnRespawnWeapons = Config.DropOnRespawn.Weapons
local PickupKey = Config.PickupKey
local TakeFromFloor = Config.Langs.TakeFromFloor
local dropProp = Config.dropPropMoney
local dropPropItem = Config.dropPropItem
------------------------------------------------------

VORPpickups.createPickup = function (name, amount, weaponId)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local forward = GetEntityForwardVector(playerPed)
	local position = (coords + forward * 1.6)
	local pickupModel = GetHashKey(dropPropItem)


	if dropAll then
		local randomOffsetX = math.random(-35, 35)
		local randomOffsetY = math.random(-35, 35)

		position = vector3(lastCoords.X + (randomOffsetX / 10.0), lastCoords.Y + (randomOffsetY / 10.0), lastCoords.Z)
	end

	if not HasModelLoaded( pickupModel) then
		RequestModel(pickupModel)
	end

	while not HasModelLoaded(pickupModel) then
		Wait(1)
	end

	local obj = CreateObject(pickupModel, position.X, position.Y, position.Z, true, true, true)
	PlaceObjectOnGroundProperly( obj)
	SetEntityAsMissionEntity(obj, true, true)
	FreezeEntityPosition( obj, true)

	print(obj)

	TriggerServerEvent("vorpinventory:sharePickupServer", name, obj, amount, position, weaponId)
	PlaySoundFrontend("show_info", "Study_Sounds", true, 0)

end

VORPpickups.createMoneyPickup = function (amount)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local forward = GetEntityForwardVector(playerPed)
	local position = (coords + forward * 1.6)
	local pickupModel = GetHashKey(dropPropMoney) --added to Config

	if dropAll then
		local randomOffsetX = math.random(-3, 3)
		local randomOffsetY = math.random(-3, 3)

		position = vector3(lastCoords.X + (randomOffsetX / 10.0), lastCoords.Y + (randomOffsetY / 10.0), lastCoords.Z)
	end

	if not HasModelLoaded(pickupModel) then
		RequestModel(pickupModel)
	end

	while not HasModelLoaded(pickupModel) then
		Wait(1)
	end

	local obj = CreateObject(pickupModel, position.X, position.Y, position.Z, true, true, true)
	PlaceObjectOnGroundProperly(obj)
	SetEntityAsMissionEntity(obj, true, true)
	FreezeEntityPosition(obj, true)

	print(obj)

	TriggerServerEvent("vorpinventory:shareMoneyPickupServer", obj, amount, position)
	PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
end

VORPpickups.sharePickupClient = function (name, obj, amount, position, value, weaponId)
	if value == 1 then
		print(obj)

		WorldPickups[obj] = {
			name = name, 
			obj = obj,
			amount = amount,
			weaponid = weaponId,
			inRange = false,
			coords = position
		}
		print("name: " .. name .. " quantity: " .. amount .. ", id: " .. weaponId)
	else
		WorldPickups[obj] = nil
	end
end

VORPpickups.shareMoneyPickupClient = function (obj, amount, position, value)
	if value == 1 then
		print(obj)

		WorldMoneyPickups[obj] = {
			name = "money",
			obj = obj,
			amount = amount,
			inRange = false,
			coords = position
		}
		print("name: " .. name .. " quantity: " .. amount)
	else
		WorldMoneyPickups[obj] = nil
	end
end

VORPpickups.removePickupClient = function (obj)
	SetEntityAsMissionEntity(obj, false, true)
	local timeout = 0

	while not NetworkHasControlOfEntity(obj) && timeout < 5000 do
		timeout = timeout + 100
		if timeout == 5000 then
			print("didnt get control of entity")
		end
		Wait(100)
	end

	FreezeEntityPosition(obj, false)
	DeleteObject(obj)
end

VORPpickups.playerAnim = function (obj)
	local animDict = "amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop"
	local playerPed = PlayerPedId()

	HasAnimDictLoaded(animDict)

	while not HasAnimDictLoaded( animDict) do
		Wait(10)
	end

	TaskPlayAnim(playerPed, animDict, "exit_front", 1.0, 8.0, -1, 1, 0, false, false, false)
	Wait(1200)
	PlaySoundFrontend("CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true, 1)
	Wait(1000)
	ClearPedTasks(playerPed) --??

	-- ClearPedTasks(ped --[[ Ped ]], p1 --[[ boolean ]], p2 --[[ boolean ]] this native have booleans 
end

VORPpickups.DeadActions = function ()
	lastCoords = GetEntityCoords(PlayerPedId(), true, true)  --???
	dropAll = true
    
	if DropOnRespawnMoney then
		TriggerServerEvent("vorpinventory:serverDropAllMoney")
	end

	VORPpickups.dropAllPlease()
end

VORPpickups.dropAllPlease = function ()

	Wait(200)
	if DropOnRespawnItems then
		local items = userInventory

		for _, item in pairs(items) do
			local itemName = item.getName()
			local itemCount = item.getCount()

			TriggerServerEvent("vorpinventory:serverDropItem", itemName, itemCount, 1)
			userInventory[itemName].quitCount(itemCount)

			if userInventory[itemName].getCount() == 0 then
				userInventory[itemName] = nil
			end

			Wait(200)
		end
	end

	if DropOnRespawnWeapons then
		local weapons = userWeapons
        local playerPed = PlayerPedId()
		for index, weapon in pairs(weapons) do
			TriggerServerEvent("vorpinventory:serverDropWeapon", index)

			if next(userWeapons[index]) ~= nil then
				local currentWeapon = userWeapons[index]

				if currentWeapon.getUsed() then
					currentWeapon.setUsed(false)
					RemoveWeaponFromPed(playerPed, GetHashKey(currentWeapon.getName()), true, 0)
				end

				userWeapons[index] = nil
			end
			Wait(200)
			dropAll = false
		end
	end
end

VORPpickups.principalFunctionsPickups = function ()
	local playerPed = PlayerPedId()	
	local coords = GetEntityCoords(playerPed, true, true)

	if next(WorldPickups) == nil then
		return 
	end

	for _, pickup in pairs(WorldPickups) do
		local pickupCoords = vector3(pickup.coords.X, pickup.coords.Y, pickup.coords.Z)
		local distance = #(pickupCoords - coords)

		if distance <= 5.0 and not pickup.inRange then
			if pickup.weaponid == 1 then
				local name = pickup.name
				if next(DB_Items[name]) ~= nil then
					name = DB_Items[name].label
				end
				Utils.DrawText3D(pickup.coords, name)
			else
				local name = GetWeaponName(GetHashKey(pickup.name))
				Utils.DrawText3D(pickup.coords, name)
			end
		end

		if distance <= 1.2 and not pickup.inRange then
			TaskLookAtEntity(playerPed, pickup.obj, 3000, 2048, 3)

			if not active then
				UipromptSetEnabled(PickPrompt, true)
				UipromptSetVisible(PickPrompt, true)
				active = true
			end
			
			if UipromptHasHoldModeCompleted(PickPrompt) then
				TriggerServerEvent("vorpinventory:onPickup", pickup.obj)
				pickup.inRange = true
				UipromptSetEnabled(PickPrompt, false)
				UipromptSetVisible(PickPrompt, false)
			end
		else
			if active then
				UipromptSetEnabled(PickPrompt, false)
				UipromptSetVisible(PickPrompt, false)
				active = false
			end
		end
	end
end

VORPpickups.principalFunctionsPickupsMoney = function () -- Tick
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)

	if next(WorldMoneyPickups) == nil then
		return
	end

	for _, pickup in pairs(WorldMoneyPickups) do
		local pickupCoords = vector3(pickup.coords.X, pickup.coords.Y, pickup.coords.Z)
		local distance = #(pickupCoords - coords)

		if distance <= 5.0 then
			Utils.DrawText3D(pickup.coords, name)
		end

		if distance <= 1.2 and not pickup.inRange then
			TaskLookAtEntity(playerPed, pickup.obj, 3000, 2048, 3) 

			if not active2 then
				UiPromptSetEnabled(PickPrompt, PickPrompt, true)
				UiPromptSetVisible(PickPrompt, true)
				active2 = true
			end

			if UiPromptHasHoldModeCompleted(PickPrompt) then
				TriggerServerEvent("vorpinventory:onPickupMoney", pickup.obj)
				pickup.inRange = true
				UiPromptSetEnabled(PickPrompt, false)
				UiPromptSetVisible(PickPrompt, false)
			end
		else
			if active2 then
				UiPromptSetEnabled(PickPrompt, false)
				UiPromptSetVisible(PickPrompt, false)
				active2 = false
			end
		end
	end
end


VORPpickups.SetupPickPrompt = function ()
	print("Prompt was created")
	PickPrompt = UiPromptRegisterBegin()
	local str = CreateVarString(10, "LITERAL_STRING", TakeFromFloor)
    UiPromptSetText(PickPrompt, str)
    UiPromptSetControlAction(PickPrompt, PickupKey) --added to config
    UiPromptSetEnabled(PickPrompt, false)
    UiPromptSetVisible(PickPrompt, false)
	UiPromptSetHoldMode(PickPrompt, true)
    UiPromptRegisterEnd(PickPrompt)
end
