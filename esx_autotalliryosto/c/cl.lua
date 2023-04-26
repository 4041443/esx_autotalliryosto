local rikottu = 0
local lootattu = 0
local cuuldauni = 0
local coordsh = 27.74
local anim = false
local auki = false
local sisalla = false



local murtovaline = "WEAPON_CROWBAR" -- Esine jonka tarvitset murtoon
local tarvittavatkytat = 1 -- Kuin monta fobbaa alotukseen
local lyontimaara = 5 -- Kuin mont kertaa pitää lyödä ovea
local taimeri = 10 -- Cooldowni kauan joutuu odottaa (minuutteina)

local talli = vector3(-896.84, -152.14, 36.56) -- Talli jonne murtaudutaan

local tutkittavat = {
	[1] = {coords=vector3(169.2650, -1005.7029, -98.9999), heading=84.2256}, -- Koordit kohdille joita voi tutkita
	[2] = {coords=vector3(169.2994, -1002.7993, -98.9999), heading=84.7548},
}

local lootit = { -- Lootit mitä voit saada
	'phone',
	'burana',
	'radio'
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
        if not anim and not auki and not sisalla then
            if (GetDistanceBetweenCoords(coords, talli.x, talli.y, talli.z, true) < 1.0) then
                DrawMarker(2, talli.x, talli.y, talli.z-0.20, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
                if (GetDistanceBetweenCoords(coords, talli.x, talli.y, talli.z, true) < 1.0) then
                    ESX.ShowHelpNotification('Paina ~INPUT_PICKUP~ Murtaaksesi oven')
                    if IsControlJustReleased(0, 46) then
						if GetSelectedPedWeapon(ped) == GetHashKey(murtovaline) then
                        	ESX.TriggerServerCallback('esx_autotalliryosto:policecheck', function(poliisi)
                            	if poliisi >= tarvittavatkytat then
									if cuuldauni <= 0 then
										if math.random(1,5) > 1 then
											TriggerServerEvent('dispatch:talrob', GetEntityCoords(PlayerPedId()))
										end
										local lockpick = exports["lockgame"]:StartLockPickCircle(math.random(2,4), math.random(5,9), true)
                                        if lockpick then
											rikottu = rikottu - rikottu
											ESX.ShowNotification('Tallin ovi aukesi')
											Wait(1000)
											SetEntityCoords(ped, 172.4063, -1008.4038, -98.9999)
											--SetEntityHeading(ped, 120.02)
											sisalla = true
											Wait(1000)
											auki = false
										end
									else
										ESX.ShowNotification('Yritä myöhemmin uudelleen!', "error")
									end
                            	else
									ESX.ShowNotification('Ei tarpeeksi poliiseja', "error")
                            	end
							end)
						else
							ESX.ShowNotification('Tarvitset sorkkaraudan!')
                        end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
	while true do
		Wait(0)
		if sisalla then
			for i=1, #tutkittavat do
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local loottipos = tutkittavat[i].coords
				if (GetDistanceBetweenCoords(coords, loottipos.x, loottipos.y, loottipos.z, true) < 1.0) then
					DrawMarker(2, loottipos.x, loottipos.y, loottipos.z-0.20, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
					if (GetDistanceBetweenCoords(coords, loottipos.x, loottipos.y, loottipos.z, true) < 1.0) then
						ESX.ShowHelpNotification('~INPUT_PICKUP~ Tutki')
						if IsControlJustReleased(0, 46) then
							SetEntityHeading(ped, 82.2256)
							TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
							Wait(10000)
							ClearPedTasksImmediately(ped)
							if lootattu < 5 then
								TriggerServerEvent('esx_autotalliryosto:loottia', lootit)
								lootattu = lootattu + 1
							else
								ESX.ShowNotification('Et löytänyt mitään!')
							end
						end
					end
				end
			end
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			if (GetDistanceBetweenCoords(coords, 172.4063, -1008.4038, -98.9999, true) < 1.0) then
				DrawMarker(2, 172.4063, -1008.4038, -98.9999-0.20, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
				if (GetDistanceBetweenCoords(coords, 172.4063, -1008.4038, -98.9999, true) < 1.0) then
					ESX.ShowHelpNotification('~INPUT_PICKUP~ Poistu')
					if IsControlJustReleased(0, 46) then
						SetEntityCoords(ped, talli.x, talli.y, talli.z)
						sisalla = false
						lootattu = lootattu - lootattu
						cuuldauni = taimeri * 1000 * 60
						Wait(1*1000*60)
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do 
		Wait(5000)
		if cuuldauni > 0 then
			cuuldauni = cuuldauni - 5000
		end
	end
end)