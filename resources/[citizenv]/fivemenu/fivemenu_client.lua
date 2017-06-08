--[[
FiveMenu v1.4
by GeeknessFr

détruit par Draziak :)
--]]

--> Voir ReadMe.txt pour la doc.
local livery = 0

VMenu = {

	-----------------------------------------------------
	----------------- CONFIGURATION ---------------------
	-----------------------------------------------------
	-- ATTENTION : Bien laisser la virgule ( , ) à la fin de chaque ligne !
    -- ATTENTION: Leave the comma (,) at the end of each line!


    -- Configuration of Keys
    -- Listing . https.//forum.fivem.net/t/list-of-possible-keys-in-array/1979

    -- {Up, Down, Left, Right, Valid, Back}
    -- keys = {172, 173, 174, 175, 18, 177}, ----- Default values ​​when editing.
keys = {172, 173, 174, 175, 18, 177},
    -- Configuration of a key to open the menu.
    -- If no keys, set nil

    -- Opening the Menu
    --openKey = 167, - F6 - Default
    -- Opening by a server event. -> vmenu: openMenu

--VMenu.openKey = nil - No key.
	mopenKey = 168, -- F6
	openKey = 167, -- F6

	-- For position: Values ​​from 0 to 1 relative to the total size of the game display.! (0 = 0% - 1 = 100%)

-- Top Menu Left corner
	top = 0.01,
	left = 0.01,

	-- Width of the Menu
	width = 0.23,

	-- Number of lines displayed on the menu
	itemsOnScreen = 9,

	HeaderDict = "fivemenu", -- File Name Dictionary without the ".ytd" that is placed in the "stream" folder

	rootMenu = 98, -- ID Start menu (default is 0)

	voiceTarget = true, -- Enables voice targeting, if required.
	-----------------------> User.target Contains the PlayerID when opening the Menu.
	
	checkUser = false, -- Enables the recovery of player information via Essential Mod. (View readme)


	------------------ ADDING
	updatedChar = true,

	mainMenu = false,
	store = false,
	barbershop = false,
	hospital = false,
	outfitshop = false,
	garagepolice = false,
	lockerpolice = false,

	Tanker_company = false,
	Container_company = false,
	Frigorifique_company = false,
	Log_company = false,

	police = false,
	telephone = false,
	animations = false,
	jobs = false,

	Cuffedkeys = {167, 168},
	------------------ END ADD

	-----------------------------------------------------
	----------------- FIN CONFIGURATION -----------------
	-----------------------------------------------------

	visible = false,
	curMenu = 0,
	prevMenu = 0,
	curItem = 1,
	scroll = 0,
	closedTime = 0,
	offsetY = 0.03,
	HdHeight = 0,
	BgHeight = 0.314,
	menus = {},
	items = {},
	disableKeys = { 19, 20, 43, 48, 187, 233, 309, 311, 85, 74, 21, 73, 121, 45, 80, 140, 170, 177, 194, 202, 225, 263},
	target = -1,
	debugKeys = false

}

local VOpts = {
	firstLoad = false,
	toUpdate = nil,
	LastVeh = 0,
	openMenu = false
}

User = {
	Spawned = false,
	Loaded = false,
	group = "0",
	permission_level = 0,
	money = 0,
	dirtymoney = 0,
	job = 0,
	police = 0,
	enService = 0,
	nom = "",
	prenom = "",
	vehicle = "",
	identifier = nil,
	telephone = ""
}

-- AddEventHandler("playerSpawned", function()
-- 	TriggerServerEvent('vmenu:sendData_s')
-- end)
--
-- RegisterNetEvent("vmenu:f_sendData")
-- AddEventHandler("vmenu:f_sendData", function(data) -- Target = Last player to have spoken, no need here. But compulsory!
-- 	VMenu = data
-- 	Citizen.Trace(VMenu[1].top)
-- end)

-------- DISTANCE BETWEEN PLAYER AND POINT
function IsNearPoints(area, dist)
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	for _, item in pairs(area) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance <= dist) then
			return true
		end
	end
end

--------- SICK TEXT DISPLAY
local ShowMsgtime = { msg = "", time = 0 }

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if ShowMsgtime.time ~= 0 then
      drawTxt(ShowMsgtime.msg, 0,1,0.5,0.8,0.6,255,255,255,255)
      ShowMsgtime.time = ShowMsgtime.time - 1
    end
  end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

--------- FIN DÉCLARATION

VMenu.ctop = ((VMenu.width / 2) / 2) + VMenu.top
VMenu.cleft = (VMenu.width / 2) + VMenu.left
VMenu.TextX = VMenu.left + 0.01
VMenu.BgY = VMenu.top + VMenu.HdHeight + (VMenu.BgHeight / 2)




function VMenu.Info(text, loop)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, loop, 1, 0)
end

function VMenu.DrawText(Text, X, Y, ScX, ScY, Font, Outline, Shadow, Center, RightJustify, R, G, B, A)
	SetTextFont(Font)
	SetTextScale(ScX, ScY)
	SetTextColour(R, G, B, A)
	if Outline then
		SetTextOutline()
	end
	if Shadow then
		SetTextDropShadow()
	end
	SetTextCentre(Center)
	SetTextRightJustify(RightJustify)
	SetTextEntry("STRING")
	AddTextComponentString(Text)
	DrawText(X, Y)
end
function VMenu.DrawHeader(td)
	local header = VMenu.menus[VMenu.curMenu].header
	if header ~= nil then
		VMenu.HdHeight = (VMenu.width / 2)
		VMenu.ctop = ((VMenu.width / 2) / 2) + VMenu.top
		if string.lower(header) == "default" then
			DrawSprite(td, "default_bgd", VMenu.cleft, VMenu.ctop, VMenu.width, VMenu.width / 2, 0.0, 255, 255, 255, 255)
			VMenu.DrawText(VMenu.menus[VMenu.curMenu].name, VMenu.left + (VMenu.width / 2), VMenu.top + (VMenu.HdHeight / 2) - 0.02, VMenu.width, 0.8, 7, false, false, true, false, 255, 255, 255, 255)
		else
			DrawSprite(td, header, VMenu.cleft, VMenu.ctop, VMenu.width, VMenu.width / 2, 0.0, 255, 255, 255, 255)
		end
	else
		VMenu.HdHeight = 0
		VMenu.ctop = VMenu.top
	end
end
function VMenu.DrawBg(td)
	local numItems = #VMenu.items[VMenu.curMenu]
	if numItems > VMenu.itemsOnScreen then numItems = VMenu.itemsOnScreen end
	VMenu.BgHeight = numItems * VMenu.offsetY + 0.05
	VMenu.BgY = VMenu.top + VMenu.HdHeight + (VMenu.BgHeight / 2)
	DrawSprite(td, "gradient_bgd", VMenu.cleft, VMenu.BgY , VMenu.width, VMenu.BgHeight, 0.0, 255, 255, 255, 255)
end
function VMenu.DrawItems(td)
	local curMenu = VMenu.curMenu
	local curItem = VMenu.curItem
	local numItems = #VMenu.items[curMenu]
	local menuTitle = string.upper(VMenu.menus[curMenu].name)
	local count = tostring(curItem) .. "/" .. tostring(numItems)
	local footerY = VMenu.BgY + (VMenu.BgHeight / 2)

	VMenu.DrawText(menuTitle, VMenu.TextX, VMenu.top + VMenu.HdHeight + 0.005, 0.30, 0.33, 8, false, false, false, false, 255, 255, 255, 255)
	VMenu.DrawText(count, (VMenu.left + VMenu.width) - 0.02, VMenu.top + VMenu.HdHeight + 0.005, 0.30, 0.33, 8, false, false, false, false, 255, 255, 255, 255)

	for i = 1 + VMenu.scroll, numItems do
		if i > VMenu.itemsOnScreen + VMenu.scroll then
			break
		end

		local itemTitle = VMenu.items[curMenu][i].name
		local itemDesc = VMenu.items[curMenu][i].desc

		if VMenu.items[curMenu][i].type == "separator" then
			VMenu.DrawText("- "..itemTitle.." -", VMenu.left + (VMenu.width / 2), VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.45, 0.45, 6, false, false, true, false, 255, 255, 255, 255)
		elseif i == curItem then
			DrawSprite(td, "gradient_nav", VMenu.cleft, VMenu.top + VMenu.HdHeight + 0.064 + (VMenu.offsetY * (i-1-VMenu.scroll)), VMenu.width, 0.03, 0.0, 255, 255, 255, 255)
			VMenu.DrawText(itemTitle, VMenu.TextX, VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.30, 0.33, 8, false, false, false, false, 0, 0, 0, 255)

			if itemDesc ~= "" and itemDesc ~= nil then
				DrawSprite(td, "gradient_bgd", VMenu.cleft, footerY + 0.045, VMenu.width, 0.030, 0.0, 255, 255, 255, 120)
				VMenu.DrawText(itemDesc, VMenu.TextX, footerY + 0.032, VMenu.width, 0.33, 8, false, false, false, false, 255, 255, 255, 220)
			end

		else
			VMenu.DrawText(itemTitle, VMenu.TextX, VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.30, 0.33, 8, false, false, false, false, 255, 255, 255, 255)
		end

		if VMenu.items[curMenu][i].type == "bool" then
			local sprite = "shop_box_blank"
			local varname = VMenu.items[curMenu][i].varname
			if VOpts[varname] then sprite = "shop_box_tick" end
			if i == curItem then sprite = sprite.."b" end

			DrawSprite(td, sprite, (VMenu.left + VMenu.width) - 0.02, VMenu.top + VMenu.HdHeight + 0.064 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.02, 0.04, 0.0, 255, 255, 255, 200)
		end
		if VMenu.items[curMenu][i].type == "num" then
			local left =  "arrowleft"
			local right = "arrowright"
			local varname = VMenu.items[curMenu][i].varname
			local c = 255
			if i == curItem then
				c = 0
				left = left.."b"
				right = right.."b"
			end

			DrawSprite(td, left, (VMenu.left + VMenu.width) - 0.03, VMenu.top + VMenu.HdHeight + 0.064 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.01, 0.02, 0.0, 255, 255, 255, 200)
			DrawSprite(td, right, (VMenu.left + VMenu.width) - 0.01, VMenu.top + VMenu.HdHeight + 0.064 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.01, 0.02, 0.0, 255, 255, 255, 200)
			VMenu.DrawText(tostring(VOpts[varname][1]), (VMenu.left + VMenu.width) - 0.02, VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.10, 0.33, 8, false, false, true, false, c, c, c, 255)
		end
		if VMenu.items[curMenu][i].type == "num1000" then
			local left =  "arrowleft"
			local right = "arrowright"
			local varname = VMenu.items[curMenu][i].varname
			local c = 255
			if i == curItem then
				c = 0
				left = left.."b"
				right = right.."b"
			end

			DrawSprite(td, left, (VMenu.left + VMenu.width) - 0.03, VMenu.top + VMenu.HdHeight + 0.064 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.01, 0.02, 0.0, 255, 255, 255, 200)
			DrawSprite(td, right, (VMenu.left + VMenu.width) - 0.01, VMenu.top + VMenu.HdHeight + 0.064 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.01, 0.02, 0.0, 255, 255, 255, 200)
			VMenu.DrawText(tostring(VOpts[varname][1]), (VMenu.left + VMenu.width) - 0.02, VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.10, 0.33, 8, false, false, true, false, c, c, c, 255)
		end
		if VMenu.items[curMenu][i].type == "valsub" then
			local varname = VMenu.items[curMenu][i].varname
			local c = 255
			if i == curItem then
				c = 0
			end
			VMenu.DrawText(tostring(VOpts[varname]), (VMenu.left + VMenu.width) - 0.02, VMenu.top + VMenu.HdHeight + 0.050 + (VMenu.offsetY * (i-1-VMenu.scroll)), 0.10, 0.33, 8, false, false, true, false, c, c, c, 255)
		end

	end
	DrawRect(VMenu.cleft, footerY + 0.015, VMenu.width, 0.025, 0, 0, 0, 160);
	DrawSprite(td, "shop_arrows_upanddown", VMenu.cleft, footerY + 0.015, 0.018, 0.03, 0.0, 255, 255, 255, 255)
end
function VMenu.Show()
	if VMenu.visible then
		local td = VMenu.HeaderDict
		if not HasStreamedTextureDictLoaded(td) then
			RequestStreamedTextureDict(td, true)
			while not HasStreamedTextureDictLoaded(td) do
				Wait(10)
			end
		end
		VMenu.DrawHeader(td)
		VMenu.DrawBg(td)
		VMenu.DrawItems(td)
	end
end

function scrollAdjust()
	if #VMenu.items[VMenu.curMenu] > VMenu.itemsOnScreen then
		if VMenu.curItem < math.floor((VMenu.itemsOnScreen) / 2) + 1  then
			VMenu.scroll = 0
		end
		if VMenu.curItem >= math.floor((VMenu.itemsOnScreen) / 2) + 1 then
			VMenu.scroll = VMenu.curItem - (math.floor((VMenu.itemsOnScreen) / 2) + 1)
		end
		if VMenu.scroll + VMenu.itemsOnScreen >= #VMenu.items[VMenu.curMenu] then
			VMenu.scroll = #VMenu.items[VMenu.curMenu] - VMenu.itemsOnScreen
		end
	else
		VMenu.scroll = 0
	end
end

function VMenu.k_down()
	VMenu.curItem = VMenu.curItem + 1;
	if VMenu.curItem > #VMenu.items[VMenu.curMenu] then
		VMenu.curItem = 1
	end
	local infinite = 0
	while VMenu.items[VMenu.curMenu][VMenu.curItem].type == "separator" do
		VMenu.curItem = VMenu.curItem + 1;
		if VMenu.curItem > #VMenu.items[VMenu.curMenu] then
			VMenu.curItem = 1
			infinite = infinite + 1
			if infinite == 2 then
				break
			end
		end
	end
	PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	scrollAdjust()
end

function VMenu.k_up()
	VMenu.curItem = VMenu.curItem - 1;
	if VMenu.curItem < 1 then
		VMenu.curItem = #VMenu.items[VMenu.curMenu]
	end
	local infinite = 0
	while VMenu.items[VMenu.curMenu][VMenu.curItem].type == "separator" do
		VMenu.curItem = VMenu.curItem - 1;
		if VMenu.curItem < 1 then
			VMenu.curItem = #VMenu.items[VMenu.curMenu]
			infinite = infinite + 1
			if infinite == 2 then
				break
			end
		end
	end
	PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	scrollAdjust()
end

function VMenu.k_left()
	if VMenu.items[VMenu.curMenu][VMenu.curItem].type == "num" then
		local varname = VMenu.items[VMenu.curMenu][VMenu.curItem].varname
		VOpts[varname][1] = VOpts[varname][1] - 1
		if VOpts[varname][1] < VOpts[varname][2] then VOpts[varname][1] = VOpts[varname][3] end
		VOpts['toUpdate'] = varname
		PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end
	if VMenu.items[VMenu.curMenu][VMenu.curItem].type == "num1000" then
		local varname = VMenu.items[VMenu.curMenu][VMenu.curItem].varname
		VOpts[varname][1] = VOpts[varname][1] - 1000
		if VOpts[varname][1] < VOpts[varname][2] then VOpts[varname][1] = VOpts[varname][3] end
		VOpts['toUpdate'] = varname
		PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end
end

function VMenu.k_right()
	if VMenu.items[VMenu.curMenu][VMenu.curItem].type == "num" then
		local varname = VMenu.items[VMenu.curMenu][VMenu.curItem].varname
		VOpts[varname][1] = VOpts[varname][1] + 1
		if VOpts[varname][1] > VOpts[varname][3] then VOpts[varname][1] = VOpts[varname][2] end
		VOpts['toUpdate'] = varname
		PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end
	if VMenu.items[VMenu.curMenu][VMenu.curItem].type == "num1000" then
		local varname = VMenu.items[VMenu.curMenu][VMenu.curItem].varname
		VOpts[varname][1] = VOpts[varname][1] + 1000
		if VOpts[varname][1] > VOpts[varname][3] then VOpts[varname][1] = VOpts[varname][2] end
		VOpts['toUpdate'] = varname
		PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end
end

function VMenu.valid()
	local curMenu = VMenu.curMenu
	local curItem = VMenu.curItem
	if (VMenu.items[curMenu][curItem].type == "sub" or VMenu.items[curMenu][curItem].type == "valsub") and VMenu.items[curMenu][curItem].toMenu ~= nil then
		local newMenu = VMenu.items[curMenu][curItem].toMenu
		VMenu.menus[newMenu].prev = curMenu
		VMenu.menus[curMenu].select = curItem
		VMenu.curMenu = newMenu
		VMenu.curItem = VMenu.menus[newMenu].select
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		scrollAdjust()
		Wait(1000)
	end
	if VMenu.items[curMenu][curItem].type == "func" and VMenu.items[curMenu][curItem].func ~= nil then
		local func = VMenu.items[curMenu][curItem].func
		local params = VMenu.items[curMenu][curItem].params
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		TriggerEvent(func, VMenu.target, table.unpack(params))
		if VMenu.curMenu == 5 then
			TriggerEvent("vmenu:closeMenu")
		elseif VMenu.curMenu == 7 then
			TriggerEvent("vmenu:closeMenu")
		elseif VMenu.curMenu == 15 then
			TriggerEvent("vmenu:closeMenu")
		elseif VMenu.curMenu == 98 then
			--TriggerServerEvent("inventory:getItems_s")
			getMainMenu()
		end
		if #VMenu.items[curMenu] < curItem then
			if VMenu.telephone then
				VMenu.curItem = 2
				curItem = 2
			else
				VMenu.curItem = 1
				curItem = 1
			end
		end
		scrollAdjust()
		Wait(1000)
	end
	if VMenu.items[curMenu][curItem].type == "bool" and VMenu.items[curMenu][curItem].varname ~= nil then
		VOpts[VMenu.items[curMenu][curItem].varname] = not VOpts[VMenu.items[curMenu][curItem].varname]
		VOpts['toUpdate'] = VMenu.items[curMenu][curItem].varname
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		Wait(1000)
	end
end

function VMenu.back()
	if VMenu.curMenu ~= VMenu.rootMenu then
		local curMenu = VMenu.curMenu
		local newMenu = VMenu.menus[curMenu].prev
		VMenu.menus[curMenu].prev = 0
		VMenu.menus[curMenu].select = VMenu.curItem
		VMenu.curMenu = newMenu
		VMenu.curItem = VMenu.menus[newMenu].select
		scrollAdjust()
	else
		TriggerEvent("vmenu:closeMenu")
	end
end


local k_delay = 200 -- 1er Delay
local k_delay2 = 160 -- puis 2 3 et 4ème delay
local k_delay3 = 50 -- et si touche restée appuyée.



local jLastKey = 0
local jTimer = 0
function isJustPressedKey(key)
	if key ~= jLastKey and IsDisabledControlPressed(0, key) then -- Pas la même touche -> RESET
		jLastKey = key
		jTimer = GetGameTimer()
		return true

	elseif key == jLastKey and IsDisabledControlPressed(0, key) then -- Meme Touche
		if GetGameTimer() - jTimer < k_delay3 then
			while IsDisabledControlPressed(0, key) do
				Wait(1)
			end
			return false
		else
			jTimer = GetGameTimer()
			return true
		end

	end
	return false
end

local lastKey = 0
local timer = 0
local count = 0
local pass = false

function isPressedKey(key)
	if key ~= lastKey and IsDisabledControlPressed(0, key) then -- Pas la même touche -> RESET
		lastKey = key
		timer = GetGameTimer()
		count = 0
		pass = false
		return true

	elseif key == lastKey and IsDisabledControlPressed(0, key) then -- Meme Touche
		if pass then 										-- Accélération du défilement
			count = 0
			if GetGameTimer() - timer > k_delay3 and GetGameTimer() - timer < k_delay then
				timer = GetGameTimer()
				return true
			elseif GetGameTimer() - timer > k_delay then
				pass = false
				timer = GetGameTimer()
				return true
			end
			return false
		elseif GetGameTimer() - timer > k_delay + 100 then
			count = 0
			timer = GetGameTimer()
			return true
		elseif GetGameTimer() - timer > k_delay then
			count = 1
			timer = GetGameTimer()
			return true
		elseif GetGameTimer() - timer > k_delay2 and (count > 0 and count < 5) then
			count = count + 1
			timer = GetGameTimer()
			return true
		elseif count > 4 then
			pass = true
			return false
		end
		return false
	end
	return false
end

function VMenu.test_keys()
	Citizen.CreateThread(function()
		while true do
			Wait(5)
			if VMenu.visible then
				if isPressedKey(VMenu.keys[1]) then
					VMenu.k_up()
				elseif isPressedKey(VMenu.keys[2]) then
					VMenu.k_down()
				elseif isPressedKey(VMenu.keys[3]) then
					VMenu.k_left()
				elseif isPressedKey(VMenu.keys[4]) then
					VMenu.k_right()
				elseif isJustPressedKey(VMenu.keys[5]) then
					VMenu.valid()
				elseif isJustPressedKey(VMenu.keys[6]) then
					VMenu.back()
				end
			end
			if VMenu.openKey ~= nil then
				if IsControlPressed(0, VMenu.openKey) or IsDisabledControlPressed(0, VMenu.openKey) then
					if VMenu.curMenu ~= 98 then
						if VMenu.visible then
							TriggerEvent("vmenu:toggleMenu")
						end
						if (VMenu.updatedChar == false) then
							Wait(500)
							TriggerServerEvent("vmenu:lastChar")
							Wait(200)
						end
					end
					Wait(200)
				end
			end
			if VMenu.mopenKey ~= nil then
				if IsControlPressed(0, VMenu.mopenKey) or IsDisabledControlPressed(0, VMenu.mopenKey) then
					if VMenu.curMenu == 98 then
						if VMenu.visible then
							TriggerEvent("vmenu:toggleMenu")
						else
							TriggerEvent("vmenu:openMenu", 98)
						end
					end
					Wait(200)
				end
			end

		end
	end)
end

function VMenu.DisableControls()
	for i = 1, #VMenu.keys do
		DisableControlAction(0,  VMenu.keys[i],  1)
	end
	for i = 1, #VMenu.disableKeys do
		DisableControlAction(0,  VMenu.disableKeys[i],  1)
	end
end

function DisableControlsHandCuffed()
	for i = 1, #VMenu.Cuffedkeys do
		DisableControlAction(0,  VMenu.Cuffedkeys[i],  1)
	end
end


function VMenu.AddMenu(id, menu, header)
	VMenu.menus[id] = {}
	VMenu.menus[id].name = menu
	VMenu.menus[id].header = header
	VMenu.menus[id].prev = 0 -- Default Value
	VMenu.menus[id].select = 1 -- Default Value
	VMenu.items[id] = {} 	-- Table Creation / Reset
end

function VMenu.ResetMenu(id, menu, header)
	VMenu.items[id] = {} 	-- Table Creation / Reset
end

function VMenu.AddSep(bindMenu, item)
	local size = #VMenu.items[bindMenu]
	VMenu.items[bindMenu][size+1] = {}
	VMenu.items[bindMenu][size+1].type = "separator"
	VMenu.items[bindMenu][size+1].name = item
	VMenu.items[bindMenu][size+1].desc = nil
end
function VMenu.EditSep(bindMenu, item)
	local size = nil
	for i = 1, #VMenu.items[bindMenu] do
		if VMenu.items[bindMenu][i].type == "separator" then
			size = i
			break
		end
	end
	VMenu.items[bindMenu][size] = {}
	VMenu.items[bindMenu][size].type = "separator"
	VMenu.items[bindMenu][size].name = tostring(item)
	VMenu.items[bindMenu][size].desc = nil
end
function VMenu.AddSub(bindMenu, item, toMenu, desc)
	local size = #VMenu.items[bindMenu]
	VMenu.items[bindMenu][size+1] = {}
	VMenu.items[bindMenu][size+1].type = "sub"
	VMenu.items[bindMenu][size+1].name = item
	VMenu.items[bindMenu][size+1].toMenu = toMenu
	VMenu.items[bindMenu][size+1].desc = desc
end
function VMenu.AddFunc(bindMenu, item, func, params, desc)
	local size = #VMenu.items[bindMenu]
	VMenu.items[bindMenu][size+1] = {}
	VMenu.items[bindMenu][size+1].type = "func"
	VMenu.items[bindMenu][size+1].name = item
	VMenu.items[bindMenu][size+1].func = func
	VMenu.items[bindMenu][size+1].params = params
	VMenu.items[bindMenu][size+1].desc = desc
end
function VMenu.EditFunc(bindMenu, item, func, params, desc)
	local size = nil
	for i = 1, #VMenu.items[bindMenu] do
		if VMenu.items[bindMenu][i].name == item then
			size = i
			break
		end
	end
	VMenu.items[bindMenu][size] = {}
	VMenu.items[bindMenu][size].type = "func"
	VMenu.items[bindMenu][size].name = item
	VMenu.items[bindMenu][size].func = func
	VMenu.items[bindMenu][size].params = params
	VMenu.items[bindMenu][size].desc = desc
end
function VMenu.AddBool(bindMenu, item, varname, value, desc)
	local size = #VMenu.items[bindMenu]
	VMenu.items[bindMenu][size+1] = {}
	VMenu.items[bindMenu][size+1].type = "bool"
	VMenu.items[bindMenu][size+1].name = item
	VMenu.items[bindMenu][size+1].varname = varname
	VMenu.items[bindMenu][size+1].desc = desc
	VOpts[varname] = value
end
function VMenu.AddNum(bindMenu, item, varname, valmin, valmax, desc)
	local size = #VMenu.items[bindMenu]
	VMenu.items[bindMenu][size+1] = {}
	VMenu.items[bindMenu][size+1].type = "num"
	VMenu.items[bindMenu][size+1].name = item
	VMenu.items[bindMenu][size+1].varname = varname
	VMenu.items[bindMenu][size+1].desc = desc
	VOpts[varname] = {valmin, valmin, valmax}
end
function VMenu.AddNum1000(bindMenu, item, varname, valmin, valmax, desc)
	local size = #VMenu.items[bindMenu]
	VMenu.items[bindMenu][size+1] = {}
	VMenu.items[bindMenu][size+1].type = "num1000"
	VMenu.items[bindMenu][size+1].name = item
	VMenu.items[bindMenu][size+1].varname = varname
	VMenu.items[bindMenu][size+1].desc = desc
	VOpts[varname] = {valmin, valmin, valmax}
end
function VMenu.EditNum(bindMenu, item, varname, valmin, valmax, desc)
	VOpts[varname] = {valmin, valmin, valmax}
end

function VMenu.AddValSub(bindMenu, item, varname, value, toMenu, desc)
	local size = #VMenu.items[bindMenu]
	VMenu.items[bindMenu][size+1] = {}
	VMenu.items[bindMenu][size+1].type = "valsub"
	VMenu.items[bindMenu][size+1].name = item
	VMenu.items[bindMenu][size+1].varname = varname
	VMenu.items[bindMenu][size+1].toMenu = toMenu
	VMenu.items[bindMenu][size+1].desc = desc
	VOpts[varname] = value
end

function getOpt(varname)
	if type(VOpts[varname]) == "boolean" or type(VOpts[varname]) == "number" then
		return VOpts[varname]
	end
	if type(VOpts[varname]) == "table" then
		return VOpts[varname][1]
	end
end

function setOpt(varname, value)
	if type(VOpts[varname]) == "table" and #VOpts[varname] == 3 then
		VOpts[varname][1] = value
	else
		VOpts[varname] = value
	end
end

function list_keys()
	for tk = 0, 345 do
		if IsControlJustReleased(0,  tk) then
			VMenu.notif("Key :"..tostring(tk))
		end
	end
end

function VMenu.notif(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterNetEvent("vmenu:toggleMenu")
AddEventHandler("vmenu:toggleMenu", function()
	-- Update Server avant ouverture
	ClearHelp(true)
	if not VMenu.visible then
		TriggerServerEvent("vmenu:getUpdates", true)
	else
		VMenu.target = -1
		VMenu.visible = false
		VMenu.closedTime = GetGameTimer()
	end
end)

RegisterNetEvent("vmenu:openMenu")
AddEventHandler("vmenu:openMenu", function(menuid)
	ClearHelp(true)
	menuid = menuid or VMenu.rootMenu
	VMenu.rootMenu = menuid
	VMenu.curMenu = menuid
	TriggerServerEvent("vmenu:getUpdates", true)
end)

RegisterNetEvent("vmenu:serverOpenMenu")
AddEventHandler("vmenu:serverOpenMenu", function(Opts)
	for k,v in pairs(Opts) do
		setOpt(k, v)
	end
	if VOpts['openMenu'] then
		VMenu.visible = true
		setOpt('openMenu', false)
	end
end)

RegisterNetEvent("vmenu:setUser")
AddEventHandler("vmenu:setUser", function(infos)
	for k,v in pairs(infos) do
		User[k] = v
	end
end)

RegisterNetEvent("vmenu:setCarUser")
AddEventHandler("vmenu:setCarUser", function(infos)
	User.vehicle = infos
end)

RegisterNetEvent("vmenu:closeMenu")
AddEventHandler("vmenu:closeMenu", function()
	VMenu.target = -1
	VMenu.visible = false
	VMenu.closedTime = GetGameTimer()
end)

function playerSpawned()
	if VMenu.checkUser and (not User.Loaded and User.identifier == nil) then
		User.Spawned = true
		TriggerServerEvent("vmenu:updateUser", false)
		local trig = GetGameTimer()
		while not User.Loaded and User.identifier == nil do
			if GetGameTimer() - trig > 1000 then
				TriggerServerEvent("vmenu:updateUser", false)
				trig = GetGameTimer()
			end
			Wait(20)
		end
	end
end

AddEventHandler("playerSpawned", function()
	playerSpawned()
end)

-------------------------------------------------------------------------------------
------------------------------- CREATION DU MENU ------------------------------------
-------------------------------------------------------------------------------------

-- Voir ReadMe.txt --


function Construct()
	local menu = 0
	VMenu.AddMenu(menu, "Menu Test", "header_bgd")
	if User.group == "superadmin" then VMenu.AddSub(menu, "~r~Administrator", 99, "Admin Menu") end
	VMenu.AddSub(menu, "Vehicle", 1, "Vehicle Control")
	VMenu.AddSub(menu, "Outfits", 2, "Clothing Menu")
	VMenu.AddSub(menu, "Interactions", 3, "Test Default Header")
	VMenu.AddValSub(menu, "Bottle of water", "BottlesNumber", 0, 4, "Server Query Test")
	VMenu.AddSub(menu, "Test 2", nil, nil)
	VMenu.AddSub(menu, "Test 3", nil, "Menu Test")
	VMenu.AddSub(menu, "Test 4", nil, nil)
	VMenu.AddSub(menu, "Test 5", nil, nil)
	VMenu.AddSub(menu, "Test 6", nil, nil)
	VMenu.AddSub(menu, "Test 7", nil, nil)
	VMenu.AddSub(menu, "Test 8", nil, nil)
	VMenu.AddSub(menu, "Test 9", nil, nil)
	VMenu.AddSub(menu, "Test 10", nil)

	if User.group == "superadmin" then
		local menu = 99
		VMenu.AddMenu(menu, "Administrator", "header_bgd")
		VMenu.AddFunc(menu, "Teleport to marker", "vmenu:teleport_marker", {}, "")
		VMenu.AddSep(menu, "Vehicles Spawner")
		VMenu.AddSep(menu, "Cars")
		VMenu.AddFunc(menu, "Adder", "vmenu:spawnVeh", {"adder"}, "")
		VMenu.AddFunc(menu, "Futo", "vmenu:spawnVeh", {"futo"}, "")
		VMenu.AddFunc(menu, "Infernus", "vmenu:spawnVeh", {"infernus"}, "")
		VMenu.AddFunc(menu, "Oracle", "vmenu:spawnVeh", {"oracle2"}, "")
		VMenu.AddFunc(menu, "Oracle XS", "vmenu:spawnVeh", {"oracle"}, "")
		VMenu.AddFunc(menu, "Sultan", "vmenu:spawnVeh", {"sultan"}, "")
		VMenu.AddFunc(menu, "Tampa Drift", "vmenu:spawnVeh", {"tampa2"}, "")
		VMenu.AddFunc(menu, "Windsor Cab", "vmenu:spawnVeh", {"windsor2"}, "")
		VMenu.AddSep(menu, "Motos")
		VMenu.AddFunc(menu, "Akuma", "vmenu:spawnVeh", {"akuma"}, "")
		VMenu.AddFunc(menu, "Cliffhanger", "vmenu:spawnVeh", {"cliffhanger"}, "")
		VMenu.AddFunc(menu, "Gargoyle", "vmenu:spawnVeh", {"gargoyle"}, "")
		VMenu.AddFunc(menu, "Sanchez", "vmenu:spawnVeh", {"sanchez"}, "")
		VMenu.AddSep(menu, "Bateaux")
		VMenu.AddFunc(menu, "Dinghy", "vmenu:spawnVeh", {"dinghy"}, "")
		VMenu.AddFunc(menu, "Jetmax", "vmenu:spawnVeh", {"jetmax"}, "")
		VMenu.AddFunc(menu, "Suntrap", "vmenu:spawnVeh", {"suntrap"}, "")
		VMenu.AddSep(menu, "Hélicos")
		VMenu.AddFunc(menu, "buzzard", "vmenu:spawnVeh", {"buzzard"}, "")
		VMenu.AddFunc(menu, "Cargo Bob", "vmenu:spawnVeh", {"cargobob"}, "")
		VMenu.AddFunc(menu, "Swift Deluxe", "vmenu:spawnVeh", {"swift2"}, "")
		VMenu.AddSep(menu, "Avions")
		VMenu.AddFunc(menu, "Besra", "vmenu:spawnVeh", {"besra"}, "")
		VMenu.AddFunc(menu, "Dodo", "vmenu:spawnVeh", {"dodo"}, "")
		VMenu.AddFunc(menu, "Luxor VIP", "vmenu:spawnVeh", {"luxor2"}, "")
		VMenu.AddFunc(menu, "Stunt Plane", "vmenu:spawnVeh", {"stunt"}, "")
		VMenu.AddSep(menu, "Vélos")
		VMenu.AddFunc(menu, "BMX", "vmenu:spawnVeh", {"bmx"}, "")
		VMenu.AddFunc(menu, "Fixter", "vmenu:spawnVeh", {"fixter"}, "")
		VMenu.AddFunc(menu, "Scorcher", "vmenu:spawnVeh", {"scorcher"}, "")
	end

	local menu = 1
	VMenu.AddMenu(menu, "Vehicle", "carmod")
	VMenu.AddBool(menu, "Engine", "Engine", false, "Engine On / Off")
	VMenu.AddNum(menu, "Main Color", "VehColor", 0, 160, "Changes main vehicle color")
	VMenu.AddNum(menu, "Secondary Color", "VehColorS", 0, 160, "Change the secondary color of the vehicle")

	local menu = 2
	VMenu.AddMenu(menu, "Outfits (Sans Header)", nil) -- nil = Aucun Header
	VMenu.AddSub(menu, "Outfit 1", nil, "Do nothing...")
	VMenu.AddSub(menu, "Outfit 2", nil, "Do nothing...")
	VMenu.AddSub(menu, "Outfit 3", nil, "Do nothing...")
	VMenu.AddSub(menu, "Outfit 4", nil, "Do nothing...")
	VMenu.AddSub(menu, "Outfit 5", nil, "Do nothing...")

	local menu = 3
	VMenu.AddMenu(menu, "Interactions", "default") -- default = Header "Texte" sur fond bleu
	VMenu.AddSub(menu, "Test 1", nil, "Do nothing...")
	VMenu.AddSub(menu, "Test 2", nil, "Do nothing...")
	VMenu.AddSub(menu, "Test 3", nil, "Do nothing...")
	VMenu.AddSub(menu, "Test 4", nil, "Do nothing...")
	VMenu.AddSub(menu, "Test 5", nil, "Do nothing...")

	local menu = 4
	VMenu.AddMenu(menu, "Bottle of water", "default") -- default = Header "Texte" sur fond bleu
	VMenu.AddFunc(menu, "Use", "inv:use", {"waterbottle"}, nil)
	VMenu.AddFunc(menu, "Give", "inv:give", {"waterbottle"}, nil)
	VMenu.AddFunc(menu, "~r~Drop", "inv:drop", {"waterbottle"}, nil)
	VMenu.AddFunc(menu, "Sell", "inv:sell", {"waterbottle"}, nil)

	local menu = 5
	VMenu.AddMenu(menu, "", "cloth") -- default = Header "Texte" sur fond bleu
	VMenu.AddFunc(menu, "On duty", "vmenu:policeState", {1}, "Being on duty")
	--Citizen.Trace(User.police)
	--if User.police == 6 then
	VMenu.AddFunc(menu, "In civilian service", "vmenu:policeStateCivil", {1}, "Being on duty")
	--end
	VMenu.AddFunc(menu, "Off Duty", "vmenu:policeState", {0}, "Being off duty")

	local menu = 6
	VMenu.AddMenu(menu, "", "armory") -- default = Header "Texte" sur fond bleu
	VMenu.AddFunc(menu, "M4", "vmenu:getArmory", {"WEAPON_CARBINERIFLE"}, "Get this weapon")
	VMenu.AddFunc(menu, "Pump Shotgun", "vmenu:getArmory", {"WEAPON_PUMPSHOTGUN"}, "Get this weapon")
	VMenu.AddFunc(menu, "Pistol", "vmenu:getArmory", {"WEAPON_PISTOL"}, "Get this weapon")
	VMenu.AddFunc(menu, "Nightstick", "vmenu:getArmory", {"WEAPON_NIGHTSTICK"}, "Get this weapon")

	local menu = 7
	VMenu.AddMenu(menu, "", "default") -- default = Header "Texte" sur fond bleu
	TriggerServerEvent('vmenu:updateUser', 7)
	Citizen.Wait(100)
	if User.vehicle == 0 then
		if User.enService == 1 then
			if User.police >= 1 then
				VMenu.AddFunc(menu, "Crown Victoria police", "vmenu:getGarage", {"police7"}, "Get this car")
				VMenu.AddFunc(menu, "Impala police", "vmenu:getGarage", {"police8"}, "Get this car")
				VMenu.AddFunc(menu, "Charger Sheriff", "vmenu:getGarage", {"sheriff"}, "Get this car")
			end
			if User.police >= 2 then
				VMenu.AddFunc(menu, "Taurus police", "vmenu:getGarage", {"police4"}, "Get this car")
				VMenu.AddFunc(menu, "Suberban Sheriff", "vmenu:getGarage", {"sheriff2"}, "Get this car")
				VMenu.AddFunc(menu, "Crown Victoria Sheriff", "vmenu:getGarage", {"sheriff3"}, "Get this car")
			end
			if User.police >= 3 then
				VMenu.AddFunc(menu, "Charger police", "vmenu:getGarage", {"police2"}, "Get this car")
			end
			if User.police >= 4 then
				VMenu.AddFunc(menu, "Suberban K9", "vmenu:getGarage", {"police6"}, "Get this car")
			end
			if User.police >= 5 then
				VMenu.AddFunc(menu, "Taho trivialized", "vmenu:getGarage", {"fbi2"}, "Get this car")
				VMenu.AddFunc(menu, "Charger trivialized", "vmenu:getGarage", {"fbi"}, "Get this car")
			end
			if User.police >= 6 then
				VMenu.AddFunc(menu, "Police explorer interceptor", "vmenu:getGarage", {"police3"}, "Get this car")
				VMenu.AddFunc(menu, "Interceptor police 2017", "vmenu:getGarage", {"police5"}, "Get this car")
			end
		end
	else
		VMenu.AddFunc(menu, "Storing your vehicle", "vmenu:toGarage", {}, "It must be before you")
	end

	local menu = 8
	VMenu.AddMenu(menu, "Outfits", "cloth") -- default = Header "Texte" sur fond bleu
	VMenu.AddNum(menu, "Categorie", "Outfits", 0, 65, "Change category")
	VMenu.AddSep(menu, OutfitsCat[1])
	VMenu.AddFunc(menu, "Validate Outfit Categories", "vmenu:OutfitsValidate", {getOpt("Outfits")}, "Validate")

	local menu = 9
	VMenu.AddMenu(menu, "", "default") -- default = Header "Texte" sur fond bleu
	VMenu.AddNum(menu, "Hairdressing", "Hair", 0, 22, "Change the hairstyle")
	VMenu.AddNum(menu, "Color", "HairColor", 0, 6, "Change Hair color")
	VMenu.AddFunc(menu, "Validate", "vmenu:getclientHair", {getOpt("Hair"),getOpt("HairColor")}, "Get this hairstyle")

	local menu = 10
	VMenu.AddMenu(menu, "", "default") -- default = Header "Texte" sur fond bleu
	VMenu.AddNum(menu, "Sex", "Sex", 0, 1, "Change Sex")
	VMenu.AddNum(menu, "Face", "Face", 0, 45, "Change Face")
	VMenu.AddFunc(menu, "Validate", "vmenu:getclientFace", {getOpt("Sex"),getOpt("Face"),0}, "Get this change")

	local menu = 11
	VMenu.AddMenu(menu, "", "default") -- default = Header "Texte" sur fond bleu
	for _, item in pairs(inv_array_legal) do
		VMenu.AddFunc(menu, item.name, "inventory:buy", {1, item.id, item.price, item.name}, "Buy")
	end

	local menu = 12
	VMenu.AddMenu(menu, "", "default")
	VMenu.AddSep(menu, "Cadet")

	------- MENU POUR ENTREPRISE CAMION
	local menu = 13
	VMenu.AddMenu(menu, "", "default")
	VMenu.AddFunc(menu, "Tank", "transporter:optionMission", {0}, "Choose")
	VMenu.AddFunc(menu, "Container", "transporter:optionMission", {1}, "Choose")
	VMenu.AddFunc(menu, "Refrigerated", "transporter:optionMission", {2}, "Choose")
	VMenu.AddFunc(menu, "Wood", "transporter:optionMission", {3}, "Choose")

	local menu = 14
	VMenu.AddMenu(menu, "", "default")
	VMenu.AddFunc(menu, "Buy information", "menudrogue:info", {0}, "Buy")

	local menu = 15
	VMenu.AddMenu(menu, "", "default")
	for _, item in pairs(jobs) do
		VMenu.AddFunc(menu, item.name, "vmenu:poleemploi", {item.id}, "Validate")
	end

	local menu = 16
	VMenu.AddMenu(menu, "", "default")
	VMenu.AddFunc(menu, "Wash your dirty money (30% return)", "vmenu:cleanCash", {}, "Validate")


	------- MAIN MENU F7
	local menu = 98
	VMenu.AddMenu(menu, "", "default") -- default = Header "Texte" sur fond bleu
	VMenu.AddSep(menu, "Shopping area")
end


----- FUNCTION PERSO
function getOutfitsMenu(id, OutfitsNo)
	local i = 0
	for _, item in pairs(outfits) do
		if item.id == id then
			i = i + 1
			if i == OutfitsNo then
				args = { item.zero[1],item.zero[2],item.two[1],item.two[2],item.four[1],item.four[2],item.six[1],item.six[2],item.eleven[1],item.eleven[2],item.eight[1],item.eight[2],item.three[1],item.three[2],item.seven[1],item.seven[2],GetHashKey("mp_m_freemode_01") }
				TriggerEvent("vmenu:updateCharInShop", args)
				break
			end
		end
	end
end

function getMainMenu()
	if VMenu.police == false and VMenu.telephone == false and VMenu.animations == false then
		TriggerServerEvent('vmenu:updateUser', 98)
		TriggerServerEvent("inventory:getItems_s")
		VMenu.ResetMenu(98, "", "default")
		Wait(10)
		VMenu.AddSep(98, User.nom .. " " .. User.prenom)
		VMenu.AddSep(98, "Tel:" .. User.telephone)
		-- LE MENU DE LA POLICE
		--if User.police > 0 then
			--VMenu.AddFunc(98, "Police Menu", "menupolice:PoliceOG", {User.police}, "Access")
		--end
		-- 	lE MENU SELON LA JOB
		VMenu.AddSep(98, jobsname[User.job])

		VMenu.AddFunc(98, "Emotes", "menuanim:AnimOG", {}, "Access")
		VMenu.AddFunc(98, "Index", "menutel:PhoneOG", {User.telephone}, "Access")
		VMenu.AddSep(98, "Inventory")
		for ind, value in ipairs(ITEMS) do
			if value.quantity > 0 then
				VMenu.AddFunc(98, tostring(value.libelle), "inventory:useItem", {ind}, "Amount : " .. tostring(value.quantity))
			end
		end
	end
end

function getGaragePolice()
	TriggerServerEvent('vmenu:updateUser', 7)
	Wait(200)
	VMenu.ResetMenu(7, "", "default")
		if User.enService == 1 then
			if User.police >= 1 then
				VMenu.AddFunc(7, "Return your vehicle", "vmenu:toGarage", {}, "It must be before you.")
				VMenu.AddFunc(7, "Crown Victoria police", "vmenu:getGarage", {"police7"}, "Get this car")
				VMenu.AddFunc(7, "Impala police", "vmenu:getGarage", {"police8"}, "Get this car")
				VMenu.AddFunc(7, "Crown Victoria", "vmenu:getGarage", {"sheriff3"}, "Get this car")
			end
			if User.police >= 2 then
				VMenu.AddFunc(7, "Taurus police", "vmenu:getGarage", {"police4"}, "Get this car")
				VMenu.AddFunc(7, "Charger", "vmenu:getGarage", {"sheriff"}, "Get this car")
				VMenu.AddFunc(7, "Suberban", "vmenu:getGarage", {"sheriff2"}, "Get this car")
			end
			if User.police >= 3 then
				VMenu.AddFunc(7, "Charger police", "vmenu:getGarage", {"police2"}, "Get this car")
			end
			if User.police >= 4 then
				VMenu.AddFunc(7, "Suberban K9", "vmenu:getGarage", {"police6"}, "Get this car")
			end
			if User.police >= 5 then
				VMenu.AddFunc(7, "Taho banalisée", "vmenu:getGarage", {"fbi2"}, "Get this car")
				VMenu.AddFunc(7, "Charger banalisée", "vmenu:getGarage", {"fbi"}, "Get this car")
			end
			if User.police >= 6 then
				VMenu.AddFunc(7, "Police Explorer Interceptor", "vmenu:getGarage", {"police3"}, "Get this car")
				VMenu.AddFunc(7, "Police Explorer", "vmenu:getGarage", {"police5"}, "Get this car")
			end
		else
			VMenu.AddSep(7, "You are not on duty")
		end
end

function getLockerPolice()
	VMenu.ResetMenu(5, "", "default")
	VMenu.AddMenu(5, "", "default") -- default = Header "Texte" sur fond bleu
	VMenu.AddFunc(5, "On duty", "vmenu:policeState", {1}, "Being on duty")
	if User.police >= 4 then
		VMenu.AddFunc(5, "Civilian service", "vmenu:policeStateCivil", {1}, "Being in service")
	end
	VMenu.AddFunc(5, "Off duty", "vmenu:policeState", {0}, "Being off duty")
end

function getTankerCompany()
	VMenu.ResetMenu(13, "", "default")
	VMenu.AddMenu(13, "", "default")
	VMenu.AddFunc(13, "Tank", "transporter:optionMission", {0}, "Choose")
end

function getContainerCompany()
	VMenu.ResetMenu(13, "", "default")
	VMenu.AddMenu(13, "", "default")
	VMenu.AddFunc(13, "Container", "transporter:optionMission", {1}, "Choose")
end

function getFrigorifiqueCompany()
	VMenu.ResetMenu(13, "", "default")
	VMenu.AddMenu(13, "", "default")
	VMenu.AddFunc(13, "Refrigerated", "transporter:optionMission", {2}, "Choose")
end

function getLogCompany()
	VMenu.ResetMenu(13, "", "default")
	VMenu.AddMenu(13, "", "default")
	VMenu.AddFunc(13, "Wood", "transporter:optionMission", {3}, "Choose")
end

-------------------------------------------------------------
-------------------------- BOUCLE ---------------------------
-------------------------------------------------------------


local talkingTarget = -1
local timerTarget = 0

Citizen.CreateThread(function()
	if VMenu.checkUser then
		local trig = GetGameTimer()
		while not User.Loaded do
			if GetGameTimer() - trig > 5000 then
				playerSpawned()
				trig = GetGameTimer() + 30000
			end
			Wait(500)
		end
	end
	Construct() -- Construction du menu
	VMenu.curMenu = VMenu.rootMenu -- Set the start menu from the configuration.

	while true do  ------- Boucle
		Wait(1)
		--[[ -- DEBUG
		if VMenu.debugKeys then
		list_keys()
	end
	]]

	-- Deactivation of keys in game AND Anti Cinematic Camera when closing the menu by car
	if VMenu.visible or (not VMenu.visible and (GetGameTimer() - VMenu.closedTime < 1000)) then
		VMenu.DisableControls()
	end

	if VMenu.visible then
		if talkingTarget ~= -1 then
			VMenu.target = talkingTarget
			talkingTarget = -1
		end

		timerTarget = timerTarget + 1
		if timerTarget >= 1500 then
			VMenu.target = -1
			timerTarget = 0
			if VMenu.police then
				if VMenu.curMenu == 98 then
					TriggerEvent("vmenu:closeMenu")
					VMenu.notif("You no longer have a target")
				end
			end
		end

		if VOpts.toUpdate ~= nil then -- Ne Pas Toucher


			--------------------------------------------------- EDITION A PARTIR D'ICI ---------------------------------------------------



			------------ Options Toggle : Changement des options depuis le menu.

			if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))

				-- Engine
				if VOpts.toUpdate == "Engine" then
					SetVehicleEngineOn(veh, getOpt("Engine"), false)
					SetVehicleUndriveable(veh, not getOpt("Engine"))
				end

				-- Colors
				if VOpts.toUpdate == "VehColor" or VOpts.toUpdate == "VehColorS" then
					SetVehicleColours(veh, getOpt("VehColor"), getOpt("VehColorS"))
				end
			end

			if VOpts.toUpdate == "EscortM" then
				if PEscorthandCuffed or PhandCuffed then
					local pname = GetPlayerName(PlayerId())
					PhandCuffed = not PhandCuffed
					PEscorthandCuffed = not PEscorthandCuffed
					--TriggerServerEvent("menupolice:escortcuff_s", GetPlayerServerId(VMenu.target), pname)
					TriggerEvent("menupolice:wescortcuff", VMenu.target)
				else
					TriggerEvent("es_freeroam:notif", "No civilian nearby handcuffed")
				end

			end

			if VOpts.toUpdate == "Handcuff" then
				if getOpt("Handcuff") then
					PhandCuffed = true
					TriggerServerEvent("menupolice:cuff_s", GetPlayerServerId(VMenu.target))
					TriggerEvent("menupolice:wcuff", VMenu.target)
				else
					PhandCuffed = false
					TriggerServerEvent("menupolice:uncuff_s", GetPlayerServerId(VMenu.target))
					TriggerEvent("menupolice:wuncuff", VMenu.target)
				end
			end

			if VMenu.police then
				if VOpts.toUpdate == "Amcon" then
					VMenu.EditFunc(98, "Donate contravention", "menupolice:givecon", {getOpt("Amcon")}, "Access")
				end
			end

			if VMenu.outfitshop then
				if VOpts.toUpdate == "Outfits" then
					local u = getOpt("Outfits")+1
					VMenu.EditSep(8, OutfitsCat[u])
					VMenu.EditFunc(8, "Validate Outfits Category", "vmenu:OutfitsValidate", {getOpt("Outfits")}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo1" then
					getOutfitsMenu(108, getOpt("OutfitsNo1"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo1"), 108}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo2" then
					getOutfitsMenu(109, getOpt("OutfitsNo2"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo2"), 109}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo3" then
					getOutfitsMenu(110, getOpt("OutfitsNo3"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo3"), 110}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo4" then
					getOutfitsMenu(111, getOpt("OutfitsNo4"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo4"), 111}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo5" then
					getOutfitsMenu(112, getOpt("OutfitsNo5"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo5"), 112}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo6" then
					getOutfitsMenu(113, getOpt("OutfitsNo6"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo6"), 113}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo7" then
					getOutfitsMenu(114, getOpt("OutfitsNo7"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo7"), 114}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo8" then
					getOutfitsMenu(115, getOpt("OutfitsNo8"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo8"), 115}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo9" then
					getOutfitsMenu(116, getOpt("OutfitsNo9"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo9"), 116}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo10" then
					getOutfitsMenu(117, getOpt("OutfitsNo10"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo10"), 117}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo11" then
					getOutfitsMenu(118, getOpt("OutfitsNo11"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo11"), 118}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo12" then
					getOutfitsMenu(119, getOpt("OutfitsNo12"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo12"), 119}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo13" then
					getOutfitsMenu(120, getOpt("OutfitsNo13"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo13"), 120}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo14" then
					getOutfitsMenu(121, getOpt("OutfitsNo14"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo14"), 121}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo15" then
					getOutfitsMenu(122, getOpt("OutfitsNo15"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo15"), 122}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo16" then
					getOutfitsMenu(123, getOpt("OutfitsNo16"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo16"), 123}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo17" then
					getOutfitsMenu(124, getOpt("OutfitsNo17"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo17"), 124}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo18" then
					getOutfitsMenu(125, getOpt("OutfitsNo18"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo18"), 125}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo19" then
					getOutfitsMenu(126, getOpt("OutfitsNo19"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo19"), 126}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo20" then
					getOutfitsMenu(127, getOpt("OutfitsNo20"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo20"), 127}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo21" then
					getOutfitsMenu(128, getOpt("OutfitsNo21"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo21"), 128}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo22" then
					getOutfitsMenu(129, getOpt("OutfitsNo22"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo22"), 129}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo23" then
					getOutfitsMenu(130, getOpt("OutfitsNo23"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo23"), 130}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo24" then
					getOutfitsMenu(131, getOpt("OutfitsNo24"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo24"), 131}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo25" then
					getOutfitsMenu(132, getOpt("OutfitsNo25"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo25"), 132}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo26" then
					getOutfitsMenu(133, getOpt("OutfitsNo26"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo26"), 133}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo27" then
					getOutfitsMenu(134, getOpt("OutfitsNo27"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo27"), 134}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo28" then
					getOutfitsMenu(135, getOpt("OutfitsNo28"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo28"), 135}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo29" then
					getOutfitsMenu(136, getOpt("OutfitsNo29"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo29"), 136}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo30" then
					getOutfitsMenu(137, getOpt("OutfitsNo30"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo30"), 137}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo31" then
					getOutfitsMenu(138, getOpt("OutfitsNo31"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo31"), 138}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo32" then
					getOutfitsMenu(139, getOpt("OutfitsNo32"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo32"), 139}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo33" then
					getOutfitsMenu(140, getOpt("OutfitsNo33"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo33"), 140}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo34" then
					getOutfitsMenu(141, getOpt("OutfitsNo34"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo34"), 141}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo35" then
					getOutfitsMenu(142, getOpt("OutfitsNo35"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo35"), 142}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo36" then
					getOutfitsMenu(143, getOpt("OutfitsNo36"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo36"), 143}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo37" then
					getOutfitsMenu(144, getOpt("OutfitsNo37"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo37"), 144}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo38" then
					getOutfitsMenu(145, getOpt("OutfitsNo38"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo38"), 145}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo39" then
					getOutfitsMenu(146, getOpt("OutfitsNo39"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo39"), 146}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo40" then
					getOutfitsMenu(147, getOpt("OutfitsNo40"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo40"), 147}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo41" then
					getOutfitsMenu(148, getOpt("OutfitsNo41"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo41"), 148}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo42" then
					getOutfitsMenu(149, getOpt("OutfitsNo42"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo42"), 149}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo43" then
					getOutfitsMenu(150, getOpt("OutfitsNo43"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo43"), 150}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo44" then
					getOutfitsMenu(151, getOpt("OutfitsNo44"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo44"), 151}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo45" then
					getOutfitsMenu(152, getOpt("OutfitsNo45"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo45"), 152}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo46" then
					getOutfitsMenu(153, getOpt("OutfitsNo46"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo46"), 153}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo47" then
					getOutfitsMenu(154, getOpt("OutfitsNo47"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo47"), 154}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo48" then
					getOutfitsMenu(155, getOpt("OutfitsNo48"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo48"), 155}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo49" then
					getOutfitsMenu(156, getOpt("OutfitsNo49"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo49"), 156}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo50" then
					getOutfitsMenu(157, getOpt("OutfitsNo50"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo50"), 157}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo51" then
					getOutfitsMenu(158, getOpt("OutfitsNo51"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo51"), 158}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo52" then
					getOutfitsMenu(159, getOpt("OutfitsNo52"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo52"), 159}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo53" then
					getOutfitsMenu(160, getOpt("OutfitsNo53"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo53"), 160}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo54" then
					getOutfitsMenu(161, getOpt("OutfitsNo54"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo54"), 161}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo55" then
					getOutfitsMenu(162, getOpt("OutfitsNo55"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo55"), 162}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo56" then
					getOutfitsMenu(163, getOpt("OutfitsNo56"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo56"), 163}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo57" then
					getOutfitsMenu(164, getOpt("OutfitsNo57"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo57"), 164}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo58" then
					getOutfitsMenu(165, getOpt("OutfitsNo58"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo58"), 165}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo59" then
					getOutfitsMenu(166, getOpt("OutfitsNo59"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo59"), 166}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo60" then
					getOutfitsMenu(167, getOpt("OutfitsNo60"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo60"), 167}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo61" then
					getOutfitsMenu(168, getOpt("OutfitsNo61"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo61"), 168}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo62" then
					getOutfitsMenu(169, getOpt("OutfitsNo62"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo62"), 169}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo63" then
					getOutfitsMenu(170, getOpt("OutfitsNo63"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo63"), 170}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo64" then
					getOutfitsMenu(171, getOpt("OutfitsNo64"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo64"), 171}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo65" then
					getOutfitsMenu(172, getOpt("OutfitsNo65"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo65"), 172}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo66" then
					getOutfitsMenu(173, getOpt("OutfitsNo66"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo66"), 173}, "Validate")
				end
				if VOpts.toUpdate == "OutfitsNo67" then
					getOutfitsMenu(174, getOpt("OutfitsNo67"))
					VMenu.EditFunc(8, "Validate your outfit", "vmenu:OutfitsVal", {getOpt("OutfitsNo67"), 174}, "Validate")
				end
			end

			if VMenu.barbershop then
				if VOpts.toUpdate == "Hair" or VOpts.toUpdate == "HairColor" then
					SetPedComponentVariation(GetPlayerPed(-1), 2, getOpt("Hair"), getOpt("HairColor"), 2)
					VMenu.EditFunc(9, "Validate", "vmenu:getclientHair", {getOpt("Hair"),getOpt("HairColor")}, "Get this outfit")
				end
				if VOpts.toUpdate == "Hair" then
					if (getOpt("Hair") == 1) or (getOpt("Hair") == 2) or (getOpt("Hair") == 3) or (getOpt("Hair") == 5) or (getOpt("Hair") == 6) or (getOpt("Hair") == 10) or (getOpt("Hair") == 11) or (getOpt("Hair") == 13) or (getOpt("Hair") == 15) then
						VMenu.EditNum(9, "Color", "HairColor", 0, 5, "Change hair color")
					elseif (getOpt("Hair") == 4) or (getOpt("Hair") == 7) or (getOpt("Hair") == 9) then
						VMenu.EditNum(9, "Color", "HairColor", 0, 6, "Change hair color")
					else
						VMenu.EditNum(9, "Color", "HairColor", 0, 4, "Change hair color")
					end
				end
			end

			if VMenu.hospital then
				if VOpts.toUpdate == "Sex" then
					local model = nil
					if getOpt("Sex") == 0 then
						model = GetHashKey("mp_m_freemode_01")
					else
						model = GetHashKey("mp_f_freemode_01")
					end

					if model ~= nil then
						TriggerServerEvent("vmenu:lastCharInShop", model)
					end
					VMenu.EditFunc(10, "Validate", "vmenu:getclientFace", {getOpt("Sexe"),getOpt("Face"),0}, "Get this change")
				elseif VOpts.toUpdate == "Face" or VOpts.toUpdate == "Face_text" then
					-- local id = getOpt("Face")
					SetPedHeadBlendData(GetPlayerPed(-1), getOpt("Face"), getOpt("Face"), getOpt("Face"), getOpt("Face"), getOpt("Face"), getOpt("Face"), 1.0, 1.0, 1.0, true)
					-- La barbe bientôt
					--SetPedHeadOverlay(playerPed,  1,  Character['beard_1'],  (Character['beard_2'] / 10) + 0.0)    -- Beard
					--SetPedHeadOverlayColor(playerPed,  1,  1,  Character['beard_3'],  Character['beard_4'])        -- Beard Color
					SetPedComponentVariation(GetPlayerPed(-1), 0, getOpt("Face"), 0, 2)
					VMenu.EditFunc(10, "Validate", "vmenu:getclientFace", {getOpt("Sex"),getOpt("Face"),0}, "Get this change")
				end
			end

			if VMenu.Tanker_company then

			end

			if VMenu.Container_company then

			end

			if VMenu.Frigorifique_company then

			end

			if VMenu.Log_company then

			end


			-- Ne Pas Toucher
			VOpts.toUpdate = nil
		end


		------------ Options Toggle : Récupération des valeurs pour les placer dans le menu. (Uniquement si besoin des valeurs en temps réel)

		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			---- En voiture
			local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))

			if VOpts.LastVeh ~= veh then -- Autre Véhicule ?
				VOpts.LastVeh = veh

				-- Mise à jour des couleurs
				local cp, cs = GetVehicleColours(veh)
				setOpt("VehColor", cp)
				setOpt("VehColorS", cs)

			end

			-- Engine
			setOpt("Engine", IsVehicleEngineOn(veh))
		end

		---- Hors de voiture

		if (IsNearPoints(LockerPolice, 4.5) == true) then
			VMenu.lockerpolice = true
		elseif (IsNearPoints(Armory, 2) == true) then

		elseif (IsNearPoints(informateur, 3) == true) then

		elseif (IsNearPoints(lavage_argent, 3) == true) then

		elseif (IsNearPoints(changeYourJob, 3) == true) then

		elseif (IsNearPoints(Tanker_company, 3) == true) then
			VMenu.Tanker_company = true
		elseif (IsNearPoints(Container_company, 3) == true) then
			VMenu.Container_company = true
		elseif (IsNearPoints(Frigorifique_company, 3) == true) then
			VMenu.Frigorifique_company = true
		elseif (IsNearPoints(Log_company, 3) == true) then
			VMenu.Log_company = true
		elseif (IsNearPoints(Garage_police, 5) == true) then
			VMenu.garagepolice = true
		elseif (IsNearPoints(OutfitsShop, 4) == true) then
			VMenu.outfitshop = true
		elseif (IsNearPoints(BarberShop, 4) == true) then
			VMenu.barbershop = true
		elseif (IsNearPoints(Hospital, 4) == true) then
			VMenu.hospital = true
		elseif (IsNearPoints(Store, 4) == true) then
			VMenu.store = true
		else
			if VMenu.curMenu ~= 98 then
				TriggerEvent("vmenu:toggleMenu")
			end
		end

		if IsControlPressed(0, 322) then

		end
		-------------------------------- FIN EDITION ---------------------------------

		-- elseif VMenu.voiceTarget then
		--       for i = 0,64 do
		--           if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(GetPlayerPed(i))) < 3.0001) then
		--           	if NetworkIsPlayerTalking(i) then
		--                 	talkingTarget = i
		--                 	break
		--                 end
		--           end
		--       end
	else

		for i = 0,31 do
			if NetworkIsPlayerConnected(i) then
				if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= nil then
					if GetPlayerServerId(i) ~= GetPlayerServerId(PlayerId()) then
						if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(GetPlayerPed(i))) < 2.5001) then
							talkingTarget = i

							break
						end
						talkingTarget = -1
					end
				end
			end
		end

		if HandCuffed == true then
			Citizen.Trace("Disabled")
			Wait(1000)
			VMenu.DisableControlsHandCuffed()
		end

		-- if IsControlPressed(0, 167) then
		-- 	Wait(100)
		-- 	local player = GetPlayerPed(-1)
		-- 	local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		-- 	SetVehicleLivery(v, 3)
		-- 	VMenu.notif(tostring(livery))
		-- 	livery = livery + 1
		-- end

		if IsControlPressed(0, VMenu.mopenKey) then
			timerTarget = 0
			VMenu.curItem = 1
			--TriggerEvent("vmenu:anim", "cellphone@", "text_in")
			TriggerEvent("vmenu:animChain", "cellphone@", "text_in", "cellphone@", "f_cellphone_text_read_base", "cellphone@", "cellphone_text_out")
			TriggerEvent("vmenu:openMenu", 98)

			VMenu.mainMenu = true
			-- 	TriggerServerEvent("vmenu:updateUser", true)
			if VMenu.police == false and VMenu.telephone == false and VMenu.animations == false then
				getMainMenu()
			end
			Wait(100)
		end

		if IsControlPressed(0, VMenu.openKey) then
			VMenu.curItem = 1
			if (IsNearPoints(LockerPolice, 4.5) == true and User.police >= 1)  then
				TriggerEvent("vmenu:openMenu", 5)
				if VMenu.lockerpolice == false then
					getLockerPolice()
				end
			elseif (IsNearPoints(Armory, 2) == true and User.police >= 1) then
				TriggerEvent("vmenu:openMenu", 6)
			elseif (IsNearPoints(Garage_police, 4) == true and User.police >= 1) then
				TriggerEvent("vmenu:openMenu", 7)
				if VMenu.garagepolice == false then
					getGaragePolice()
				end
			elseif (IsNearPoints(Tanker_company, 3) == true) then
				if User.job == 7 then
					TriggerEvent("vmenu:openMenu", 13)
					if VMenu.TankerCompany == false then
						getTankerCompany()
					end
				else
					ShowMsgtime.msg = '~r~ You must be a tanker !'
					ShowMsgtime.time = 150
				end
			elseif (IsNearPoints(Container_company, 3) == true) then
				if User.job == 8 then
					TriggerEvent("vmenu:openMenu", 13)
					if VMenu.ContainerCompany == false then
						getContainerCompany()
					end
				else
					ShowMsgtime.msg = '~r~ You must be a container deliverer !'
					ShowMsgtime.time = 150
				end
			elseif (IsNearPoints(Frigorifique_company, 3) == true) then
				if User.job == 9 then
					TriggerEvent("vmenu:openMenu", 13)
					if VMenu.FrigorifiqueCompany == false then
						getFrigorifiqueCompany()
					end
				else
					ShowMsgtime.msg = '~r~ You must be a medication deliverer !'
					ShowMsgtime.time = 150
				end
			elseif (IsNearPoints(Log_company, 3) == true) then
				if User.job == 6 then
					TriggerEvent("vmenu:openMenu", 13)
					if VMenu.LogCompany == false then
						getLogCompany()
					end
				else
					ShowMsgtime.msg = '~r~ You must be a wood deliverer !'
					ShowMsgtime.time = 150
				end
			elseif (IsNearPoints(OutfitsShop, 4) == true) then
				VMenu.updatedChar = false
				TriggerEvent("vmenu:openMenu", 8)
			elseif (IsNearPoints(BarberShop, 4) == true) then
				VMenu.updatedChar = false
				TriggerEvent("vmenu:openMenu", 9)
			elseif (IsNearPoints(Hospital, 4) == true) then
				VMenu.updatedChar = false
				TriggerEvent("vmenu:openMenu", 10)
			elseif (IsNearPoints(Store, 4) == true) then
				TriggerEvent("vmenu:openMenu", 11)
			elseif (IsNearPoints(informateur, 3) == true) then
				TriggerEvent("vmenu:openMenu", 14)
			elseif (IsNearPoints(changeYourJob, 3) == true) then
				TriggerEvent("vmenu:openMenu", 15)
			elseif (IsNearPoints(lavage_argent, 3) == true) then
				TriggerEvent("vmenu:openMenu", 16)
			else

			end
		end



		if  (IsNearPoints(informateur, 3) == true) then
			VMenu.Info("Press ~g~F6~s~ To speak with the informant", false)
		elseif (IsNearPoints(changeYourJob, 3) == true) then
			VMenu.Info("Press ~g~F6~s~ To access the Employment office", false)
		elseif (IsNearPoints(Tanker_company, 4) == true and User.job == 7) then
			VMenu.TankerCompany = false
			VMenu.Info('Press ~g~F6~s~ to access the delivery company', false)
		elseif (IsNearPoints(Container_company, 4) == true and User.job == 8) then
			VMenu.ContainerCompany = false
			VMenu.Info('Press ~g~F6~s~ to access the delivery company', false)
		elseif (IsNearPoints(Frigorifique_company, 4) == true and User.job == 9) then
			VMenu.FrigorifiqueCompany = false
			VMenu.Info('Press ~g~F6~s~ to access the delivery company', false)
		elseif (IsNearPoints(Log_company, 4) == true and User.job == 6) then
			VMenu.LogCompany = false
			VMenu.Info('Press ~g~F6~s~ to access the delivery company', false)
		elseif (IsNearPoints(OutfitsShop, 4) == true) then
			VMenu.outfitshop = false
			VMenu.Info('Press ~g~F6~s~ to access the shop', false)
		elseif (IsNearPoints(BarberShop, 4) == true) then
			VMenu.barbershop = false
			VMenu.Info('Press ~g~F6~s~ to access the hairdresser', false)
		elseif (IsNearPoints(Hospital, 4) == true) then
			VMenu.hospital = false
			VMenu.Info('Press ~g~F6~s~ to access the menu', false)
		elseif (IsNearPoints(Store, 4) == true) then
			VMenu.store = false
			VMenu.Info('Press ~g~F6~s~ to access the store', false)
		elseif (IsNearPoints(lavage_argent, 3) == true) then
			VMenu.Info('Press ~g~F6~s~ to access the menu', false)
		else
			if (VMenu.updatedChar == false) then
				Wait(1200)
				TriggerServerEvent("vmenu:lastChar")
				Wait(200)
			end
		end
	end
	VMenu.Show()
end
end)


VMenu.test_keys() -- Capture de touches
