require('effect_modifiers')


print("testjail0")


function JailTriggered(trigger)
  print("YO")
    -- Get the position of the "point_teleport_spot"-entity we put in our map
    local point =  Entities:FindByName( nil, "point_teleport_spot" ):GetAbsOrigin()
   

    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
      -- Find a spot for the hero around 'point' and teleports to it
      FindClearSpaceForUnit(trigger.activator, point, false)
      -- Stop the hero, so he doesn't move
       trigger.activator:Stop()
      -- Refocus the camera of said player to the position of the teleported hero.
      SendToConsole("dota_camera_center")
    end
end

function OnEndTouch(trigger)

  print(trigger.activator)
  print(trigger.caller)
end


function JailTriggeredDire(trigger)
  print("YAY")
    
    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      -- Get the position of the "point_teleport_spot"-entity we put in our map
      local point =  Entities:FindByName( nil, "point_teleport_spot2" ):GetAbsOrigin()
      -- Find a spot for the hero around 'point' and teleports to it
      FindClearSpaceForUnit(trigger.activator, point, false)
      -- Stop the hero, so he doesn't move
      trigger.activator:Stop()
      -- Refocus the camera of said player to the position of the teleported hero.
      SendToConsole("dota_camera_center")
    end
  end

function JailTriggeredDire2(trigger)
  print(trigger.activator)
  print(trigger.caller)
end


function JailMuteDire(trigger)
    print("YAY1")
    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    print("YAY2")
      trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_invulnerable", nil)
      trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_silence", nil)
      giveUnitDataDrivenModifier(trigger.activator, trigger.activator, "modifier_make_muted", nil)

      --giveUnitDataDrivenModifier(trigger.activator, trigger.activator, "modifier_make_muted", nil) -- "-1" means that it will last forever (or until its removed)
      trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_disarmed", nil)



     end
  end



function JailMuteDire2(trigger)
    print(trigger.activator)
    print(trigger.caller)
    if trigger.activator then
    trigger.activator:RemoveModifierByName("modifier_invulnerable")
    trigger.activator:RemoveModifierByName("modifier_silence")
    trigger.activator:RemoveModifierByName("modifier_disarmed")
    trigger.activator:RemoveModifierByName("modifier_make_muted")



  end
end












  
function GiveFlask (hero)
    if hero:HasRoomForItem("item_flask", true, true) then
       local flask = CreateItem("item_flask", hero, hero)
       flask:SetPurchaseTime(0)
       hero:AddItem(flask)
    end
 end

function OnStartTouch(trigger)
  print("testjail1")
  GiveFlask(hero)
  print(trigger.activator)
  print(trigger.caller)
  
end








--[[function spawn(keys)
  local inTrigger = false
  local CHECKINGRADIUS = 10

    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(keys.target_points[1], nil), CHECKINGRADIUS) )  do

        if (thing:GetName() == "jail_box") then
            --In no_ward trigger. Set flag.
            inTrigger = true
        end

    end
    
    if (inTrigger == True)
       --Used onto specified area. Do stuff...
       print("in JAIL")
    end
end
--]]