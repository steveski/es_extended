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

onRequest('esx:identity:register', function(source, cb, data)

  local player = Player.fromId(source)

  local identity = Identity({
    owner     = player.identifier,
    firstName = data.firstName,
    lastName  = data.lastName,
    DOB       = data.dob,
    isMale    = data.isMale
  })

  identity:save(function(id)

    Identity.all[id] = identity

    player:setIdentityId(id)
    player:field('identity', identity)
    player:save()

    cb(id)

  end)

end)

onRequest('esx:cache:identity:get', function(source, cb, id)

  local player = Player.fromId(source)

  local instance = Identity.all[id]

  if instance then

    cb(true, instance:serialize())

  else

    Identity.findOne({id = id}, function(instance)

      if instance == nil then
        cb(false, nil)
      else
        Identity.all[id] = instance
        cb(true, instance:serialize())
      end

    end)

  end

end)

on('esx:player:load', function(player)
  local playerIdentityId = player:getIdentityId()

  if (playerIdentityId ~= nil) then
    Identity.findOne({id = playerIdentityId}, function(instance)
      if instance == nil then
        return
      end

      Identity.all[playerIdentityId] = instance
      player:setIdentityId(playerIdentityId)
      -- TODO: Fix this line, if I uncomment, I have the 90sec svMain loop block or something
      -- maybe call field two time with meta table cause server blocking ? No clue !
      -- player:field('identity', instance)
    end)
  end
end)
