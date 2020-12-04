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

onClient('esx:status:initialize', function()
  local player = Player.fromId(source)
  local identifier = player.identifier
  local id = player:getIdentityId()

	if not module.Cache.Statuses[identifier] then
    module.Cache.Statuses[identifier] = {}
	end

	if not module.Cache.Statuses[identifier][id] then
    module.Cache.Statuses[identifier][id] = {}
	end

	local statuses      = Cache.RetrieveStatuses(player.identifier, player:getIdentityId())
  local config        = Config.Modules.Status.StatusInfo

  local count  = 0
  local count2 = 0

  for k,v in ipairs(Config.Modules.Status.StatusIndex) do
    count = count + 1
  end

  for k,v in ipairs(Config.Modules.Status.StatusIndex) do
    if statuses then
      if statuses[v] then
        if not module.Cache.Statuses[identifier][id][v] then
          module.Cache.Statuses[identifier][id][v] = {}
        end

        if Config.Modules.Status.UseDebugging then
          print("Inserting [\"" .. v .. "\"] = " .. statuses[v] .. " for " .. "[" .. identifier .. "][" .. id .. "]")
        end

        module.Cache.Statuses[identifier][id][v]["id"]       = v
        module.Cache.Statuses[identifier][id][v]["color"]    = config[v].color
        module.Cache.Statuses[identifier][id][v]["value"]    = statuses[v]
        module.Cache.Statuses[identifier][id][v]["icon"]     = config[v].icon
        module.Cache.Statuses[identifier][id][v]["iconType"] = config[v].iconType
        module.Cache.Statuses[identifier][id][v]["fadeType"] = config[v].fadeType

        -- module.CreateStatus(identifier, id, v, config[v].color, config[v].iconType, config[v].icon, statuses[v], config[v].fadeType)
      else
        if not module.Cache.Statuses[identifier][id][v] then
          module.Cache.Statuses[identifier][id][v] = {}
        end

        if Config.Modules.Status.UseDebugging then
          print("Inserting [\"" .. v .. "\"] for " .. "[" .. identifier .. "][" .. id .. "]")
        end

        module.Cache.Statuses[identifier][id][v]["id"]       = v
        module.Cache.Statuses[identifier][id][v]["color"]    = config[v].color
        module.Cache.Statuses[identifier][id][v]["value"]    = Config.Modules.Status.DefaultValues[k]
        module.Cache.Statuses[identifier][id][v]["icon"]     = config[v].icon
        module.Cache.Statuses[identifier][id][v]["iconType"] = config[v].iconType
        module.Cache.Statuses[identifier][id][v]["fadeType"] = config[v].fadeType

        -- module.CreateStatus(identifier, id, v, config[v].color, config[v].iconType, config[v].icon, Config.Modules.Status.DefaultValues[k], config[v].fadeType)
      end
    else
      if not module.Cache.Statuses[identifier][id][v] then
        module.Cache.Statuses[identifier][id][v] = {}
      end

      if Config.Modules.Status.UseDebugging then
        print("Inserting [\"" .. v .. "\"] for " .. "[" .. identifier .. "][" .. id .. "]")
      end

      module.Cache.Statuses[identifier][id][v]["id"]       = v
      module.Cache.Statuses[identifier][id][v]["color"]    = config[v].color
      module.Cache.Statuses[identifier][id][v]["value"]    = Config.Modules.Status.DefaultValues[k]
      module.Cache.Statuses[identifier][id][v]["icon"]     = config[v].icon
      module.Cache.Statuses[identifier][id][v]["iconType"] = config[v].iconType
      module.Cache.Statuses[identifier][id][v]["fadeType"] = config[v].fadeType

      -- module.CreateStatus(identifier, id, v, config[v].color, config[v].iconType, config[v].icon, Config.Modules.Status.DefaultValues[k], config[v].fadeType)
    end

    count2 = count2 + 1

    if count == count2 then
      module.Ready = true
      module.StatusesCreated(identifier)
    end
  end
end)

on('esx:status:initialize', function(playerId)
  local player = Player.fromId(playerId)
  if player then
    local identifier = player.identifier
    local id = player:getIdentityId()

    if identifier and id then

      if not module.Cache.Statuses[identifier] then
        module.Cache.Statuses[identifier] = {}
      end

      if not module.Cache.Statuses[identifier][id] then
        module.Cache.Statuses[identifier][id] = {}
      end

      local statuses      = Cache.RetrieveStatuses(player.identifier, player:getIdentityId())
      local config        = Config.Modules.Status.StatusInfo

      local count  = 0
      local count2 = 0

      for k,v in ipairs(Config.Modules.Status.StatusIndex) do
        count = count + 1
      end

      for k,v in ipairs(Config.Modules.Status.StatusIndex) do
        if statuses then
          if statuses[v] then
            if not module.Cache.Statuses[identifier][id][v] then
              module.Cache.Statuses[identifier][id][v] = {}
            end

            if Config.Modules.Status.UseDebugging then
              print("Inserting [\"" .. v .. "\"] for " .. "[" .. identifier .. "][" .. id .. "]")
            end

            module.Cache.Statuses[identifier][id][v]["id"]       = v
            module.Cache.Statuses[identifier][id][v]["color"]    = config[v].color
            module.Cache.Statuses[identifier][id][v]["value"]    = statuses[v]
            module.Cache.Statuses[identifier][id][v]["icon"]     = config[v].icon
            module.Cache.Statuses[identifier][id][v]["iconType"] = config[v].iconType
            module.Cache.Statuses[identifier][id][v]["fadeType"] = config[v].fadeType
            -- module.CreateStatus(identifier, id, v, config[v].color, config[v].iconType, config[v].icon, statuses[v], config[v].fadeType)
          else
            if not module.Cache.Statuses[identifier][id][v] then
              module.Cache.Statuses[identifier][id][v] = {}
            end

            if Config.Modules.Status.UseDebugging then
              print("Inserting [\"" .. v .. "\"] for " .. "[" .. identifier .. "][" .. id .. "]")
            end

            module.Cache.Statuses[identifier][id][v]["id"]       = v
            module.Cache.Statuses[identifier][id][v]["color"]    = config[v].color
            module.Cache.Statuses[identifier][id][v]["value"]    = Config.Modules.Status.DefaultValues[k]
            module.Cache.Statuses[identifier][id][v]["icon"]     = config[v].icon
            module.Cache.Statuses[identifier][id][v]["iconType"] = config[v].iconType
            module.Cache.Statuses[identifier][id][v]["fadeType"] = config[v].fadeType

            -- module.CreateStatus(identifier, id, v, config[v].color, config[v].iconType, config[v].icon, Config.Modules.Status.DefaultValues[k], config[v].fadeType)
          end
        else
          if not module.Cache.Statuses[identifier][id][v] then
            module.Cache.Statuses[identifier][id][v] = {}
          end

          if Config.Modules.Status.UseDebugging then
            print("Inserting [\"" .. v .. "\"] for " .. "[" .. identifier .. "][" .. id .. "]")
          end

          module.Cache.Statuses[identifier][id][v]["id"]       = v
          module.Cache.Statuses[identifier][id][v]["color"]    = config[v].color
          module.Cache.Statuses[identifier][id][v]["value"]    = Config.Modules.Status.DefaultValues[k]
          module.Cache.Statuses[identifier][id][v]["icon"]     = config[v].icon
          module.Cache.Statuses[identifier][id][v]["iconType"] = config[v].iconType
          module.Cache.Statuses[identifier][id][v]["fadeType"] = config[v].fadeType

          -- module.CreateStatus(identifier, id, v, config[v].color, config[v].iconType, config[v].icon, Config.Modules.Status.DefaultValues[k], config[v].fadeType)
        end

        if count == count2 then
          print("This is the last element")
        end
      end

      module.Ready = true
      module.StatusesCreated()
    else
      module.Retry(playerId)
    end
  else
    module.Retry(playerId)
  end
end)

onClient('esx:status:setStatus', function(statusName, value)
  module.SetStatus(statusName, value)
end)
