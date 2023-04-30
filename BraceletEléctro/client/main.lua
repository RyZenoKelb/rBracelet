--================================
-- Développé par RyZeno
--================================
montrerBlips	= false;
autorise		= false;
listebracelets	= {};
listeBlips		= {};
PlayerLoaded	= false;
ESX				= nil;


local initESX = function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0);
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(0);
	end

	PlayerLoaded	= true;
	ESX.PlayerData	= ESX.GetPlayerData();
end


local notification = function(message)
	if Config.typealerte == "basic" then
		ESX.ShowNotificcation(message);
	elseif Config.typealerte == "mythic" then
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = message, length = 10000});
	elseif Config.typealerte == "embed" then
		ESX.ShowAdvancedNotification(Config.nottitre, Config.notsujet, message, Config.notpict, 1);
	end
end


function estEquipe(id)
	local retour = false;
	
	for k,v in pairs(listebracelets) do
		if GetPlayerServerId(id) == v.source then
			retour = true;
			break;
		end
	end

	return retour;
end


function estLSPD(id)
	local retour = false;
	for k,v in pairs(listebracelets) do
		if GetPlayerServerId(id) == v.source then
			for w, x in pairs(Config.metiers) do
				if v.job.name == x then
					if v.job.name == ESX.PlayerData.job.name then
						retour = 1;
					else
						retour = 2;
					end
					break;
					break;
				end
			end
		end
	end
	
	return retour;
end


local jobTrue = function(job)
	for _, jobliste in ipairs(Config.metiers) do
		if jobliste == job then
			return true
		end
	end
	return false;
end

Citizen.CreateThread(function()
	initESX();
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	while ESX == nil do
		Citizen.Wait(0)
	end
	
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


RegisterNetEvent('esx_braceletgps:majbracelets')
AddEventHandler('esx_braceletgps:majbracelets', function(bracelets)
	listebracelets = bracelets;
end)


Citizen.CreateThread(function()
	while true do
		if ESX == nil or ESX.PlayerData.job == nil then
			initESX()
		end
		local temp = false;
		for k,v in ipairs(Config.metiers) do
			if ESX.PlayerData.job.name == v and ESX.PlayerData.job.grade ~= 99 then
				temp = true;
			end
		end
		if temp then
			autorise = true;
			TriggerServerEvent('esx_braceletgps:srv_updateliste');
		else
			autorise = false;
		end
		Citizen.Wait(120000);
	end
end)


RegisterNetEvent('esx_braceletgps:acitvergps');
AddEventHandler('esx_braceletgps:acitvergps', function()
	montrerBlips = not montrerBlips;
	if montrerBlips then
		notification(Config.notmess1);
		
		Citizen.CreateThread(function()
			
			while montrerBlips do
				Citizen.Wait(15000);
				
				for _,blip in pairs(listeBlips) do
					RemoveBlip(blip);
				end
				listeBlips = {};
				if autorise then
					for _, xPlayer in pairs(listebracelets) do
						
						if montrerBlips then
							
							
							if GetPlayerFromServerId(xPlayer.source) ~= -1 then
								blip = AddBlipForEntity(GetPlayerPed(GetPlayerFromServerId(xPlayer.source)));
							else
								blip = AddBlipForCoord(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z);	
							end
							SetBlipSprite(blip, 1);
							if jobTrue(xPlayer.job.name) then
								SetBlipColour(blip, 3);
							else
								SetBlipColour(blip, 1); 
							end
							Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true);
							table.insert(listeBlips, blip);
						end
					end
				end
			end
		end)		
	else
		notification(Config.notmess2);
		for _,blip in pairs(listeBlips) do
			RemoveBlip(blip);
		end
		listeBlips = {};
	end
end)


-- Commande /bracelets pour des/activer l'affichage des Blips
RegisterCommand("bracelets", function(source, args, raw) 
    TriggerEvent("esx_braceletgps:acitvergps")
end, false) 
