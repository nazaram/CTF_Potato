-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
--require('gamemode')

print("test0")

BAREBONES_DEBUG_SPEW = TRUE

if GameMode == nil then
  GameMode = class({})
end


if score == nil then
  score = class({})
  score.Bad = 0
  score.Good = 0
end

print("test1")
if CONSTANTS == nil then
  CONSTANTS = {}
  CONSTANTS.scoreToWin = 10
  CONSTANTS.goldForPoint = 150
  CONSTANTS.goldForCatch = 15
  CONSTANTS.goldForSave = 10
  -- using this for scoreboard
  -- deny is point
  -- kill is catch
  -- death is be caught
  -- assist is save a friend
end
print("test2")




function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]
print("test3")
  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_enigma", context)

  PrecacheItemByNameSync("item_capture_good_flag", context)
  PrecacheItemByNameSync("item_capture_bad_flag", context)
  PrecacheResource("particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context)

print("test4")
end

print("test4.5")




-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()

end
 
 function GameMode:InitGameMode()
    print("Test7")

  GameMode = GameRules:GetGameModeEntity()


  --Override the values of the team values on the top game bar.
  GameMode:SetTopBarTeamValuesOverride(true)
  GameMode:SetTopBarTeamValuesVisible(true)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, 0)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, 0)


  GameMode:SetRecommendedItemsDisabled(true)

  spawnGoodFlag()
  spawnBadFlag()

  print(" Gamemode rules are set.")

  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)


  -- Register Think
  GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.
  The hero parameter is the hero entity that just spawned in.
]]

function spawnGoodFlag()
  print("entrou spawnGoodFlag")
  local flag = CreateItem("item_capture_good_flag", nil, nil)
  CreateItemOnPositionSync(Vector(-1822.81, -636.813, 128), flag)
  print("saiu spawnGoodFlag")
end

function spawnBadFlag()
  print("entrou spawnBadFlag")
  local flag = CreateItem("item_capture_bad_flag", nil, nil)
  CreateItemOnPositionSync(Vector(-153.281, 2337.62, 128), flag)
  print("saiu spawnBadFlag")
end

  spawnGoodFlag()
  spawnBadFlag()

function GameMode:OnNPCSpawned(keys)
  local hero = EntIndexToHScript(keys.entindex)
  if hero:IsHero() then
    print("OnNPCSpawned zerando pontos de habilidade")
    hero:SetAbilityPoints(0)
  end
end

function GameMode:OnThink()
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    if GameMode.playersAssigned == false then
      GameMode:assignPlayers()
    end
  elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return nil
  end
  return 1
end





 

-- An entity somewhere has been hurt.

function GameMode:OnEntityHurt(keys)
  local attacker = EntIndexToHScript(keys.entindex_attacker)
  local victim= EntIndexToHScript(keys.entindex_killed)

  if attacker:IsHero() == false then
    return
  end
 


  print("time attacker: "..attacker:GetTeamNumber())
  print("time victim: "..victim:GetTeamNumber())

  --DOTA_UNIT_CAP_MOVE_NONE
  --DOTA_UNIT_CAP_MOVE_GROUND
  attacker:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
  --DOTA_UNIT_CAP_NO_ATTACK
  --DOTA_UNIT_CAP_MELEE_ATTACK
  attacker:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
  -- create item to apply modifier
  local itemmod = CreateItem("item_apply_modifiers", victim, victim)
  if attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    giveTeamGold (CONSTANTS.badGuysHero, CONSTANTS.goldForCatch)
    victim:IncrementKills(attacker:GetPlayerID());
    attacker:IncrementDeaths(victim:GetPlayerID());
    itemmod:ApplyDataDrivenModifier(victim, attacker, "modifier_mute", {duration=-1})
    -- check if there is someone of his tem unfrozen
    local teamg = Entities:FindAllByName(CONSTANTS.goodGuysHero)
    local allfrozen = true
    for k,v in pairs(teamg) do
      if v:HasGroundMovementCapability() then
        allfrozen = false
      end
    end
    if allfrozen then
      point(CONSTANTS.badGuysHero)
      victim:IncrementDenies()
      return
    end
    attacker:SetTeam(DOTA_TEAM_CUSTOM_1)
    print("If you have to drop an item")
    for i = 0,5 do
      print("i:"..i)
      local item = attacker:GetItemInSlot(i)
      if item then
        print("item none:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_bad_flag" then
          attacker:RemoveItem(item)
          print("drop item")
          spawnBadFlag()
        end
      end
    end
  elseif attacker:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    giveTeamGold (CONSTANTS.goodGuysHero, CONSTANTS.goldForCatch)
    victim:IncrementKills(attacker:GetPlayerID());
    attacker:IncrementDeaths(victim:GetPlayerID());
    itemmod:ApplyDataDrivenModifier(victim, attacker, "modifier_mute", {duration=-1})
    -- check if there is someone of his tem unfrozen
    local teamb = Entities:FindAllByName(CONSTANTS.badGuysHero)
    local allfrozen = true
    for k,v in pairs(teamb) do
      if v:HasGroundMovementCapability() then
        allfrozen = false
      end
    end
    if allfrozen then
      point(CONSTANTS.goodGuysHero)
      victim:IncrementDenies()
      return
    end
    attacker:SetTeam(DOTA_TEAM_CUSTOM_2)
    print("tem que dropar item")
    for i = 0,5 do
      print("i:"..i)
      local item = attacker:GetItemInSlot(i)
      if item then
        print("item nome:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_good_flag" then
          attacker:RemoveItem(item)
          print("dropando item")
          spawnGoodFlag()
        end
      end
    end
  elseif attacker:GetTeamNumber() == DOTA_TEAM_CUSTOM_1 then
    if victim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      giveTeamGold (CONSTANTS.goodGuysHero, CONSTANTS.goldForSave)
      victim:IncrementAssists(attacker:GetPlayerID());
      attacker:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
      attacker:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
      attacker:SetTeam(DOTA_TEAM_GOODGUYS)
      attacker:RemoveModifierByName("modifier_mute")
    end
  elseif attacker:GetTeamNumber() == DOTA_TEAM_CUSTOM_2 then
    if victim:GetTeamNumber() == DOTA_TEAM_BADGUYS then
      giveTeamGold (CONSTANTS.badGuysHero, CONSTANTS.goldForSave)
      victim:IncrementAssists(attacker:GetPlayerID());
      attacker:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
      attacker:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
      attacker:SetTeam(DOTA_TEAM_BADGUYS)
      attacker:RemoveModifierByName("modifier_mute")
    end
  end
end

function GameMode:updateScore(scoreGood, scoreBad)
  print("Updating score: " .. scoreGood .. " x " .. scoreBad)

  local GameMode = GameRules:GetGameModeEntity()
  GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, scoreGood)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, scoreBad)

  -- If any team reaches scoreToWin, the game ends and that team is considered winner.
  if scoreGood == CONSTANTS.scoreToWin then
    print("Team GOOD GUYS victory!")
    GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
  end
  if scoreBad == CONSTANTS.scoreToWin then
    print("Team BAD GUYS victory!")
    GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
  end
end



-- arg is the name of the hero how made point
-- remove flag from inventory and respawn flag if need
-- reset and respawn heroes
function point(nameHero)
  if nameHero == CONSTANTS.goodGuysHero then
    print("Radiant Point!}")
    score.Good = score.Good + 1
  else
    print("Dire Point!")
    score.Bad = score.Bad + 1
  end
  GameMode:updateScore(score.Good, score.Bad)
  -- gold for the team how made point
  giveTeamGold (nameHero, CONSTANTS.goldForPoint)
  -- reset heroes of good guys e drop/respawn flag if need
  local teamg = Entities:FindAllByName(CONSTANTS.goodGuysHero)
  for k,v in pairs(teamg) do
    for i = 0,5 do
      local item = v:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" then
          UTIL_RemoveImmediate(item)
          spawnBadFlag()
        end
      end
    end
    v:SetTeam(DOTA_TEAM_GOODGUYS)
    v:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    v:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
    v:RemoveModifierByName("modifier_mute")
    v:SetTimeUntilRespawn(0)
  end
  -- reset heroes of bad guys e drop/respawn flag if need
  local teamb = Entities:FindAllByName(CONSTANTS.badGuysHero)
  for k,v in pairs(teamb) do
    for i = 0,5 do
      local item = v:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_good_flag" then
          UTIL_RemoveImmediate(item)
          spawnGoodFlag()
        end
      end
    end
    v:SetTeam(DOTA_TEAM_BADGUYS)
    v:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    v:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
    v:RemoveModifierByName("modifier_mute")
    v:SetTimeUntilRespawn(0)
  end
end

function giveTeamGold (nameTeam, gold)
  local team = Entities:FindAllByName(nameTeam)
  for k,v in pairs(team) do
    v:SetGold(v:GetGold() + gold, false)
  end
end


--]]




 function LevelUpMessage (eventInfo)
     Say(nil, "Someone just leveled up!", false)
 end

 function Activate ()
     ListenToGameEvent("dota_player_gained_level", LevelUpMessage, nil)
 end


 function GiveBlinkDagger (hero)
    if hero:HasRoomForItem("item_blink", true, true) then
       local dagger = CreateItem("item_blink", hero, hero)
       dagger:SetPurchaseTime(0)
       hero:AddItem(dagger)
    end
 end



 function OnHeroPicked (event)
    local hero = EntIndexToHScript(event.heroindex)
    GiveBlinkDagger(hero)
 end

--[[
function GameMode:SpawnFlag()
        print("spawn radiant flag")
        self.GoodguysFlagOnBase = true
        local spawnLocation = Entities:FindByName( nil, "flag_spawn_point" )
        local newItem = CreateItem( "item_ctf_flag", nil, nil )
        newItem:SetPurchaseTime( 0 )
        local drop = CreateItemOnPositionSync( spawnLocation:GetAbsOrigin(), newItem )
end
--]]

--[[
 function Activate ()
    ListenToGameEvent("dota_player_pick_hero", OnHeroPicked, nil)
 end
--]]


