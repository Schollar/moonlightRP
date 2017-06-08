----------------------------------------------------
--===================Aurelien=====================--
----------------------------------------------------
------------------------Lua-------------------------

local DrawMarkerShow = true
local DrawBlipTradeShow = true

-- -900.0, -3002.0, 13.0
-- -800.0, -3002.0, 13.0
-- -1078.0, -3002.0, 13.0

local Price = 1500

local Position = {
  -- VOS POINTS ICI
    Recolet={x=0.0,y=0.0,z=0.0, distance=10},
    traitement={x=0.0,y=0.0,z=0.0, distance=10},
    traitement2={x=0.0,y=0.0,z=0.0, distance=10},
    vente={x=0.0,y=0.0,z=0.0, distance=10},
    vente2={x=0.0,y=0.0,z=0.0, distance=10},
}

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
  DrawText(x, y)
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

local ShowMsgtime = { msg = "", time = 0 }
local weedcount = 0

AddEventHandler("tradeill:cbgetQuantity", function(itemQty)
  weedcount = itemQty
end)

Citizen.CreateThread(function()
    while true do
                    Citizen.Wait(0)
      if ShowMsgtime.time ~= 0 then
        drawTxt(ShowMsgtime.msg, 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
        ShowMsgtime.time = ShowMsgtime.time - 1
      end
    end
end)

Citizen.CreateThread(function()

    if DrawBlipTradeShow then
        --SetBlipTrade(140, "~g~ Ceuillette ~b~Feuille de coka", 2, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z)
        --SetBlipTrade(50, "~g~ Traitement ~b~Feuille de coka", 1, Position.traitement.x, Position.traitement.y, Position.traitement.z)
        --SetBlipTrade(50, "~g~ Traitement ~b~Feuille de coka", 1, Position.traitement2.x, Position.traitement2.y, Position.traitement2.z)
        --SetBlipTrade(277, "~g~ Vendre ~b~Coke", 1, Position.vente.x, Position.vente.y, Position.vente.z)
        --SetBlipTrade(277, "~g~ Vendre ~b~Coke", 1, Position.vente2.x, Position.vente2.y, Position.vente2.z)
    end

    while true do
                    Citizen.Wait(0)
       if DrawMarkerShow then
          DrawMarker(1, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
          DrawMarker(1, Position.traitement.x, Position.traitement.y, Position.traitement.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
          DrawMarker(1, Position.traitement2.x, Position.traitement2.y, Position.traitement2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
          DrawMarker(1, Position.vente.x, Position.vente.y, Position.vente.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
          DrawMarker(1, Position.vente2.x, Position.vente2.y, Position.vente2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
       end
    end
end)

Citizen.CreateThread(function()
    while true do
                    Citizen.Wait(0)
        local playerPos = GetEntityCoords(GetPlayerPed(-1))

        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.Recolet.distance then
             ShowInfo('~b~Press ~g~E~b~ to pick', 0)
             if IsControlJustPressed(1, 38) then
                   weedcount = 0
                   -- TriggerEvent("player:getQuantity", 4, function(data)
                   --     weedcount = data.count
                   -- end)
                  TriggerEvent("player:getQuantity", 6)
                  Wait(100)
                  Citizen.Wait(1)
                  if weedcount < 30 then
                          ShowMsgtime.msg = '~g~ Pick ~b~Coke sheet'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ + 1 ~b~Coke sheet'
                          ShowMsgtime.time = 150
                          TriggerEvent("player:receiveItem", 6, 1)
                  else
                          ShowMsgtime.msg = '~r~ Inventory full !'
                          ShowMsgtime.time = 150
                  end
             end
          end
        end
-------------------------Bloc Pour rajouter un traitement-------------------------------------------
        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.traitement.x, Position.traitement.y, Position.traitement.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.traitement.distance then
             ShowInfo('~b~Press ~g~E~b~ to treat your ~b~Coke sheets', 0)
             if IsControlJustPressed(1, 38) then
                   weedcount = 0
                   -- TriggerEvent("player:getQuantity", 6, function(data)
                   --      weedcount = data.count
                   -- end)
                  TriggerEvent("player:getQuantity", 6)
                  Wait(100)
                  if weedcount ~= 0 then
                          ShowMsgtime.msg = '~g~ Treatment of ~b~coke sheets'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ + 1 ~b~Processed coke sheet 50%'
                          ShowMsgtime.time = 150

                          TriggerEvent("player:looseItem", 6, 1)
                          TriggerEvent("player:receiveItem", 7, 1)
                  else
                          ShowMsgtime.msg = "~r~ You do not have coke sheets !"
                          ShowMsgtime.time = 150
                  end
             end
           end
        end

		local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.traitement2.x, Position.traitement2.y, Position.traitement2.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.traitement2.distance then
             ShowInfo('~b~Press ~g~E~b~ to treat ~b~coke sheets', 0)
             if IsControlJustPressed(1, 38) then
                   weedcount = 0
                   -- TriggerEvent("player:getQuantity", 6, function(data)
                   --      weedcount = data.count
                   -- end)
                  TriggerEvent("player:getQuantity", 7)
                  Wait(100)
                  if weedcount ~= 0 then
                          ShowMsgtime.msg = '~g~ Treatment of ~b~Treated coke sheets'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ + 1 ~b~Coke'
                          ShowMsgtime.time = 150

                          TriggerEvent("player:looseItem", 7, 1)
                          TriggerEvent("player:receiveItem", 8, 1)
                  else
                          ShowMsgtime.msg = "~r~ You do not have 50% coke sheets processed !"
                          ShowMsgtime.time = 150
                  end
             end
           end
        end
-------------------------Fin Du Bloc Pour rajouter un traitement-------------------------------------------
        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.vente2.x, Position.vente2.y, Position.vente2.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.vente2.distance then
             ShowInfo('~b~ Press ~g~E~b~ to sell', 0)
             if IsControlJustPressed(1, 38) then
                   weedcount = 0
                   -- TriggerEvent("player:getQuantity", 7, function(data)
                   --         weedcount = data.count
                   -- end)
                  TriggerEvent("player:getQuantity", 8)
                  Wait(100)
                  if weedcount ~= 0 then
                          ShowMsgtime.msg = '~g~ Sell ~b~Coke'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ +'..Price..'$'
                          ShowMsgtime.time = 150
                          TriggerEvent("player:sellItem", 8, Price)
                  else
                          ShowMsgtime.msg = '~r~ You have no coke !'
                          ShowMsgtime.time = 150
                  end
             end
           end
        end

        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.vente.x, Position.vente.y, Position.vente.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.vente.distance then
             ShowInfo('~b~ Press ~g~E~b~ to sell', 0)
             if IsControlJustPressed(1, 38) then
                   weedcount = 0
                   -- TriggerEvent("player:getQuantity", 7, function(data)
                   --         weedcount = data.count
                   -- end)
                  TriggerEvent("player:getQuantity", 8)
                  Wait(100)
                  if weedcount ~= 0 then
                          ShowMsgtime.msg = '~g~ Sell ~b~Coke'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ +'..Price..'$'
                          ShowMsgtime.time = 150
                          TriggerEvent("player:sellItem", 8, Price)
                  else
                          ShowMsgtime.msg = '~r~ You have no coke !'
                          ShowMsgtime.time = 150
                  end
             end
           end
        end
    end
end)

function SetBlipTrade(id, text, color, x, y, z)
    local Blip = AddBlipForCoord(x, y, z)

    SetBlipSprite(Blip, id)
    SetBlipColour(Blip, color)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)
end
