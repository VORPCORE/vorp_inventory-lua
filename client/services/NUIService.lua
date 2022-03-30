----------------------------------------- THIS FILE IS OUTADATED ----------------------------------------
-- BEING REVISED
-- NUIcontroller is where is being registered the eventes and nuicallbacks

VORPNui = {}
gg = {} -- ??
isProcessingPay = false
InInventory = false


VORPNui.ReloadInventory = function (inventory)
	SendNUIMessage(inventory)
	Wait(500)
	VORPNui.LoadInv()
end


---------------- NEW UPDATED -------------------------------
VORPNui.inventoryChecks = function (x,y,mon,gol)
	local nuistuff  = x 
    local playerPed = PlayerPedId()
	SendNUIMessage({
		action = "changecheck",
		check  = nuistuff,
		info   = y,
	})
    SendNUIMessage({
        action      = "updateStatusHud",  -- inventory hud money and gold
        show        = not IsRadarHidden(),
        money       = mon,
        gold        = gol,
        id          = GetPlayerServerId(NetworkGetEntityOwner(playerPed))
    })
end
------------------------------------------------------------------------

-- CLAN
VORPNui.OpenClanInventory = function (clanName, clanId)
	SetNuiFocus(true, true)
	SendNUIMessage(
		{
			action = "display",
			type   = "clan",
			title  = "" .. clanName .. "",
			clanid = "" .. clanid .. 
		}
	)
	InInventory = true
end

VORPNui.NUIMoveToClan = function (obj)
	TriggerServerEvent("syn_clan:MoveToClan", json.encode(obj))
end

VORPNui.NUITakeFromClan = function (obj)
	TriggerServerEvent("syn_clan:TakeFromClan", json.encode(obj))
end
---------------------------------------------------------------------------

-- OpenContainerInventory

VORPNui.NUIMoveToContainer = function (obj)
	TriggerServerEvent("syn_Container:MoveToContainer", json.encode(obj))
end

VORPNui.NUITakeFromContainer = function (obj)
	TriggerServerEvent("syn_Container:TakeFromContainer", json.encode(obj))
end
--------------------------------------------------------------------------------

VORPNui.CloseInventory = function ()
	SetNuiFocus(false, false)
	SendNUIMessage("{\"action\": \"hide\"}")
	InInventory = false
end
--vorp
VORPNui.OpenHorseInventory = function (horseName, horseId)
	SetNuiFocus(true, true)
	SendNuiMessage("{\"action\": \"display\", \"type\": \"horse\", \"title\": \"".. horseName .. "\", \"horseid\": " .. horseid .. "}")
	InInventory = true
	TriggerEvent("vorp_stables:setClosedInv", true)
end

VORPNui.NUIMoveToHorse = function (obj)
	TriggerServerEvent("vorp_stables:MoveToHorse", json.encode(obj))
end

VORPNui.NUITakeFromHorse = function (obj)
	TriggerServerEvent("vorp_stables:TakeFromHorse", json.encode(obj))
end

VORPNui.OpenstealInventory = function (stealName, stealId)
	SetNuiFocus(false, false)
	SendNuiMessage("{\"action\": \"display\", \"type\": \"steal\", \"title\": \"" .. stealName .. "\", \"stealId\": " .. stealid .. "}")
	InInventory = true
	TriggerEvent("vorp_stables:setClosedInv", true)
end
---------- steal syn
VORPNui.NUIMoveTosteal = function (obj)
	TriggerServerEvent("syn_search:MoveTosteal", json.encode(obj))
end

VORPNui.NUITakeFromsteal = function (obj)
	TriggerServerEvent("syn_search:TakeFromsteal", json.encode(obj))
end

--- vorp
VORPNui.OpenCartInventory = function (cartName, wagonId)
	SetNuiFocus(true, true)
	SendNUIMessage("{\"action\": \"display\", \"type\": \"cart\", \"title\": \"" .. cartName .. "\", \"wagonid\": " .. wagonid .. "}")
	InInventory = true

	TriggerEvent("vorp_stables:setClosedInv", true)
end

VORPNui.NUIMoveToCart = function (obj)
	TriggerServerEvent("vorp_stables:MoveToCart", json.encode(obj))
end

VORPNui.NUITakeFromCart = function (obj)
	TriggerServerEvent("vorp_stables:TakeFromCart", json.encode(obj))
end

--------------------------------------------------------------------------------------------------------------
-------------------------- to be continued -------------------------------------------------------------------
VORPNui.OpenHouseInventory = function (houseName, houseId)
	SetNuiFocus(true, true)
	SendNUIMessage("{\"action\": \"display\", \"type\": \"house\", \"title\": \"" .. houseName .. "\", \"houseId\": " .. houseId .. "}")
	InInventory = true
end

VORPNui.NUIMoveToHouse = function (obj)
	TriggerServerEvent("vorp_housing:MoveToHouse", json.encode(obj))
end

VORPNui.NUITakeFromHouse = function (obj)
	TriggerServerEvent("vorp_housing:TakeFromHouse", json.encode(obj))
end

VORPNui.OpenHideoutInventory = function (hideoutName, hideoutId)
	SetNuiFocus(true, true)
	SendNuiMessage("{\"action\": \"display\", \"type\": \"hideout\", \"title\": \"" .. hideoutName .. "\", \"hideoutId\": " .. hideoutId .. "}")
	InInventory = true
end

VORPNui.NUIMoveToHideout = function (obj)
	TriggerServerEvent("syn_underground:MoveToHideout", json.encode(obj))
end

VORPNui.NUITakeFromHideout = function (obj)
	TriggerServerEvent("syn_underground:TakeFromHideout", json.encode(obj))
end

VORPNui.setProcessingPayFalse = function ()
	isProcessingPay = false
end

VORPNui.NUIUnequipWeapon = function (obj)
	local data = json.decode(obj)

	if next(UserWeapons[tonumber(data.id)]) ~= nil then
		UserWeapons[tonumber(data.id)].UnequipWeapon()
	end

	VORPNui.LoadInv()
end

VORPNui.NUIGetNearPlayers = function (obj)
	local playerPed = PlayerPedId()
	local nearestPlayers = VORPUtils.getNearestPlayers()
	local isAnyPlayerFound = false
	local closePlayersArr = {}
	local nuiReturn = {}

	for _, player in pairs(nearestPlayers) do
		isAnyPlayerFound = true
		table.insert(closePlayersArr, {
			label = GetPlayerName(player),
			player = GetPlayerServerId(player)
		})
	end

	if next(closePlayersArr) == nil then
		print("No Near Players")
		return
	end

	local item = {}

	for k, v in pairs(obj) do
		item[k] = v
	end

	if item.id == nil then
		item.id = 0
	end

	if item.count == nil then
		item.count = 1
	end

	if item.hash == nil then
		item.hash = 1
	end

	nuiReturn.action = "nearPlayers"
	nuiReturn.foundAny = isAnyPlayerFound
	nuiReturn.players = closePlayersArr
	nuiReturn.item = item.item
	nuiReturn.hash = item.hash
	nuiReturn.count = item.count
	nuiReturn.id = item.id
	nuiReturn.type = item.type
	nuiReturn.what = item.what

	SendNUIMessage(json.encode(nuiReturn))
end

VORPNui.NUIGiveItem = function (obj)
	local playerPed = PlayerPedId()  --- not being used
	local nearestPlayers = VORPUtils.getNearestPlayers()

	local data = VORPUtils.expandoProcessing(obj)
	local data2 = VORPUtils.expandoProcessing(data.data)

	for _, player in pairs(nearestPlayers) do
		if player ~= PlayerId() then
			if GetPlayerServerId(player) == tonumber(data.player) then
				local itemName = data2.item
				local target = tonumber(data.player)

				if data2.type == "item_money" then
					if isProcessingPay then return end
					isProcessingPay = true
					TriggerServerEvent("vorp_inventory:giveMoneyToPlayer", target, data2.count)
				end

				if data2.type ~= "item_money" and data2.id == 0 then
					local amount = tonumber(data2.count)

					if amount > 0 and UserInventory[itemName].getCount() >= amount then
						TriggerServerEvent("vorpinventory:serverGiveItem", itemName, amount, target, 1)
					end
				end

				if data2.type ~= "item_money" and data2.id ~= 0 then
					TriggerServerEvent("vorpinventory:serverGiveWeapon2", tonumber(data2.id), target)
				end

				VORPNui.LoadInv()
			end
		end
	end
end
---------------------- need to be converted -------------------------- up to date
VORPNui.NUIUseItem = function (obj)
	
	local data = VORPUtils.ProcessDynamicObject(obj)
    local player = PlayerPedId()
	-- foreach (var VARIABLE in data)
	-- {
	--     print($"{VARIABLE.Key}: {VARIABLE.Value}");
	-- }
	if data.type.ToString().Contains("item_standard")
	
		-- string eventString = "vorp:use" + data["item"];
		-- TriggerServerEvent(eventString); Version antigua
		TriggerServerEvent("vorp:use", data.item)
	
	else if data.type.ToString().Contains("item_weapon")
	
		uint weaponHash = 0;
		AGetCurrentPedWeapon(player, ref weaponHash, false, 0, false);

		bool isWeaponARevolver = Function.Call<bool>((Hash)0xC212F1D05A8232BB, GetHashKey(vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].getName()));
		bool isWeaponAPistol = Function.Call<bool>((Hash)0xDDC64F5E31EEDAB6, GetHashKey(vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].getName()));
		string weaponName = Function.Call<string>((Hash)0x89CF5FF3D363311E, weaponHash);

		-- Check if the weapon used is a pistol or a revolver and ped is not unarmed.
		if isWeaponARevolver or isWeaponAPistol and not weaponName.Contains("UNARMED")
		
			-- OUR PART
			print("OUR PART");
			bool isWeaponUsedARevolver = Function.Call<bool>((Hash)0xC212F1D05A8232BB, weaponHash);
			bool isWeaponUsedAPistol = Function.Call<bool>((Hash)0xDDC64F5E31EEDAB6, weaponHash);
			if isWeaponUsedARevolver or isWeaponUsedAPistol
			
				print("Equiping offhand");
				vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].setUsed2(true);
				vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].loadAmmo();
				vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].loadComponents();
				vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].setUsed(true);
				TriggerServerEvent("syn_weapons:weaponused", data);
				print($"used 2 : {vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].getUsed2()}");

			end
		}
		else if !vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].getUsed() and not
			Function.Call<bool>((Hash)0x8DECB02F88F428BC, player, GetHashKey(vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].getName()), 0, true))
		
			print("THEIR PART")
			vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].loadAmmo();
			vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].loadComponents();
			vorp_inventoryClient.userWeapons[int.Parse(data["id"].ToString())].setUsed(true);
			TriggerServerEvent("syn_weapons:weaponused", data);
		
		else
		
			--TriggerEvent("vorp:Tip", "Ya tienes equipada esa arma", 3000);
		end
		VORPNui.LoadInv();
	end
end


-- checked --
VORPNui.NUIDropItem = function (obj)
	local aux = VORPUtils.expandoProcessing(obj)
	local itemName = aux.item
	local type = aux.type
    local player = PlayerPedId() --new
	if type == "item_money" then
		TriggerServerEvent("vorpinventory:serverDropMoney", aux.number)
	

    elseif type == "item_standard" then
		print(aux.number)

		if aux.number ~= nil and aux.number ~= '' then
			if aux.number > 0 and UserInventory[itemName].getCount() >= tonumber(aux.number) then
				TriggerServerEvent("vorpinventory:serverDropItem", itemName, aux.number, 1)
				UserInventory[itemName].quitCount(aux.number)

				if UserInventory[itemName].getcount() == 0 then
					UserInventory[itemName] = nil
				end
			end
		end
	

	else --type ~= "item_money" and type ~= "item_standard" then
		TriggerServerEvent("vorpinventory:serverDropWeapon", aux.id)

		if next(UserWeapons[aux.id]) ~= nil then 
			local weapon = UserWeapons[aux.id]	

			if weapon.getUsed() then
				weapon.setUsed(false)
				RemoveWeaponFromPed(player, GetHashKey(weapon.getName()), true, 0)
			end

			UserWeapons[aux.id] = nil
		end
	end

	VORPNui.LoadInv()
end


VORPNui.NUISound = function (obj)
	PlaySoundFrontend("BACK", "RDRO_Character_Creator_Sounds", true, 0)
end

VORPNui.NUIFocusOff = function (obj)
	VORPNui.CloseInv()
	TriggerEvent("vorp_stables:setClosedInv", false)
	TriggerEvent("syn:closeinv")
end

VORPNui.OnKey = function ()
	if IsControlJustReleased(1, Config.openKey) and IsInputDisabled(0) then
		if InInventory then
			VORPNui.CloseInv()
			Wait(1000)
		else
			VORPNui.OpenInv()
			Wait(1000)
		end
	end
end

VORPNui.LoadInv = function ()
	local weapon = {}
	DB_Items = {}
	gg = {}
	
	TriggerServerEvent("vorpinventory:check_slots")
	
	for _, currentItem in pairs(UserInventory) do
		local item = {}
		item.count = currentItem.getCount()
		item.limit = currentItem.getLimit()
		item.label = currentItem.getLabel()
		item.name = currentItem.getName()
		item.type = currentItem.getType()
		item.usable = currentItem.getCanuse()
		item.canRemove = currentItem.getCanRemove()

		table.insert(gg, item)
	end

	for _, currentWeapon in  pairs(UserWeapons) do
		local weapon = {}
		weapon.count = currentWeapon.getAllAmo() --in C# weapon.Add("count", userwp.Value.getAmmo("Hola"));
		weapon.limit = -1
		weapon.label = Citizen.InvokeNative(0x89CF5FF3D363311E, GetHashKey(currentWeapon.getName()))
		weapon.name = currentWeapon.getName()
		weapon.hash = GetHashKey(currentWeapon.getName()) 
		weapon.type = "item_weapon"
		weapon.usable = true
		weapon.canRemove = true
		weapon.id = currentWeapon.getId()
		weapon.used = currentWeapon.getUsed()

		table.insert(gg, weapon)
	end

	DB_Items.action = setItems
	DB_Items.itemList = gg

	SendNUIMessage(json.encode(DB_Items))
end

--- checked ---

VORPNui.OpenInv = function () 
	SetNuiFocus(true, true)
	SendNUIMessage(
		{
			action= "display",
			type = "main"
		}
	)
	InInventory = true

	VORPNui.LoadInv()
end

VORPNui.CloseInv = function ()
	SetNuiFocus(false, false)
	SendNUIMessage(
		{
			action = "hide"
		}
	)
	InInventory = false
end	


