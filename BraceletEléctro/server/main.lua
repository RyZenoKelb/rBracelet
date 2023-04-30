--================================
-- Développé par RyZeno
--================================
ESX		= nil;
Porteur	= {};
OldPor	= {};


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local jobTrue = function(job)
	for _, jobliste in ipairs(Config.metiers) do
		if jobliste == job then
			return true
		end
	end
	return false;
end

local notification = function(message, source)
	if Config.typealerte == "basic" then
		TriggerClientEvent('esx:showNotification', source, message);
	elseif Config.typealerte == "mythic" then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = message, length = 10000})
	end
end


Citizen.CreateThread(function()
	while true do
		local xPlayers	= ESX.GetPlayers();
		OldPor	= Porteur;
		Porteur	= {};

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i]);

			for k,v in ipairs(Config.items) do
				if xPlayer.getInventoryItem(v).count > 0 then
					estLSPD = jobTrue(xPlayer.job.name);
					local tmpplayer = {
						coords = xPlayer.getCoords(false),
						identifier = xPlayer.identifier,
						source = xPlayer.source,
						estLSPD = estLSPD,
						job = xPlayer.job
					}
					table.insert(Porteur, xPlayer);
					break;
				end
			end
		end
				
-- Mise à jour de la liste lors d'une déco/reco
AddEventHandler("playerDropped",function(reason)
	local _source	= source;
	local xPlayer	= ESX.GetPlayerFromId(_source);
	if xPlayer ~= nil then
		for i=1, #Porteur, 1 do
			if Porteur[i].identifier == xPlayer.identifier then
				table.remove(Porteur, i);
				break;
			end
		end
	end
end)

-- Récupération de la liste des joueurs avec Bracelets.
RegisterNetEvent('esx_braceletgps:srv_updateliste')
AddEventHandler('esx_braceletgps:srv_updateliste', function()
	local sPlayer	= ESX.GetPlayerFromId(source);
	TriggerClientEvent('esx_braceletgps:majbracelets', sPlayer.source, Porteur);
end)

-- Retrait du bracelet de la cible.
RegisterNetEvent('esx_braceletgps:coupebracelet')
AddEventHandler('esx_braceletgps:coupebracelet', function(target)
	local tPlayer	= ESX.GetPlayerFromId(target);
	local xPlayer	= ESX.GetPlayerFromId(source);
	tPlayer.removeInventoryItem('braceletgps', 1);
	notification("Vous avez retiré le bracelet GPS de " .. tPlayer.name, xPlayer.source);
end)

ESX.RegisterUsableItem('braceletgpsdiscret', function(source)
	local xPlayer	= ESX.GetPlayerFromId(source);
	local data		= {};
	
	if xPlayer ~= nil then
		xPlayer.removeInventoryItem('braceletgpsdiscret', 1)

		TriggerClientEvent('cd_playerhud:status:add', source, 'hunger', 1);
		TriggerClientEvent('cd_playerhud:status:remove', source, 'thirst', 5);
		TriggerClientEvent('esx_basicneeds:onEat', source);
		notification('~r~Aaahhh~s~ Je crois que je viens d\'en avaler une de travers !!!', source);
	end
end)

ESX.RegisterUsableItem('coupebracelet', function(source)
	local xPlayer	= ESX.GetPlayerFromId(source);
	if xPlayer ~= nil then
		TriggerClientEvent('esx_braceletgps:utilisecoupe', xPlayer.source);
	end
end)