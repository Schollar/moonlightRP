local TruckerIndex = 0
local MissionTruckerIndex = 0

AddEventHandler("vmenu:TransportOG", function(target, index)
  local index = index
  VMenu.ResetMenu(13, "Delivery", "default")
  VMenu.AddMenu(13, "Delivery", "default")
  if index == 0 then
    VMenu.AddFunc(13, "Tank", "transporter:optionMission", {0}, "Choose")
  elseif index == 1 then
    VMenu.AddFunc(13, "Container", "transporter:optionMission", {1}, "Choose")
  elseif index == 2 then
    VMenu.AddFunc(13, "Refrigerated", "transporter:optionMission", {2}, "Choose")
  elseif index == 3 then
    VMenu.AddFunc(13, "Wood", "transporter:optionMission", {3}, "Choose")
  end
end)

AddEventHandler("transporter:optionMission", function(target, index)
  local index = index
  TruckerIndex = index
  TriggerEvent("transporter:optionMisson2", TruckerIndex)
  VMenu.ResetMenu(13, "Delivery", "default")
  VMenu.AddMenu(13, "Delivery", "default")
  VMenu.AddFunc(13, "Return", "vmenu:TransportOG", {TruckerIndex}, "Return")
  VMenu.AddFunc(13, "Destination #1", "transporter:mission", {0}, "Choose")
  VMenu.AddFunc(13, "Destination #2", "transporter:mission", {1}, "Choose")
  VMenu.AddFunc(13, "Destination #3", "transporter:mission", {2}, "Choose")
  VMenu.AddFunc(13, "Destination #4", "transporter:mission", {3}, "Choose")
  if index == 2 then
    VMenu.AddFunc(13, "Destination #1", "transporter:mission", {4}, "Choose")
    VMenu.AddFunc(13, "Destination #2", "transporter:mission", {5}, "Choose")
    VMenu.AddFunc(13, "Destination #3", "transporter:mission", {6}, "Choose")
    VMenu.AddFunc(13, "Destination #4", "transporter:mission", {7}, "Choose")
    VMenu.AddFunc(13, "Destination #5", "transporter:mission", {8}, "Choose")
  end
end)

AddEventHandler("transporter:mission", function(target, index)
  local index = index
  MissionTruckerIndex = index
  TriggerEvent("transporter:mission2", MissionTruckerIndex, TruckerIndex)
end)
