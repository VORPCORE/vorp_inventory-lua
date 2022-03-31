RegisterServerEvent("vorpinventory:getItemsTable")
AddEventHandler("vorpinventory:getItemsTable", VORPInventory.getItemsTable)

RegisterServerEvent("vorpinventory:getInventory")
AddEventHandler("vorpinventory:getInventory", VORPInventory.getInventory)

RegisterServerEvent("vorpinventory:serverGiveItem")
AddEventHandler("vorpinventory:serverGiveItem", VORPInventory.GiveItem)

RegisterServerEvent("vorpinventory:serverGiveWeapon")
AddEventHandler("vorpinventory:serverGiveWeapon", VORPInventory.GiveWeapon)

RegisterServerEvent("vorpinventory:serverDropItem")
AddEventHandler("vorpinventory:serverDropItem", VORPInventory.DropItem)

RegisterServerEvent("vorpinventory:serverDropMoney")
AddEventHandler("vorpinventory:serverDropMoney", VORPInventory.DropMoney)

RegisterServerEvent("vorpinventory:serverDropAllMoney")
AddEventHandler("vorpinventory:serverDropAllMoney", VORPInventory.dropAllMoney)

RegisterServerEvent("vorpinventory:serverDropWeapon")
AddEventHandler("vorpinventory:serverDropWeapon", VORPInventory.DropWeapon)

RegisterServerEvent("vorpinventory:sharePickupServer")
AddEventHandler("vorpinventory:sharePickupServer", VORPInventory.sharePickupServer)

RegisterServerEvent("vorpinventory:shareMoneyPickupServer")
AddEventHandler("vorpinventory:shareMoneyPickupServer", VORPInventory.sharePickupServer)

RegisterServerEvent("vorpinventory:onPickup")
AddEventHandler("vorpinventory:onPickup", VORPInventory.onPickup)

RegisterServerEvent("vorpinventory:onPickupMoney")
AddEventHandler("vorpinventory:onPickupMoney", VORPInventory.onPickupMoney)

RegisterServerEvent("vorpinventory:setUsedWeapon")
AddEventHandler("vorpinventory:setUsedWeapon", VORPInventory.usedWeapon)

RegisterServerEvent("vorpinventory:setWeaponBullets")
AddEventHandler("vorpinventory:setWeaponBullets", VORPInventory.setWeaponBullets)

RegisterServerEvent("vorpinventory:giveMoneyToPlayer")
AddEventHandler("vorpinventory:giveMoneyToPlayer", VORPInventory.giveMoneyToPlayer)

--------------------------------- NEW AND UPDATED ----------------------------------------

RegisterServerEvent("vorpinventory:getLabelFromId")
AddEventHandler("vorpinventory:getLabelFromId", VORPInventory.getLabelFromId)


RegisterServerEvent("vorpinventory:check_slots")
AddEventHandler("vorpinventory:check_slots", VORPInventory.getSlots)