local getammoinfo = false
local playerammoinfo = {}
InvLoaded = false

local function addAmmoToPed(ammoData)
    for ammoType, ammo in pairs(ammoData) do
        SetPedAmmoByType(PlayerPedId(), joaat(ammoType), ammo)
    end
end

RegisterNetEvent("vorpinventory:loaded")
AddEventHandler("vorpinventory:loaded", function()
    SendNUIMessage({
        action = "reclabels",
        labels = SharedData.AmmoLabels
    })
    --TODO add callback here
    getammoinfo = true
    TriggerServerEvent("vorpinventory:getammoinfo")
    while getammoinfo do
        Wait(100)
    end

    addAmmoToPed(playerammoinfo.ammo)
    SendNUIMessage({
        action = "updateammo",
        ammo   = playerammoinfo.ammo
    })
    InvLoaded = true
end)

RegisterNetEvent("vorpinventory:updateuiammocount")
AddEventHandler("vorpinventory:updateuiammocount", function(ammo)
    SendNUIMessage({
        action = "updateammo",
        ammo   = ammo
    })
    NUIService.LoadInv()
end)

RegisterNetEvent("vorpinventory:setammotoped")
AddEventHandler("vorpinventory:setammotoped", function(ammoData)
    local PlayerPedId = PlayerPedId()
    Citizen.InvokeNative(0xF25DF915FA38C5F3, PlayerPedId, 1, 1)
    Citizen.InvokeNative(0x1B83C0DEEBCBB214, PlayerPedId)
    addAmmoToPed(ammoData)
end)

RegisterNetEvent("vorpinventory:updateinventorystuff")
AddEventHandler("vorpinventory:updateinventorystuff", function() -- new
    NUIService.LoadInv()
end)

RegisterNetEvent("vorpinventory:updateuiammocount")
AddEventHandler("vorpinventory:updateuiammocount", function(ammo)
    SendNUIMessage({
        action = "updateammo",
        ammo   = ammo
    })
    NUIService.LoadInv()
end)

RegisterNetEvent("vorpinventory:recammo", function(ammo)
    playerammoinfo = ammo
    getammoinfo = false
end)



local function contains(arr, element)
    if next(arr) == nil then
        return false
    end
    for _, v in ipairs(arr) do
        if v == element then
            return true
        end
    end
    return false
end

-- AMMO SAVING THREAD
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if InvLoaded then
            local PlayerPedId = PlayerPedId()
            local isArmed = Citizen.InvokeNative(0xCB690F680A3EA971, PlayerPedId, 4)
            local wephash = Citizen.InvokeNative(0x8425C5F057012DAB, PlayerPedId)
            local ismelee = Citizen.InvokeNative(0x959383DCD42040DA, wephash)
            if (isArmed or GetWeapontypeGroup(wephash) == 1548507267) and not ismelee then
                --TODO add callback here instead of while loop
                getammoinfo = true
                TriggerServerEvent("vorpinventory:getammoinfo")
                while getammoinfo do
                    Wait(100)
                end

                local wepgroup = GetWeapontypeGroup(wephash)
                local ammotypes = SharedData.AmmoTypes[wepgroup]
                local playerammo = playerammoinfo.ammo
                if ammotypes and playerammo then
                    for k, v in pairs(ammotypes) do
                        if contains(playerammo, v) then
                            local ammoQty = Citizen.InvokeNative(0x39D22031557946C1, PlayerPedId, joaat(v)) --GET_PED_AMMO_BY_TYPE
                            if not ammoQty or ((GetWeapontypeGroup(wephash) == 1548507267 or GetWeapontypeGroup(wephash) == -1241684019) and ammoQty == 1) then
                                ammoQty = 0
                            end
                            if playerammo[v] ~= ammoQty then
                                playerammoinfo.ammo[v] = ammoQty
                                TriggerServerEvent("vorpinventory:updateammo", playerammoinfo)
                                SendNUIMessage({ action = "updateammo", ammo = playerammo })
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
