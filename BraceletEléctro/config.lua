-- Initialisation Config.
Config		= {};

-- Autorisation pour l'affichage des blips
Config.metiers	= {'police', 'gouv'};
Config.items	= {'braceletgps'};
Config.affall	= true;		
Config.hidall	= false;	-- Utilse si Config.affall == false Le blip est soit affiché en rouge, soit pas affiché

-- Configuration pour le retrait des bracelets
Config.ctrlretrait	= true;

-- Configuration des messages d'activation
Config.notpict	= "CHAR_CALL911";
Config.nottitre	= "Tracker GNSS.";
Config.notsujet	= "GNSS Technique.";
Config.notmess1	= "Activation de l'affichage des Bracelets GPS.";
Config.notmess2	= "Désactivation de l'affichage des Bracelets GPS.";

Config.typealerte = "mythic"; -- basic = message GTA via ESX, mythic = Mythic Notif, embed = Message Avancé GTA via ESX.
