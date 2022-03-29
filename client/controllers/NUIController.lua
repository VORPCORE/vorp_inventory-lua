------------------------------------------------------------------------------------
------------------------- THIS FILE IS UP TO DATE ----------------------------------
-- REVISED BY OUTSIDER 3/29/2022

RegisterNUICallback('NUIFocusOff',VORPNui.NUIFocusOff)

RegisterNUICallback('DropItem',VORPNui.NUIDropItem)

RegisterNUICallback('UseItem',VORPNui.NUIUseItem)

RegisterNUICallback('sound',VORPNui.NUISound)

RegisterNUICallback('GiveItem',VORPNui.NUIGiveItem)

RegisterNUICallback('GetNearPlayers',VORPNui.NUIGetNearPlayers)

RegisterNUICallback('UnequipWeapon',VORPNui.NUIUnequipWeapon)

RegisterNetEvent("vorp_inventory:ProcessingReady")
AddEventHandler("vorp_inventory:ProcessingReady",VORPNui.setProcessingPayFalse)

RegisterNetEvent("vorp_inventory:CloseInv")
AddEventHandler("vorp_inventory:CloseInv",VORPNui.CloseInventory)

-- Horse Module
RegisterNetEvent("vorp_inventory:OpenHorseInventory")
AddEventHandler("vorp_inventory:OpenHorseInventory",VORPNui.OpenHorseInventory)

RegisterNetEvent("vorp_inventory:ReloadHorseInventory")
AddEventHandler("vorp_inventory:ReloadHorseInventory",VORPNui.ReloadInventory)

RegisterNUICallback('TakeFromHorse',VORPNui.NUITakeFromHorse)

RegisterNUICallback('MoveToHorse',VORPNui.NUIMoveToHorse)

-- Steal
RegisterNetEvent("vorp_inventory:OpenstealInventory")
AddEventHandler("vorp_inventory:OpenstealInventory",VORPNui.OpenstealInventory)

RegisterNetEvent("vorp_inventory:ReloadstealInventory")
AddEventHandler("vorp_inventory:ReloadstealInventory",VORPNui.ReloadInventory)

RegisterNUICallback('TakeFromsteal',VORPNui.NUITakeFromsteal)

RegisterNUICallback('MoveTosteal',VORPNui.NUIMoveTosteal)

-- Cart Module
RegisterNetEvent("vorp_inventory:OpenCartInventory")
AddEventHandler("vorp_inventory:OpenCartInventory",VORPNui.OpenCartInventory)

RegisterNetEvent("vorp_inventory:ReloadCartInventory")
AddEventHandler("vorp_inventory:ReloadCartInventory",VORPNui.ReloadInventory)

RegisterNUICallback('TakeFromCart',VORPNui.NUITakeFromCart)

RegisterNUICallback('MoveToCart',VORPNui.NUIMoveToCart)

-- House Module
RegisterNetEvent("vorp_inventory:OpenHouseInventory")
AddEventHandler("vorp_inventory:OpenHouseInventory",VORPNui.OpenHouseInventory)

RegisterNetEvent("vorp_inventory:ReloadHouseInventory")
AddEventHandler("vorp_inventory:ReloadHouseInventory",VORPNui.ReloadInventory)

RegisterNUICallback('TakeFromHouse',VORPNui.NUITakeFromHouse)

RegisterNUICallback('MoveToHouse',VORPNui.NUIMoveToHouse)

--Hideout Module
RegisterNetEvent("vorp_inventory:OpenHideoutInventory")
AddEventHandler("vorp_inventory:OpenHideoutInventory",VORPNui.OpenHideoutInventory)

RegisterNetEvent("vorp_inventory:ReloadHideoutInventory")
AddEventHandler("vorp_inventory:ReloadHideoutInventory",VORPNui.ReloadInventory)

RegisterNuiCallbackType("TakeFromHideout",VORPNui.NUITakeFromHideout)

RegisterNuiCallbackType("MoveToHideout",VORPNui.NUIMoveToHideout)

-- Clan Module
RegisterNetEvent("vorp_inventory:OpenClanInventory")
AddEventHandler("vorp_inventory:OpenClanInventory",VORPNui.OpenClanInventory)

RegisterNetEvent("vorp_inventory:ReloadClanInventory")
AddEventHandler("vorp_inventory:ReloadClanInventory",VORPNui.ReloadInventory)

RegisterNuiCallbackType("TakeFromClan",VORPNui.NUITakeFromClan)

RegisterNuiCallbackType("MoveToClan",VORPNui.NUIMoveToClan)

-- Container Module
RegisterNetEvent("vorp_inventory:OpenContainerInventory")
AddEventHandler("vorp_inventory:OpenContainerInventory",VORPNui.OpenContainerInventory)

RegisterNetEvent("vorp_inventory:ReloadContainerInventory")
AddEventHandler("vorp_inventory:ReloadContainerInventory",VORPNui.ReloadInventory)

RegisterNuiCallbackType("TakeFromContainer",VORPNui.NUITakeFromContainer);

RegisterNuiCallbackType("MoveToContainer",VORPNui.NUIMoveToContainer);
