-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

local Cache = M("cache")

module.Cache = {}
module.Cache.Statuses, module.Cache.StatusReady, module.Ready = {}, {}, false

module.StatusesCreated = function(requestId)
    for _, playerId in ipairs(GetPlayers()) do
        local player = Player.fromId(playerId)
        if player then
            local identifier = player.identifier
            local id = player:getIdentityId()

            if player and identifier == requestId then
                if not module.Cache.StatusReady[identifier] then
                    if module.Cache.Statuses[identifier] then
                        if module.Cache.Statuses[identifier][id] then
                            if not module.Cache.StatusReady[identifier] then
                                module.Cache.StatusReady[identifier] = {}
                            end

                            if not module.Cache.StatusReady[identifier][id] then
                                module.Cache.StatusReady[identifier][id] = true
                            end

                            emitClient('esx:status:updateStatus', player.source, module.Cache.Statuses[identifier][id])
                        end
                    end
                end
            end
        end
    end
end

module.UpdateStatus = function()
    if Config.Modules.Status.UseDebugging then
      print("----START OF EVENT----")
    end

    for _, playerId in ipairs(GetPlayers()) do
        local player           = Player.fromId(playerId)
        if player then
            local identifier       = player.identifier
            local id               = player:getIdentityId()
            local status           = {}
            local statusLow        = false
            local statusDying      = false
            local statusDrunk      = 0
            local drugName         = "weed"
            local statusDrugs      = 0
            local statusStress     = 0

            if module.Cache.StatusReady[identifier] then
                if module.Cache.StatusReady[identifier][id] then
                    for k,v in pairs(Config.Modules.Status.StatusIndex) do
                        if module.Cache.Statuses[identifier][id][v]["fadeType"] == "desc" then
                            if module.Cache.Statuses[identifier][id][v]["value"] > 0 then
                                module.Cache.Statuses[identifier][id][v]["value"] = module.Cache.Statuses[identifier][id][v]["value"] - 1

                                if module.Cache.Statuses[identifier][id][v]["value"] > 0 and module.Cache.Statuses[identifier][id][v]["value"] <= 10 then
                                    statusLow = true
                                elseif module.Cache.Statuses[identifier][id][v]["value"] == 0 then
                                    statusDying = true
                                end

                                table.insert(status, {k = module.Cache.Statuses[identifier][id][v]["value"]})
                            else
                                module.Cache.Statuses[identifier][id][v]["value"] = 0
                                statusDying = true

                                table.insert(status, {k = module.Cache.Statuses[identifier][id][v]["value"]})
                            end
                        elseif module.Cache.Statuses[identifier][id][v]["fadeType"] == "asc" then
                            if module.Cache.Statuses[identifier][id][v]["value"] > 0 then
                                module.Cache.Statuses[identifier][id][v]["value"] = module.Cache.Statuses[identifier][id][v]["value"] - 1
                                if module.Cache.Statuses[identifier][id][v]["id"] == "drunk" then
                                    statusDrunk = module.Cache.Statuses[identifier][id][v]["value"]
                                elseif module.Cache.Statuses[identifier][id][v]["id"] == "weed" then
                                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                                elseif module.Cache.Statuses[identifier][id][v]["id"] == "cocaine" then
                                    drugName    = "cocaine"
                                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                                elseif module.Cache.Statuses[identifier][id][v]["id"] == "meth" then
                                    drugName    = "meth"
                                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                                elseif module.Cache.Statuses[identifier][id][v]["id"] == "heroin" then
                                    drugName    = "heroin"
                                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                                elseif module.Cache.Statuses[identifier][id][v]["id"] == "stress" then
                                    statusStress = module.Cache.Statuses[identifier][id][v]["value"]
                                end
                                table.insert(status, {k = module.Cache.Statuses[identifier][id][v]["value"]})
                            end
                        end
                    end

                    Cache.UpdateStatus(player.identifier, player:getIdentityId(), Config.Modules.Status.StatusIndex, module.Cache.Statuses[identifier][id])
                    emitClient('esx:status:updateStatus', player.source, module.Cache.Statuses[identifier][id])
                    emitClient('esx:status:statCheck', player.source, statusLow, statusDying, statusDrunk, drugName, statusDrugs, statusStress)
                end
            end
        end
    end
    if Config.Modules.Status.UseDebugging then
      print("----END OF EVENT----")
    end
end

module.SetStatus = function(statusName, value)
    local player           = Player.fromId(source)
    local identifier       = player.identifier
    local id               = player:getIdentityId()
    local status           = {}
    local statusDying      = false
    local statusLow        = false
    local sendStatus       = nil
    local statusDrunk      = 0
    local drugName         = "weed"
    local statusDrugs      = 0
    local statusStress     = 0

    if module.Cache.StatusReady[identifier][id] then
        for k,v in pairs(Config.Modules.Status.StatusIndex) do
            if tostring(module.Cache.Statuses[identifier][id][v]["id"]) == tostring(statusName) then
                module.Cache.Statuses[identifier][id][v]["value"] = value
            end

            if module.Cache.Statuses[identifier][id][v]["fadeType"] == "desc" then
                table.insert(status, {k = module.Cache.Statuses[identifier][id][v]["value"]})

                if module.Cache.Statuses[identifier][id][v]["value"] > 0 and module.Cache.Statuses[identifier][id][v]["value"] <= 10 then
                    statusLow = true
                elseif module.Cache.Statuses[identifier][id][v]["value"] == 0 then
                    statusDying = true
                end
            elseif module.Cache.Statuses[identifier][id][v]["fadeType"] == "asc" then
                table.insert(status, {k = module.Cache.Statuses[identifier][id][v]["value"]})
                if module.Cache.Statuses[identifier][id][v]["id"] == "drunk" then
                    statusDrunk = module.Cache.Statuses[identifier][id][v]["value"]
                elseif module.Cache.Statuses[identifier][id][v]["id"] == "weed" then
                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                elseif module.Cache.Statuses[identifier][id][v]["id"] == "cocaine" then
                    drugName    = "cocaine"
                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                elseif module.Cache.Statuses[identifier][id][v]["id"] == "meth" then
                    drugName    = "meth"
                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                elseif module.Cache.Statuses[identifier][id][v]["id"] == "heroin" then
                    drugName    = "heroin"
                    statusDrugs = module.Cache.Statuses[identifier][id][v]["value"]
                elseif module.Cache.Statuses[identifier][id][v]["id"] == "stress" then
                    statusStress = module.Cache.Statuses[identifier][id][v]["value"]
                end
            end
        end

        Cache.UpdateStatus(player.identifier, player:getIdentityId(), Config.Modules.Status.StatusIndex, module.Cache.Statuses[identifier][id])
        emitClient('esx:status:updateStatus', player.source, module.Cache.Statuses[identifier][id])
        emitClient('esx:status:statCheck', player.source, statusLow, statusDying, statusDrunk, drugName, statusDrugs, statusStress)
    end
end

module.Retry = function(playerId)
    Wait(5000)
    emit('esx:status:initialize', playerId)
end