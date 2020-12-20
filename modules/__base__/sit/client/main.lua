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

ESX.SetInterval(200, function()
  module.Coords = GetEntityCoords(PlayerPedId())
end)

ESX.SetInterval(1, function()
  if module.Sitting and module.Coords then
    if module.Object.type == "chair" then
      utils.ui.draw3DText(module.Coords.x, module.Coords.y, module.Coords.z-0.5, 0, 0, 0, 0, tostring(_U('sit:press_getup')))
    elseif module.Object.type == "bed" then
      utils.ui.draw3DText(module.Coords.x, module.Coords.y, module.Coords.z-1.0, 0, 0, 0, 0, tostring(_U('sit:press_getup_switch')))
    end
  else
    Wait(1000)
  end
end)

ESX.SetInterval(500, function()
  if not module.Sitting and module.Coords then
    for _,v in ipairs(module.Config.Interactables) do
      local closestObject = GetClosestObjectOfType(module.Coords.x, module.Coords.y, module.Coords.z, module.Config.MaxDistance, GetHashKey(v.object), 0, 0, 0)
      local coordsObject  = GetEntityCoords(closestObject)
      local distanceDiff  = #(coordsObject - module.Coords)

      if (distanceDiff < module.Config.MaxDistance) then
        if v.type == "chair" then
          if not module.DrawActive then
            module.Draw = {
              x    = coordsObject.x,
              y    = coordsObject.y,
              z    = coordsObject.z,
              text = tostring(_U('sit:press_chair'))
            }

            module.DrawActive = true
          end
        elseif v.type == "bed" then
          if not module.DrawActive then
            module.Draw = {
              x    = coordsObject.x,
              y    = coordsObject.y,
              z    = coordsObject.z,
              text = tostring(_U('sit:press_bed'))
            }

            module.DrawActive = true
          end
        end

        break
      else
        module.DrawActive = false
      end
    end
  end
end)

ESX.SetInterval(1, function()
  if module.DrawActive then
    if module.Draw then
      if module.Draw.x and module.Draw.y and module.Draw.z and module.Draw.text then
        utils.ui.draw3DText(module.Draw.x, module.Draw.y, module.Draw.z, 0, 0, 0, 0, module.Draw.text)
      end
    end
  end
end)
