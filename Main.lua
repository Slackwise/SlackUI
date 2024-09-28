-- Change implicit globla scope to our addon "namespace":
setfenv(1, _G.SlackUI)

--[[
  General API Documentation:
   - https://warcraft.wiki.gg/wiki/World_of_Warcraft_API
   - https://warcraft.wiki.gg/wiki/Events
   - https://github.com/BigWigsMods/WoWUI/tree/live/AddOns
   - https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_APIDocumentationGenerated
   - https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentation

  Lua type-checking via VSCode extension:
   - https://luals.github.io/wiki/type-checking/

  Common data structures:
   - ItemLink: https://warcraft.wiki.gg/wiki/ItemLink

  Common functions:
   - Item functions (take an ItemLink as "ItemInfo"):
     - GetItemInfo(): https://warcraft.wiki.gg/wiki/API_C_Item.GetItemInfo
     - GetContainerItemInfo(): https://warcraft.wiki.gg/wiki/API_C_Container.GetContainerItemInfo
     - GetItemIDForItemInfo(): https://warcraft.wiki.gg/wiki/API_C_Item.GetItemIDForItemInfo
]]--

--Event Handlers
function Self:OnEnable()
  setCVars()
  self:RegisterEvent("MERCHANT_SHOW")
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
  self:RegisterEvent("UNIT_AURA")
  self:RegisterEvent("PLAYER_REGEN_ENABLED")
  -- self:RegisterEvent("PLAYER_REGEN_DISABLED")
  self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  self:RegisterEvent("BAG_UPDATE_DELAYED")
  -- self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
  -- self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
end

function Self:OnDisable()
end

function Self:BAG_UPDATE_DELAYED() -- Fires after all BAG_UPDATE's are done
  bindBestUseItems()
end

-- GAME_READY = false
function Self:PLAYER_ENTERING_WORLD(eventName, isLogin, isReload) -- Out of combat
  -- GAME_READY = true
  setupEkil()
  handleDragonriding()
end

function Self:MERCHANT_SHOW(eventName)
  repairAllItems()
  sellGreyItems()
end

function Self:PLAYER_REGEN_ENABLED(eventName) -- Out of combat
  handleDragonriding()
  runAfterCombatActions()
end

function Self:PLAYER_REGEN_DISABLED(eventName) -- In combat

end

function Self:ACTIVE_TALENT_GROUP_CHANGED(currentSpecID, previousSpecID)
  setBindings()
end

function Self:UNIT_AURA(eventName, unitTarget, updateInfo) -- https://warcraft.wiki.gg/wiki/UNIT_AURA
  if unitTarget == "player" then
    log("Aura handling dragonriding...")
    handleDragonriding()
  end
end

--- "Vignettes" are pop-up events on the minimap or world map like rare mobs or treasures: https://warcraft.wiki.gg/wiki/Vignette
--- https://warcraft.wiki.gg/wiki/VIGNETTE_MINIMAP_UPDATED
--- @param vignetteGUID string
--- @param onMinimap boolean
function Self:VIGNETTE_MINIMAP_UPDATED(eventName, vignetteGUID, onMinimap)
  findDruidRareMobs(vignetteGUID)
end


afterCombatActions = {}
function runAfterCombat(f)
  table.insert(afterCombatActions, f)
end

function runAfterCombatActions()
  while #afterCombatActions > 0 do
    if not InCombatLockdown() then
      table.remove(afterCombatActions)()
    end
  end
end

function handleDragonriding()
  if isTester() then
    if isDragonriding() then
      log("BINDING dragonriding")
      bindDragonriding()
    else
      log("UNBINDING dragonriding")
      unbindDragonriding()
    end
  end
end

isDragonridingBound = false

function bindDragonriding()
  if not InCombatLockdown() and not isDragonridingBound then
    SetOverrideBindingSpell(Self.frame, true, "BUTTON3",       "Skyward Ascent")   -- Fly up
    SetOverrideBindingSpell(Self.frame, true, "SHIFT-BUTTON3", "Surge Forward")    -- Fly forward
    SetOverrideBindingSpell(Self.frame, true, "CTRL-BUTTON3",  "Whirling Surge")   -- Fly forward x3
    SetOverrideBindingSpell(Self.frame, true, "BUTTON5",       "Aerial Halt")      -- Brake
    SetOverrideBindingSpell(Self.frame, true, "SHIFT-X",       "Second Wind")      -- Regen Vigor
    SetOverrideBindingSpell(Self.frame, true, "CTRL-X",        "Bronze Timelock")  -- Rewind Time
    if getClassName() == "DRUID" then
      SetOverrideBindingMacro(Self.frame, true, "X",             "X")      -- Moonkin or Brake
    else
      SetOverrideBindingSpell(Self.frame, true, "X",             "Aerial Halt")      -- Brake
    end
    isDragonridingBound = true
    log("Dragonriding keys BOUND")
  end 
end

function unbindDragonriding()
  if not InCombatLockdown() and isDragonridingBound then
    ClearOverrideBindings(Self.frame)
    isDragonridingBound = false
    log("Dragonriding keys CLEARED")
  end
end

SKYRIDING_SPELLID = 404464
function isDragonriding()
  log("Checking if dragonriding...")
  local dragonridingSpellIds = C_MountJournal.GetCollectedDragonridingMounts()
  if C_UnitAuras.GetPlayerAuraBySpellID(SKYRIDING_SPELLID) and isActuallyFlyableArea() then
    if GetShapeshiftForm() == 3 then
      return true
    elseif IsMounted() then
      for _, mountId in ipairs(dragonridingSpellIds) do
        local spellId = select(2, C_MountJournal.GetMountInfoByID(mountId))
        if C_UnitAuras.GetPlayerAuraBySpellID(spellId) then
          return true
        end
      end
    end
  end
  return false
end


function inVehicle()
  return UnitHasVehicleUI("player")
end

function getBattletag()
  return select(2, BNGetInfo())
end

function isSlackwise()
  return getBattletag() == "Slackwise#1121" or false
end

function isEkil()
  return getBattletag() == "ekil#1612" or false
end

-- Gatekeeping new features with no UI
function isTester()
  -- Use a checkbox in settings later, probably, but right now it's just me
  return isSlackwise()
end

function isRetail()
  -- Official way Blizzard distinguishes between game clients: https://warcraft.wiki.gg/wiki/WOW_PROJECT_ID
  if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    return true
  else
    return false
  end
end

function isClassic()
  -- Official way Blizzard distinguishes between game clients: https://warcraft.wiki.gg/wiki/WOW_PROJECT_ID
  if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    return true
  else
    return false
  end
end

function getGameType()
  if isRetail() then
    return "RETAIL"
  elseif isClassic() then
    return "CLASSIC"
  else
    return "UNKNOWN" -- Uh oh
  end
end

function getClassName()
  return select(2, UnitClass("player"))
end

function getSpecName()
  local specIndex = GetSpecialization()
  if specIndex then
    log("specIndex = " .. (specIndex or "nil"))
    local specID, specName = GetSpecializationInfo(specIndex)
    log("specID = " .. (specID or "nil"))
    log("specName = " .. (specName or "nil"))
    if specName then
      return strupper(specName)
    end
  end
  return nil
end

function setCVars()
  SetCVar("cameraDistanceMaxZoomFactor", 2.6) -- Max out camera zoon
  SetCVar("minimapTrackingShowAll", 1) -- Show all minimap tracking options (including turning off target tracking!)
end

function repairAllItems()
  if CanMerchantRepair() then
    RepairAllItems() -- #TODO: pass `true` for guild repairs if currently raiding with guild
  end
end

function canCollectTransmog(itemInfo) -- itemID, itemLink, or Name
  if isClassic() then
    return false
  end
  local itemAppearanceID, sourceID  = C_TransmogCollection.GetItemInfo(itemInfo) -- https://warcraft.wiki.gg/wiki/API_C_TransmogCollection.GetItemInfo
  if sourceID then
    local categoryID, visualID, canEnchant, icon, isCollected, itemLink, transmogLink, unknown1, itemSubTypeIndex = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
    -- local hasItemData, canCollect = C_TransmogCollection.PlayerCanCollectSource(sourceID)
    return not isCollected
  end
  return false
end

ITEM_QUALITY_GREY = 0 

function sellGreyItems()
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 0, C_Container.GetContainerNumSlots(bag) do
      local link = C_Container.GetContainerItemLink(bag, slot)
      if link then
        local itemName, itemLink, itemQuality = C_Item.GetItemInfo(link)
        local collectable = canCollectTransmog(itemLink)
        if itemQuality == ITEM_QUALITY_GREY then
          if collectable then
            print("[SlackUI] Not selling transmog-able item: " .. itemLink)
          else
            C_Container.UseContainerItem(bag, slot)
          end
        end
      end
    end
  end
end

function isSpellKnown(spellName)
  local link, spellID = GetSpellLink(spellName)
  if spellID then
    return IsSpellKnown(spellID)
  end
  return false
end

--- Get all keys from a given `targetTable`.
---@param targetTable table - The table to extract keys from.
---@param value object - The `value` to key off of.
---@return array - First key matching value.
function getKeyByValue(targetTable, targetValue)
  for key, value in pairs(targetTable) do
    if value == targetValue then
      return key
    end
  end
  return nil
end

--- Get all keys from a given `targetTable`.
---@param targetTable table - The table to extract keys from.
---@return array - Array of keys.
function keys(targetTable)
  local collectedKeys = {}
  for key, value in pairs(targetTable) do
    table.insert(collectedKeys, key)
  end
  return collectedKeys
end

--- Find the first table element that match `kvPredicate` function.
---@param targetTable table - The table to find the first element from.
---@param kvPredicate Function(key, value) - A predicate function that takes in `(key, value)` and returns `true` or `false` if it matches.
---@return key, value - First element that matches `kvPredicate`.
function findFirstElement(targetTable, kvPredicate)
  for key, value in pairs(targetTable) do
    if kvPredicate(key, value) then
      return key, value
    end
  end
  return nil, nil
end

--- Find all table elements that match `kvPredicate` function.
---@param targetTable table - The table to find the first element from.
---@param kvPredicate Function(key, value) - A predicate function that takes in `(key, value)` and returns `true` or `false` if it matches.
---@return object[] - Array of all elements that matched `kvPredicate`.
function findElements(targetTable, kvPredicate)
  local found = {}
  for key, value in pairs(targetTable) do
    if kvPredicate(key, value) then
      found[key] = value
    end
  end
  return found
end

--- Returns array of `ContainerItemInfo` tables found in bags that match any of a given array of `itemIDs`
---@param array itemIDs - Array of itemIDs
---@return ContainerItemInfo[] Array of ContainerItemInfo
function findItemsByItemIDs(itemIDs)
  local found = {}
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 0, C_Container.GetContainerNumSlots(bag) do
      local containerItemInfo = C_Container.GetContainerItemInfo(bag, slot)
      if containerItemInfo then
        local itemName = C_Item.GetItemInfo(containerItemInfo.hyperlink)
        if itemName and tContains(itemIDs, containerItemInfo.itemID) then
          table.insert(found, containerItemInfo)
        end
      end
    end
  end
  return found
end

--- Returns array of `ContainerItemInfo` tables found in bags that match Lua regex `pattern`
---@param regex string Lua regexp pattern: https://warcraft.wiki.gg/wiki/Pattern_matching
---@return ContainerItemInfo[] Array of ContainerItemInfo
function findItemsByRegex(regex)
  local found = {}
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 0, C_Container.GetContainerNumSlots(bag) do
      local containerItemInfo = C_Container.GetContainerItemInfo(bag, slot)
      if containerItemInfo then
        local itemName = C_Item.GetItemInfo(containerItemInfo.hyperlink)
        if itemName and string.match(itemName, regex) then
          table.insert(found, containerItemInfo)
        end
      end
    end
  end
  return found
end

--- Group array items into a table by the output of a function.
---@param Array - The array to group.
---@param Function(object) - Takes in an object, and returns new `key, value` which will be grouped by `key`.
---@return Array - The grouped array.
function groupBy(array, groupingFunction)
  local grouped = {}
  for key, value in pairs(array) do
    local groupingKey, newValue = groupingFunction(value)
    if grouped[value] then
      table.insert(grouped[groupingKey], newValue)
    else
      grouped[groupingKey] = { newValue }
    end
  end
  return grouped
end

--- Find the largest (numeric) index of an array.
---@param Array - The array to search.
---@return Integer - Largest numeric index.
function findLargestIndex(array)
  local largestIndex = 0
  for key, value in pairs(array) do
    if tonumber(key) and key >= largestIndex then
      largestIndex = key
    end
  end
  return largestIndex
end

--- Recursively search up the map hierarchy to find a specific map type.
---@param map The map to start at.
---@param upMapType An Enum.UIMapType of the map you're trying to find.
---@return UiMapDetails
function findParentMapByType(map, uiMapType)
  if not map then
    return nil
  end
  if map.mapType == uiMapType or map.mapType == Enum.UIMapType.Cosmic then
    return map
  end 
  return findParentMapByType(C_Map.GetMapInfo(map.parentMapID), uiMapType)
end

function getCurrentMap()
  return C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player") or 0)
end

function getCurrentContinent()
  local map = getCurrentMap()
  if map then
    return findParentMapByType(map, Enum.UIMapType.Continent)
  end
  return nil
end

function getCurrentZone()
  local map = getCurrentMap()
  if map then
    return findParentMapByType(map, Enum.UIMapType.Zone)
  end
  return nil
end

ACTUALLY_FLYABLE_MAPS = {
  CONTINENTS = {
    619, -- Broken Isles
  },
  ZONES = {
  },
  MAPS = {
    627,   -- Legion Dalaran, but as a dungeon due to phasing for the Harbinger questline
  }
}

NOT_ACTUALLY_FLYABLE_MAPS = {
  CONTINENTS = {
    905,	-- Argus
  },
  ZONES = {
    94,    -- Eversong Woods
    95,    -- Ghostlands
    97,    -- Azuremyst Isle
    103,   -- The Exodar
    106,   -- Bloodmyst Isle
    110,   -- Silvermoon City
    122,   -- Isle of Quel'Danas
    747,   -- The Dreamgrove (Druid Legion Hall)
    946,   -- "Cosmic" (Ashran BG)
    1334,  -- Wintergrasp (BG)
    1543,  -- The Maw
    1961,  -- Korthia, The Maw
  },
  MAPS = {
    715,   -- Emerald Dreamway, The Dreamgrove (Druid Legion Hall)
    747,   -- The Dreamgrove (Druid Legion Hall)
  }
}

function isActuallyFlyableArea()
  local continent = getCurrentContinent() or 0
  local zone 			= getCurrentZone() or 0
  local map       = getCurrentMap() or 0

  local listedFlyableContinent    = not not tContains(	    ACTUALLY_FLYABLE_MAPS.CONTINENTS,  continent.mapID  )
  local listedFlyableZone         = not not tContains(	    ACTUALLY_FLYABLE_MAPS.ZONES,       zone.mapID       )
  local listedFlyableMap          = not not tContains(	    ACTUALLY_FLYABLE_MAPS.MAPS,        map.mapID       )

  local listedNonFlyableContinent = not not tContains(	NOT_ACTUALLY_FLYABLE_MAPS.CONTINENTS,  continent.mapID  )
  local listedNonFlyableZone      = not not tContains(	NOT_ACTUALLY_FLYABLE_MAPS.ZONES,       zone.mapID       )
  local listedNonFlyableMap       = not not tContains(	NOT_ACTUALLY_FLYABLE_MAPS.MAPS,        map.mapID        )

  if listedFlyableMap           then return true end
  if listedNonFlyableMap        then return false end

  if listedFlyableZone          then return true end
  if listedNonFlyableZone       then return false end

  if listedFlyableContinent     then return true end
  if listedNonFlyableContinent  then return false end

  return IsFlyableArea()
end

function printDebugMapInfo()
  local map = getCurrentMap()
  local zone = getCurrentZone()
  local continent = getCurrentContinent()
  local parentMap = C_Map.GetMapInfo(map.parentMapID) or "nil"
  if isDebugging() then
    p = log
  else
    p = print
  end
  p("===============================")
  p(map.name .. ", " .. (parentMap.name or "nil"))
  p("Zone: "      .. zone.name .. " (" .. zone.mapID .. ')')
  if continent then
    p("Continent: " .. continent.name .. " (" .. continent.mapID .. ')')
  end
  p("-------------------------------------------------------") -- Chat window does not used fixed width; trying to match header
  p("mapID: "       .. map.mapID)
  p("parentMapID: " .. map.parentMapID)
  p("mapType: "     .. (getKeyByValue(Enum.UIMapType, map.mapType) or "nil") .. " (" .. (map.mapType or "nil") .. ")")
  p("Outdoor: "     .. tostring(IsOutdoors()))
  p("Submerged: "   .. tostring(IsSubmerged()))
  p("Flyable: "     .. tostring(IsFlyableArea()))
  p("AdvancedFlyable: " .. tostring(IsAdvancedFlyableArea()))
  p("ActuallyFlyable: " .. tostring(isActuallyFlyableArea()))
  p("===============================")
end

MOUNTS_BY_USAGE = {
  DEFAULT = {
    ['GROUND']            = MOUNT_IDS["Swift Razzashi Raptor"],
    ['FLYING']            = MOUNT_IDS["Ashes of Al'ar"],
    ['WATER']             = MOUNT_IDS["Sea Turtle"],
    ['GROUND_PASSENGER']  = MOUNT_IDS["Mekgineer's Chopper"],
    ['FLYING_PASSENGER']  = MOUNT_IDS["Renewed Proto-Drake"],
    ['GROUND_SHOWOFF']    = MOUNT_IDS["Swift Razzashi Raptor"],
    ['FLYING_SHOWOFF']    = MOUNT_IDS["Time-Lost Proto-Drake"],
  },
  PALADIN = {
    ['GROUND']            = MOUNT_IDS["Highlord's Golden Charger"],
    ['FLYING']            = MOUNT_IDS["Ashes of Al'ar"],
    ['WATER']             = MOUNT_IDS["Sea Turtle"],
    ['GROUND_PASSENGER']  = MOUNT_IDS["Algarian Stormrider"],
    ['FLYING_PASSENGER']  = MOUNT_IDS["Algarian Stormrider"],
    ['GROUND_SHOWOFF']    = MOUNT_IDS["Swift Razzashi Raptor"],
    ['FLYING_SHOWOFF']    = MOUNT_IDS["Time-Lost Proto-Drake"],
  },
}

function setupEkil()
  if isEkil() then
    MOUNTS_BY_USAGE = {
      DEFAULT = {
        ['GROUND']           = MOUNT_IDS["Ironbound Proto-Drake"],
        ['FLYING']           = MOUNT_IDS["Ironbound Proto-Drake"],
        ['WATER']            = MOUNT_IDS["Ironbound Proto-Drake"],
        ['GROUND_PASSENGER'] = MOUNT_IDS["Renewed Proto-Drake"],
        ['FLYING_PASSENGER'] = MOUNT_IDS["Renewed Proto-Drake"],
        ['GROUND_SHOWOFF']   = MOUNT_IDS["Ironbound Proto-Drake"],
        ['FLYING_SHOWOFF']   = MOUNT_IDS["Ironbound Proto-Drake"],
      }
    }
  end
end

function mountByUsage(usage)
  if isDebugging() then
    printDebugMapInfo()
  end
  local classMounts = MOUNTS_BY_USAGE[getClassName()] or MOUNTS_BY_USAGE["DEFAULT"]
  C_MountJournal.SummonByID(classMounts[usage])
end

function mountByName(mountName)
  C_MountJournal.SummonByID(MOUNT_IDS[mountName])
end

function isAlternativeMountRequested()
  return IsControlKeyDown()
end

function mount()  
  if IsMounted() then
    Dismount()
    return
  end

  if UnitUsingVehicle("player") then
    VehicleExit()
    return
  end

  if IsOutdoors() then
    if isActuallyFlyableArea() and not IsSubmerged() then -- Summon flying mount
      log("FLYING AREA")
      if isAlternativeMountRequested() then -- But we may want to show off our ground mount
        mountByUsage("FLYING_SHOWOFF")
        return
      end
      if IsInGroup() then
        mountByUsage("FLYING_PASSENGER")
        return
      else
        mountByUsage("FLYING")
        return
      end
      return
    elseif IsSubmerged() then -- Summon water mount
      if isAlternativeMountRequested() then -- But we may want to fly out of the water
        mountByUsage("FLYING")
        return
      end
      mountByUsage("WATER")
      return
    else -- Summon ground mount
      if IsInGroup() then
        if isAlternativeMountRequested() then -- But we may want to show off
          mountByUsage("GROUND_SHOWOFF")
          return
        end
        mountByUsage("GROUND_PASSENGER")
        return
      else
        if isAlternativeMountRequested() then -- But we may want to show off
          mountByUsage("GROUND_SHOWOFF")
          return
        end
        mountByUsage("GROUND")
        return
      end
    end
  end
end

DRUID_RARE_MOBS = {
  "Keen-eyed Cian",
  "Matriarch Keevah",
  "Moragh the Slothful",
  "Mosa Umbramane",
  "Ristar the Rabid",
  "Talthonei Ashwhisper"
}
function findDruidRareMobs(vignetteGUID)
  if getClassName() ~= "DRUID" then return end

  log("VIGNETTE ID: " .. vignetteGUID)
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID) -- https://warcraft.wiki.gg/wiki/API_C_VignetteInfo.GetVignetteInfo
	if not vignetteInfo then return end
  local name = vignetteInfo.name
  log("VIGNETTE NAME: " .. (name or ""))

  if tContains(DRUID_RARE_MOBS, name) then
    foundDruidRare(name)
  end
end

foundDruidRares = {}
function foundDruidRare(name)
  local currentUnixTimestamp = GetServerTime()
  local currentHour, currentMinute = GetGameTime()
  local lastTimeFound = foundDruidRares[name]
  if not lastTimeFound or isTimeWithin(lastTimeFound, 5 * 60, GetServerTime()) then
    foundDruidRares[name] = { currentUnixTimestamp, currentHour, currentMinute }
  end
end

function announceFoundDruidRare(name)
  log("Found druid rare: " .. name)
  SendChatMessage(name ".. spotted!", "CHANNEL", nil, 5)
end

--- Checks if a time is within a given time of another time
--- @param originUnixTimestamp integer
--- @param secondsToBeWithin integer
--- @param currentUnixTimestamp integer
--- @return boolean
function isTimeWithin(originUnixTimestamp, secondsToBeWithin, currentUnixTimestamp)
  return currentUnixTimestamp >= (originUnixTimestamp + (secondsToBeWithin * 1000))
end

--[[ -- TODO: Update broken fishing pole right-click handler
function events:PLAYER_EQUIPMENT_CHANGED(slot, hasItem)
  if InCombat() then return
  if select(6, GetItemInfo(GetInventoryItemID("player", slot))) == "Fishing Poles" then
    --Right-click to cast.
    if not frame:IsHooked(WorldFrame, "OnMouseDown") then
      frame:HookScript(WorldFrame, "OnMouseDown",
        function()
        end
      )
    end
  else
    --Undo right-click casting.
    if frame:IsHooked(WorldFrame, "OnMouseDown") then
      frame:Unhook(WorldFrame, "OnMouseDown")
    end
  end
end
]]
