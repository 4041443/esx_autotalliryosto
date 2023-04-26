local lootattu = 0

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

ESX.RegisterServerCallback('esx_autotalliryosto:policecheck',function(source, cb)
    local poliisi = 0
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
      local _source = xPlayers[i]
      local xPlayer = ESX.GetPlayerFromId(_source)
	  if xPlayer.job.name == 'police' then
        poliisi = poliisi + 1
      end
    end
    cb(poliisi)
end)

RegisterServerEvent('esx_autotalliryosto:loottia', function(lootit)
	local xPlayer = ESX.GetPlayerFromId(source)
	local mikaitemitulee = math.random(1,#lootit)
	local maara = math.random(1,2)
	xPlayer.addInventoryItem(lootit[mikaitemitulee], maara)
	local nimi = xPlayer.getInventoryItem(mikaitemitulee)
end)