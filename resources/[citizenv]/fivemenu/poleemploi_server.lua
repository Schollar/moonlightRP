require "resources/[essential]/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)


function nameJob(id)
  local executed_query = MySQL:executeQuery("SELECT * FROM jobs WHERE job_id = '@namejob'", {['@namejob'] = id})
  local result = MySQL:getResults(executed_query, {'job_name'}, "job_id")
  return result[1].job_name
end

jobsname = {"Unemployed", "Swimming pool cleaner", "Dustman", "Miner", "Taxi Driver", "Woodworker", "Tanker Delivery", "Container shipper", "Delivery of medicines", "Police Officer", "Gravedigger", "Mortuary agent", "EMS" }


function updatejob(player, id)
  local job = id
  MySQL:executeQuery("UPDATE users SET `job`='@value' WHERE identifier = '@identifier'", {['@value'] = job, ['@identifier'] = player})
end

RegisterServerEvent('poleemploi:jobs')
AddEventHandler('poleemploi:jobs', function(id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local nameJob = jobsname[id]
        updatejob(player, id)
        user:setJob(id)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_AMANDA", 1, "Town hall", false, "Your job is now : ".. nameJob)
  end)
end)

RegisterServerEvent('poleemploi:getjobs')
AddEventHandler('poleemploi:getjobs', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
        TriggerClientEvent("mine:getJobs", source, user:getJob())
  end)
end)
