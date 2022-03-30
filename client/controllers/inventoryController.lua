RegisterNetEvent("vorpInventory:giveItemsTable")
AddEventHandler("vorpInventory:giveItemsTable", VORPInventory.processItems)

RegisterNetEvent("vorpInventory:giveInventory")
AddEventHandler("vorpInventory:giveInventory", VORPInventory.getInventory)

RegisterNetEvent("vorpInventory:giveLoadout")
AddEventHandler("vorpInventory:giveLoadout", VORPInventory.getLoadout)

RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", VORPInventory.onSelectedCharacter)

RegisterNetEvent("vorpinventory:receiveItem")
AddEventHandler("vorpinventory:receiveItem", VORPInventory.receiveItem)

RegisterNetEvent("vorpinventory:receiveItem2")
AddEventHandler("vorpinventory:receiveItem2", VORPInventory.receiveItem2)

RegisterNetEvent("vorpinventory:receiveWeapon")
AddEventHandler("vorpinventory:receiveWeapon", VORPInventory.receiveWeapon)

Citizen.CreateThread(VORPInventory.updateAmmoInWeapon)
	