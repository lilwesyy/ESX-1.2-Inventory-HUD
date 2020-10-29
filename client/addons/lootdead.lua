ESX                           = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		if IsControlJustReleased(0, 38) then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if IsPlayerDead(closestPlayer) then 
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					loadAnimDict('amb@medic@standing@kneel@base')
                    loadAnimDict('anim@gangops@facility@servers@bodysearch@')
                    exports['mythic_progbar']:Progress({
                        name = "",
                        duration = 5000,
                        label = _U('lootdead'),
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {},
                        animation = {},
                        prop = {},
                    }, function(status)
                        if not status then
                            TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
					        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search", 1.0)
                            TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(closestPlayer), GetPlayerName(closestPlayer))
                        end
                    end)
                end
            end
		end
	end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end