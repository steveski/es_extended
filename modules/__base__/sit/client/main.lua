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

local utils = M('utils')

module.Init()

module.Config = run('data/config.lua', {vector3 = vector3})['Config']

ESX.SetInterval(1, function()
  if not module.Sitting then
    if IsControlJustPressed(0, module.Config.SitKey) and module.NearObject and IsInputDisabled(0) and IsPedOnFoot(PlayerPedId()) and not module.Sitting then
      module.Sit(module.Object)
    end

    if IsControlJustPressed(0, module.Config.LieDownKey) and module.NearObject and IsInputDisabled(0) and IsPedOnFoot(PlayerPedId()) and not module.Sitting then
      if module.Object.type == "bed" then
        module.LieDown(module.Object)
      end
    end
  end

  if module.Sitting then
    if IsControlJustPressed(0, module.Config.GetUpKey) and module.Sitting and IsInputDisabled(0) then
      module.Wakeup()
    end

    if IsControlJustPressed(0, module.Config.SwitchPositionKey) then
      module.SwitchPositions(module.Object)
    end
  end
end)

ESX.SetInterval(1, function()
  if module.Sitting then
    local plyCoords = GetEntityCoords(PlayerPedId())
    if module.Object.type == "chair" then
      utils.ui.draw3DText(plyCoords.x, plyCoords.y, plyCoords.z-0.5, 0, 0, 0, 0, tostring(_U('sit:press_getup')))
    elseif module.Object.type == "bed" then
      utils.ui.draw3DText(plyCoords.x, plyCoords.y, plyCoords.z-1.0, 0, 0, 0, 0, tostring(_U('sit:press_getup_switch')))
    end
  else
    Wait(1000)
  end
end)

ESX.SetInterval(1, function()
  if not module.Sitting then
    local plyCoords = GetEntityCoords(PlayerPedId())
    for _,v in ipairs(module.Config.Interactables) do
      local closestObject = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, module.Config.MaxDistance, GetHashKey(v.object), 0, 0, 0)
      local coordsObject = GetEntityCoords(closestObject)
      local distanceDiff = #(coordsObject - plyCoords)
      if (distanceDiff < 3.0) and closestObject ~= 0 then
        if (distanceDiff < module.Config.MaxDistance) then
          if v.type == "chair" then
            utils.ui.draw3DText(coordsObject.x, coordsObject.y, coordsObject.z, 0, 0, 0, 0, tostring(_U('sit:press_chair')))
          elseif v.type == "bed" then
            utils.ui.draw3DText(coordsObject.x, coordsObject.y, coordsObject.z, 0, 0, 0, 0, tostring(_U('sit:press_bed')))
          end
          module.NearObject = true

          module.Object = {
            name           = closestObject,
            coords         = coordsObject,
            type           = v.type,
            scenario       = v.scenario,
            scenario2      = v.scenario2,
            verticalOffset = v.verticalOffset,
            forwardOffset  = v.forwardOffset,
            leftOffset     = v.leftOffset
          }

        end

        break
      else
        module.NearObject = false
        module.Object     = nil
      end
    end
  else
    Wait(1000)
  end
end)
