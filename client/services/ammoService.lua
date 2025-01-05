local playerammoinfo   = {}
local updatedAmmoCache = {}
local Core <const>     = exports.vorp_core:GetCore()
local ammoupdate       = true

local function addAmmoToPed(ammoData)
    for ammoType, ammo in pairs(ammoData) do
        SetPedAmmoByType(PlayerPedId(), joaat(ammoType), ammo)
    end
end

RegisterNetEvent("vorpinventory:recammo", function(ammoData)
    playerammoinfo.ammo = ammoData.ammo
end)

RegisterNetEvent("vorpinventory:loaded", function()
    SendNUIMessage({ action = "reclabels", labels = SharedData.AmmoLabels })

    local result <const> = Core.Callback.TriggerAwait("vorpinventory:getammoinfo")
    if not result then return end

    playerammoinfo = result or {}

    addAmmoToPed(playerammoinfo.ammo)
    SendNUIMessage({ action = "updateammo", ammo = playerammoinfo.ammo })
end)

RegisterNetEvent("vorpinventory:updateuiammocount", function(ammo)
    SendNUIMessage({ action = "updateammo", ammo = ammo })
    NUIService.LoadInv()
end)

RegisterNetEvent("vorpinventory:setammotoped", function(ammoData)
    local PlayerPedId <const> = PlayerPedId()
    RemoveAllPedWeapons(PlayerPedId, true, true)
    RemoveAllPedAmmo(PlayerPedId)
    addAmmoToPed(ammoData)
end)

RegisterNetEvent("vorpinventory:updateinventory", function()
    NUIService.LoadInv()
end)

RegisterNetEvent("vorpinventory:ammoUpdateToggle", function(state)
    if not ammoupdate and state then
        local result <const> = Core.Callback.TriggerAwait("vorpinventory:getammoinfo")
        if not result then return end

        playerammoinfo = result or {}
        addAmmoToPed(playerammoinfo.ammo)
        SendNUIMessage({
            action = "updateammo",
            ammo   = playerammoinfo.ammo
        })
    end
    ammoupdate = state
end)

-- https://github.com/abdulkadiraktas/rdr3_discoveries/blob/5916ccf5b3776b7a4d1a2ac05b1f412d7ded5c03/weapons/index.md?plain=1#L200
function GetWeapontypeGroupName(WeapontypeGroupHash)
    if false then
    elseif WeapontypeGroupHash == GetHashKey("GROUP_MELEE") then return "GROUP_MELEE"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_PISTOL") then return "GROUP_PISTOL"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_REPEATER") then return "GROUP_REPEATER"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_REVOLVER") then return "GROUP_REVOLVER"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_RIFLE") then return "GROUP_RIFLE"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_SNIPER") then return "GROUP_SNIPER"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_SHOTGUN") then return "GROUP_SHOTGUN"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_BOW") then return "GROUP_BOW"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_THROWN") then return "GROUP_THROWN"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_HELD") then return "GROUP_HELD"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_PETROLCAN") then return "GROUP_PETROLCAN"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_FISHINGROD") then return "GROUP_FISHINGROD"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_LASSO") then return "GROUP_LASSO"
    elseif WeapontypeGroupHash == GetHashKey("GROUP_UNARMED") then return "GROUP_UNARMED"
    end

    return "WNSTG_INVALID"
end

--* AMMO SAVING THREAD
CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 500

        if not InInventory and playerammoinfo.ammo then
            local playerPedId <const> = PlayerPedId()
            local isArmed <const> = IsPedArmed(playerPedId, 4) == 1
            local wephash <const> = GetPedCurrentHeldWeapon(playerPedId)
            local ismelee <const> = IsWeaponMeleeWeapon(wephash) == 1
            local wepgroup <const> = GetWeapontypeGroupName(GetWeapontypeGroup(wephash))
            local ammotypes <const> = SharedData.AmmoTypes[wepgroup]
            local isThrownGroup <const> = wepgroup == `GROUP_THROWN`
            local isBowGroup <const> = wepgroup == `GROUP_BOW`
            local isPetrol <const> = wepgroup == `GROUP_PETROLCAN`

            if ammotypes and (isArmed or isThrownGroup or isPetrol) and not ismelee then
                for ammo_name, ammo_data in pairs(ammotypes) do
                    if playerammoinfo.ammo[ammo_name] then -- is ammo valid
                        local ammoQty = GetPedAmmoByType(playerPedId, joaat(ammo_name))
                        if (isThrownGroup or isBowGroup or isPetrol) and ammoQty == 1 then
                            ammoQty = 0
                        end

                        if playerammoinfo.ammo[ammo_name] ~= ammoQty then
                            updatedAmmoCache[ammo_name] = ammoQty
                            playerammoinfo.ammo[ammo_name] = ammoQty
                        end
                    end
                end

                if next(updatedAmmoCache) then
                    SendNUIMessage({ action = "updateammo", ammo = playerammoinfo.ammo })
                end
            end
        end
        Wait(sleep)
    end
end)

--* AMMO UPDATE THREAD
CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        if ammoupdate then
            if next(updatedAmmoCache) then
                TriggerServerEvent("vorpinventory:updateammo", playerammoinfo)
                updatedAmmoCache = {}
            end
        end
        Wait(10000) -- update every 10 seconds
    end
end)
