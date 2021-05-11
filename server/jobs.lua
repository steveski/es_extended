------------------------------------------------
-- Tracking job counts currently on the server
------------------------------------------------
ESX.JobPlayers = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	ESX.JobPlayers[xPlayer.job.name][xPlayer.identifier] = true
--print(json.encode(ESX.JobPlayers))
end)

RegisterNetEvent('esx:playerDropped')
AddEventHandler('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
	
	ESX.JobPlayers[xPlayer.job.name][xPlayer.identifier] = nil
--print(json.encode(ESX.JobPlayers))
end)

RegisterNetEvent('esx:playerSwitchJob')
AddEventHandler('esx:playerSwitchJob', function(identifier, old, new)
	ESX.JobPlayers[old][identifier] = nil
	ESX.JobPlayers[new][identifier] = true
--print(json.encode(ESX.JobPlayers[old]))
--print(json.encode(ESX.JobPlayers[new]))
end)

-- Efficient way to get the count of players assigned to a job
function GetJobCount(job)
	local playersInJob = ESX.JobPlayers[job]

	local count = 0
	for k,v in pairs(playersInJob) do
		count = count + 1
	end
		
	return count
end
exports('GetJobCount', GetJobCount)

-- Setup an in memory data structure to track player identifiers assigned to jobs
MySQL.ready(function()
	-- Get all the available job names
	MySQL.Async.fetchAll('SELECT name FROM jobs',
	{},
	function(results)
		for i=1, #results, 1 do
			-- Initialise an empty placeholder table to contain player identifiers for the current job
			ESX.JobPlayers[results[i].name] = {}
		end

	end)

end)

RegisterCommand('jobcount', function(source, args, rawCommand)
	print(args[1] .. ' count: ' .. GetJobCount(args[1]))
end, true)

RegisterCommand('dumpjobs', function(source, args, rawCommand)
	if args[1] == nil then
		print(json.encode(ESX.JobPlayers))
	else
		print(json.encode(ESX.JobPlayers[args[1]]))
	end
end, true)

