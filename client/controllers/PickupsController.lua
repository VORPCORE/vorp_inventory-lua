
RegisterNetEvent("vorpInventory:createPickup")
AddEventHandler("vorpInventory:createPickup", Pickups.createPickup)

RegisterNetEvent("vorpInventory:createMoneyPickup")
AddEventHandler("vorpInventory:createMoneyPickup", Pickups.createMoneyPickup)

RegisterNetEvent("vorpInventory:sharePickupClient")
AddEventHandler("vorpInventory:sharePickupClient", Pickups.sharePickupClient)

RegisterNetEvent("vorpInventory:shareMoneyPickupClient")
AddEventHandler("vorpInventory:shareMoneyPickupClient", Pickups.shareMoneyPickupClient)

RegisterNetEvent("vorpInventory:removePickupClient")
AddEventHandler("vorpInventory:removePickupClient", Pickups.removePickupClient)

RegisterNetEvent("vorpInventory:playerAnim")
AddEventHandler("vorpInventory:playerAnim", Pickups.playerAnim)

RegisterNetEvent("vorp:PlayerForceRespawn")
AddEventHandler("vorp:PlayerForceRespawn", Pickups.DeadActions)