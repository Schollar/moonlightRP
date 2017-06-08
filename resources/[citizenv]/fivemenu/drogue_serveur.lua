local coke = {
  [1] = {["name"] = "Coke Fields",["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["cost"] = 5000},
  [2] = {["name"] = "Coke treatment # 1",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [3] = {["name"] = "Coke treatment # 2",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [4] = {["name"] = "Coke sale # 1",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [5] = {["name"] = "Coke sale # 2",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000}
}

local meth = {
  [1] = {["name"] = "Meth Feilds",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [2] = {["name"] = "Meth Treatment #1",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [3] = {["name"] = "Meth Treatment #2",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [4] = {["name"] = "Meth Treatment #3",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [5] = {["name"] = "Meth Sale",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000}
}

local organe = {
    [1] = {["name"] = "Organ Harvesting",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
    [2] = {["name"] = "Organ Packing",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
    [3] = {["name"] = "Identification of organs",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
    [4] = {["name"] = "Organ Sale",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
}

local weed = {
  [1] = {["name"] = "Weed Feilds",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [2] = {["name"] = "Weed Treatment",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
  [3] = {["name"] = "Weed Sale",["x"] = 0.0 , ["y"] = 0.0 , ["z"] = 0.0 , ["cost"] = 5000},
}
--asd
RegisterServerEvent("menudrogue:sendData_s")
AddEventHandler("menudrogue:sendData_s", function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    TriggerClientEvent("menudrogue:f_sendData", source, coke, meth, organe, weed)
  end)
end)

RegisterServerEvent("menudrogue:getCash_s")
AddEventHandler("menudrogue:getCash_s", function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local lecashy = user:getMoney()
    TriggerClientEvent("menudrogue:f_getCash", source, lecashy)
  end)
end)

RegisterServerEvent("menudrogue:setCash")
AddEventHandler("menudrogue:setCash", function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    user:removeMoney(amount)
  end)
end)
