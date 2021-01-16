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

module.GetPlayerCoords = function(playerId)
	if playerId then
		if GetPlayerPed(playerId) then
		  return GetEntityCoords(GetPlayerPed(playerId))
		else
			return nil
		end
	else
		return nil
	end
end

module.KickPlayer = function(playerId, reason)
	reason = reason or "You were kicked by a staff member."

	DropPlayer(tostring(playerId), reason)
end

module.BanPlayer = function(playerId, reason)
	reason = reason or "You were banned by a staff member."

	-- @TODO: ban player = kick + ban entry list
	DropPlayer(tostring(playerId), reason)
end