require "resources/[essential]/essentialmode/lib/MySQL"

-- MySQL:open("IP", "databasname", "user", "password")
MySQL:open("158.69.240.178", "db8012", "db8012", "6W3710Y6kA")

AddEventHandler('onResourceStart', function(resource)
  MySQL:executeQuery("UPDATE user_vehicle SET `vehicle_state`='@value' WHERE `vehicle_state`='Out'",
  {['@value'] = "Get in"})
end)
