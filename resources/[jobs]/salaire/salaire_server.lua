-- Loading MySQL Class
require "resources/[essential]/essentialmode/lib/MySQL"
MySQL:open("158.69.240.178", "db8012", "db8012", "6W3710Y6kA")

RegisterServerEvent('paycheck:salary')
AddEventHandler('paycheck:salary', function()
	 local salary = 150 --AIDE DE L ETAT (RP: Le président peut decider de les changer)
   TriggerEvent('es:getPlayerFromId', source, function(user)
  	-- Ajout de l'argent à l'utilisateur
  	local user_id = user.identifier
  	-- Requête qui permet de recuperer le métier de l'utilisateur
  	local executed_query = MySQL:executeQuery("SELECT salary FROM users INNER JOIN jobs ON users.job = jobs.job_id WHERE identifier = '@username'",{['@username'] = user_id})
    local result = MySQL:getResults(executed_query, {'salary'})
    local salary_job = tonumber(result[1].salary)
    if salary_job > 0 then
          user:addMoney((salary + salary_job))
   	  TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "State Assistance :  + "..salary.."~g~$~s~~n~Salary received : + "..salary_job.." ~g~$")
    end
 	end)
end)
