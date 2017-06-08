AddEventHandler("menuanim:AnimOG", function(target)
	VMenu.animations = true
	VMenu.ResetMenu(98, "", "default")
	Wait(100)
	VMenu.AddFunc(98, "Return", "vmenu:MainMenuOG", {}, "Return")
	VMenu.AddFunc(98, "Applaud", "anim:play", {1}, "Validate")
	VMenu.AddFunc(98, "Film", "anim:play", {2}, "Validate")
	VMenu.AddFunc(98, "Play music", "anim:play", {3}, "Validate")
	VMenu.AddFunc(98, "View Map", "anim:play", {4}, "Validate")
	VMenu.AddFunc(98, "Yoga", "anim:play", {5}, "Validate")
	VMenu.AddFunc(98, "Push up", "anim:play", {6}, "Validate")
	VMenu.AddFunc(98, "Humble speech", "anim:play", {7}, "Validate")
	VMenu.AddFunc(98, "The Nabil in the forest", "anim:play", {8}, "Validate")
	VMenu.AddFunc(98, "Come on, I'm here!", "anim:play", {9}, "Validate")
	VMenu.AddFunc(98, "Two thumbs up", "anim:play", {10}, "Validate")
end)

AddEventHandler("anim:play", function(target, anim)
	Wait(100)
	TriggerEvent("vmenu:closeMenu")
	Wait(1000)
	if anim == 1 then
		PlayScenario("WORLD_HUMAN_CHEERING","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 2 then
		PlayScenario("WORLD_HUMAN_MOBILE_FILM_SHOCKING","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 3 then
		PlayScenario("WORLD_HUMAN_MUSICIAN","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 4 then
		PlayScenario("WORLD_HUMAN_TOURIST_MAP","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 5 then
		PlayScenario("WORLD_HUMAN_YOGA","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 6 then
		PlayScenario("WORLD_HUMAN_PUSH_UPS","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 7 then
		TriggerEvent("vmenu:anim", "missmic4premiere", "prem_4stars_a_benton")
	elseif anim == 8 then
		TriggerEvent("vmenu:anim", "missmic4premiere", "prem_actress_star_a")
	elseif anim == 9 then
		TriggerEvent("vmenu:anim", "missmic4premiere", "wave_c")
	elseif anim == 10 then
		TriggerEvent("vmenu:anim", "mp_action", "thanks_male_06")
	end
end)

function PlayScenario(param1, param2, param3)
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(GetPlayerPed(-1), param1, 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), param2, param3)
		Citizen.Wait(20000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end
