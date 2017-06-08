--function DrawNotif(text)
--	SetNotificationTextEntry("STRING")
--	AddTextComponentString(text)
--	DrawNotification(false, false)
--end

--nameTarget = ""

--RegisterNetEvent("menupolice:f_getTargetN")
--AddEventHandler('menupolice:f_getTargetN', function(info)
--	nameTarget = info[1].. " " ..info[2]
--end)

--AddEventHandler("menupolice:PoliceOG", function(target, rangPolice) -- 0 rien, 1 Cadet, 2 Brigadier, 3 Sergent, 4 Lieutenant, 5 Capitaine, 6 Commandant
--		if target ~= -1 then
--				nameTarget = "You target a civilian"
--		else
--				nameTarget = "No target"
--		end
--		VMenu.police = true
--		VMenu.ResetMenu(98, "", "default")
		Wait(100)
		VMenu.AddFunc(98, "Return", "vmenu:MainMenuOG", {}, "Return")
		VMenu.AddSep(98, tostring(nameTarget))
		if rangPolice == 6 then
				VMenu.AddSep(98, "Commandant")
		elseif rangPolice == 5 then
				VMenu.AddSep(98, "Capitaine")
		elseif rangPolice == 4 then
				VMenu.AddSep(98, "Lieutenant")
		elseif rangPolice == 3 then
				VMenu.AddSep(98, "Sergent")
		elseif rangPolice == 2 then
				VMenu.AddSep(98, "Brigadier")
		elseif rangPolice == 1 then
				VMenu.AddSep(98, "Cadet")
		end
	 	VMenu.AddFunc(98, "Check paper", "menupolice:verifp", {}, "Access")
	 	VMenu.AddNum1000(98, "Contravention amount", "Amcon", 0, 60000, "Amount of contravention")
		VMenu.AddFunc(98, "Donate contravention", "menupolice:givecon", {getOpt("Amcon")}, "Access")
		VMenu.AddFunc(98, "Search the nearest vehicle", "menupolice:searchveh", {}, "Access")
		VMenu.AddFunc(98, "Search the nearest civilian", "menupolice:searchciv", {}, "Access")
		VMenu.AddFunc(98, "Entering dirty money ", "menupolice:seizecash", {}, "Access")
		VMenu.AddFunc(98, "Entering illegal objects", "menupolice:seizedrug", {}, "Access")
		VMenu.AddBool(98, "Escorting a civilian handcuffed", "EscortM", false, "Toggle")
		--VMenu.AddFunc(98, "Escoter un civil menotter", "menupolice:escortcuff", {}, "Accéder")
		VMenu.AddBool(98, "Handcuff / Uncuff", "Menotter", false, "Toggle")
		--VMenu.AddFunc(98, "Menotter", "menupolice:cuff", {}, "Accéder")
		--VMenu.AddFunc(98, "Démenotter", "menupolice:uncuff", {}, "Accéder")
		VMenu.AddFunc(98, "Forcing the entry of a civilian into a vehicle", "menupolice:civtocar", {}, "Access")
		VMenu.AddFunc(98, "Forcing civilians out of vehicle", "menupolice:civuncar", {}, "Access")
		VMenu.AddFunc(98, "Lock Vehicle", "menupolice:unlock", {}, "Access")
		VMenu.AddFunc(98, "View the list of suspects wanted ", "menupolice:consultwanted", {}, "Access")

		-- Ajouter/Retirer dans le commissariat
end)

PhandCuffed = false
PEscorthandCuffed = false
PhandCuffedName = ""

handCuffed = false
EscorthandCuffed = false

EscortGuy = 0

RegisterNetEvent("menupolice:f_cuff")
AddEventHandler('menupolice:f_cuff', function(civitem)
	handCuffed = true
end)

AddEventHandler('menupolice:cuff', function(target)
	PhandCuffed = true
end)

RegisterNetEvent("menupolice:f_escortcuff")
AddEventHandler('menupolice:f_escortcuff', function(civitem, pname, lebool)
	EscortGuy = civitem
	if lebool == true then
		PhandCuffedName  = pname
		EscorthandCuffed = not EscorthandCuffed
		handCuffed = not handCuffed
	else

	end
end)

RegisterNetEvent("menupolice:f_uncuff")
AddEventHandler('menupolice:f_uncuff', function()
	handCuffed = false
end)

AddEventHandler('menupolice:uncuff', function(target)
	if PhandCuffed then
		PhandCuffed = false
	else
		DrawNotif("No civilian nearby handcuffed")
	end
end)

AddEventHandler('menupolice:consultwanted', function()
	TriggerServerEvent("wanted:getWanted")
end)
