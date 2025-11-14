local Self = LibStub("AceAddon-3.0", "NewAddon", "SlackwiseTweaks", "AceConsole-3.0", "AceEvent-3.0")
Self.config = LibStub("AceConfig-3.0")
Self.frame = CreateFrame("Frame", "SlackwiseTweaks")
Self.itemBindingFrame = CreateFrame("Frame", "SlackwiseTweaks Item Bindings")
_G.SlackwiseTweaks = Self
Self.Self = Self
setmetatable(Self, {__index = _G})
setfenv(1, Self)
local addonName = Self.addonName
local addonTable = Self.addonTable
local dbDefaults = {global = {log = {}, isDebugging = false}, profile = {mounts = {ground = nil, ["ground-showoff"] = nil, skyriding = nil, ["skyriding-showoff"] = nil, steadyflight = nil, ["steadyflight-showoff"] = nil, water = nil, ["water-showoff"] = nil, ["ground-passenger"] = nil, ["ground-passenger-showoff"] = nil, ["skyriding-passenger"] = nil, ["skyriding-passenger-showoff"] = nil, ["steadyflight-passenger"] = nil, ["steadyflight-passenger-showoff"] = nil}}}
local function getBattletag()
  return select(2, BNGetInfo())
end
local function isSlackwise()
  return (getBattletag() == "Slackwise#1121")
end
local function isTester()
  return isSlackwise()
end
local function isRetail()
  if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
    return true
  else
    return false
  end
end
local function isClassic()
  if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
    return true
  else
    return false
  end
end
local function getGameType()
  return cond(isRetail(), "RETAIL", isClassic(), "CLASSIC", "else", "UNKNOWN")
end
local function isDebugging()
  if isInitialized() then
    return Self.db.global.isDebugging
  else
    if isSlackwise() then
      return true
    else
      return false
    end
  end
end
local COLOR_START = "|c"
local COLOR_END = "|r"
local function color(color0)
  local function _5_(text)
    return (COLOR_START .. "FF" .. color0 .. text .. COLOR_END)
  end
  return _5_
end
local grey = color("AAAAAA")
local function log(message, ...)
  local args = {...}
  if isDebugging() then
    print((grey(date()) .. "  " .. message))
    if isInitialized() then
      table.insert(Self.db.global.log, (date() .. "  " .. message))
      if args then
        for i, v in ipairs(args) do
          print(("Arg " .. i .. " = " .. v))
          table.insert(Self.db.global.log, ("Arg " .. i .. " = " .. v))
        end
        return nil
      else
        return nil
      end
    else
      return nil
    end
  else
    return nil
  end
end
local function OnInitialize(self)
  self.db = LibStub("AceDB-3.0", "New", "SlackwiseTweaksDB", dbDefaults)
  do local _ = config.RegisterOptionsTable.SlackwiseTweaks[options].slack end
  self.configDialog = LibStub("AceConfigDialog-3.0", "AddToBlizOptions", "SlackwiseTweaks")
  return nil
end
local function isInitialized()
  return not not get(Self, "configDialog")
end
return isInitialized
local MOUNT_IDS = {Charger = 84, ["Swift Razzashi Raptor"] = 110, ["Ashes of Al'ar"] = 183, ["Time-Lost Proto-Drake"] = 265, ["Mekgineer's Chopper"] = 275, ["Ironbound Proto-Drake"] = 306, ["Sea Turtle"] = 312, ["X-45 Heartbreaker"] = 352, ["Celestial Steed"] = 376, ["Sandstone Drake"] = 407, ["Tyrael's Charger"] = 439, ["Grand Expedition Yak"] = 460, ["Sky Golem"] = 522, ["Highlord's Golden Charger"] = 885, ["Highland Drake"] = 1563, ["Winding Slitherdrake"] = 1588, ["Renewed Proto-Drake"] = 1589, ["Grotto Netherwing Drake"] = 1744, ["Algarian Stormrider"] = 1792, ["Auspicious Arborwyrm"] = 1795, ["Trader's Gilded Brutosaur"] = 2265, ["Chaos-Forged Gryphon"] = 2304}
local ACTUALLY_FLYABLE_MAP_IDS = {CONTINENTS = {619}, ZONES = {}, MAPS = {627}}
local NOT_ACTUALLY_FLYABLE_MAP_IDS = {CONTINENTS = {905}, ZONES = {94, 95, 97, 103, 106, 110, 122, 747, 946, 1334, 1543, 1961}, MAPS = {715, 747, 1478}}
local ALCHEMIST_VALUE_OFFSET = 1000
local BEST_ITEMS = {BEST_HEALING_POTIONS = {BINDING_NAME = "SLACKWISETWEAKS_BEST_HEALING_POTION", [212944] = (3839450 + ALCHEMIST_VALUE_OFFSET), [212943] = (3681800 + ALCHEMIST_VALUE_OFFSET), [212942] = (3530600 + ALCHEMIST_VALUE_OFFSET), [211880] = 3839450, [211879] = 3681800, [211878] = 3530600, [212950] = (2799950 + ALCHEMIST_VALUE_OFFSET), [212949] = (2685000 + ALCHEMIST_VALUE_OFFSET), [212948] = (2574760 + ALCHEMIST_VALUE_OFFSET), [212244] = 2799950, [212243] = 2685000, [212242] = 2574760, [207023] = 310592, [207022] = 266709, [207021] = 228992, [191380] = 160300, [191379] = 137550, [191378] = 118000, [13446] = 1750, [3928] = 900, [1710] = 585, [929] = 360, [858] = 180, [118] = 90}, BEST_MANA_POTIONS = {BINDING_NAME = "SLACKWISETWEAKS_BEST_MANA_POTION", [212947] = (270000 + ALCHEMIST_VALUE_OFFSET), [212946] = (234783 + ALCHEMIST_VALUE_OFFSET), [212945] = (204159 + ALCHEMIST_VALUE_OFFSET), [212241] = 270000, [212240] = 234783, [212239] = 204159, [212950] = (202500 + ALCHEMIST_VALUE_OFFSET), [212949] = (176087 + ALCHEMIST_VALUE_OFFSET), [212948] = (153119 + ALCHEMIST_VALUE_OFFSET), [212244] = 202500, [212243] = 176087, [212242] = 153119, [191386] = 27600, [191385] = 24000, [191384] = 20870, [13444] = 2250, [13443] = 1500, [6149] = 900, [3827] = 585, [3385] = 360, [2455] = 180}, BEST_BANDAGES = {BINDING_NAME = "SLACKWISETWEAKS_BEST_BANDAGE", [224442] = 3339000, [224441] = 2504250, [224440] = 1669500, [194050] = 50768, [194049] = 43560, [194048] = 37376, [14530] = 2000, [14529] = 1360, [8545] = 1104, [8544] = 800, [6451] = 640, [6450] = 400, [3531] = 301, [3530] = 161, [2581] = 114, [1251] = 66}}
return nil
local function OnEnable(self)
  setCVars()
  do local _ = self.RegisterEvent.MERCHANT_SHOW end
  do local _ = self.RegisterEvent.PLAYER_ENTERING_WORLD end
  do local _ = self.RegisterEvent.UNIT_AURA end
  do local _ = self.RegisterEvent.PLAYER_REGEN_ENABLED end
  do local _ = self.RegisterEvent.ACTIVE_TALENT_GROUP_CHANGED end
  return self.RegisterEvent.BAG_UPDATE_DELAYED
end
local function OnDisable(self)
end
local function BAG_UPDATE_DELAYED(self)
  return bindBestUseItems()
end
local function PLAYER_ENTERING_WORLD(self, eventName, isLogin, isReload)
  setupEkil()
  return handleDragonriding()
end
local function MERCHANT_SHOW(self, eventName)
  repairAllItems()
  return sellGreyItems()
end
local function PLAYER_REGEN_ENABLED(self, eventName)
  handleDragonriding()
  return runAfterCombatActions()
end
local function PLAYER_REGEN_DISABLED(self, eventName)
end
local function ACTIVE_TALENT_GROUP_CHANGED(self, currentSpecID, previousSpecID)
  return setBindings()
end
local function UNIT_AURA(self, eventName, unitTarget, updateInfo)
  if (unitTarget == "player") then
    return handleDragonriding()
  else
    return nil
  end
end
local afterCombatActions = {}
local function runAfterCombat(f)
  return table.insert(afterCombatActions, f)
end
local function runAfterCombatActions()
  while (#afterCombatActions > 0) do
    if not InCombatLockdown() then
      table.remove(afterCombatActions)()
    else
    end
  end
  return nil
end
local function inVehicle()
  return UnitHasVehicleUI("player")
end
local function isEkil()
  return (getBattletag() == "ekil#1612")
end
local function getClassName()
  return select(2, UnitClass("player"))
end
local function getSpecName()
  local specIndex = GetSpecialization()
  if specIndex then
    log(("specIndex = " .. (specIndex or "nil")))
    local _let_3_ = GetSpecializationInfo(specIndex)
    local specID = _let_3_[1]
    local specName = _let_3_[2]
    log(("specID = " .. (specID or "nil")))
    log(("specName = " .. (specName or "nil")))
    if specName then
      return strupper(specName)
    else
      return nil
    end
  else
    return nil
  end
end
local function setCVars()
  SetCVar("cameraDistanceMaxZoomFactor", 2.6)
  return SetCVar("minimapTrackingShowAll", 1)
end
local function repairAllItems()
  if CanMerchantRepair() then
    return RepairAllItems()
  else
    return nil
  end
end
local ITEM_QUALITY_GREY = 0
local function canCollectTransmog(itemInfo)
  if isClassic() then
    return false
  else
    local _let_7_ = C_TransmogCollection.GetItemInfo(itemInfo)
    local itemAppearanceID = _let_7_[1]
    local sourceID = _let_7_[2]
    if sourceID then
      local _let_8_ = C_TransmogCollection.GetAppearanceSourceInfo(sourceID)
      local _ = _let_8_[1]
      local _0 = _let_8_[2]
      local _1 = _let_8_[3]
      local _2 = _let_8_[4]
      local isCollected = _let_8_[5]
      local _3 = _let_8_[6]
      local _4 = _let_8_[7]
      local _5 = _let_8_[8]
      local _6 = _let_8_[9]
      return not isCollected
    else
      return false
    end
  end
end
local function sellGreyItems()
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 0, C_Container.GetContainerNumSlots(bag) do
      local link = C_Container.GetContainerItemLink(bag, slot)
      if link then
        local _let_11_ = C_Item.GetItemInfo(link)
        local _ = _let_11_[1]
        local itemLink = _let_11_[2]
        local itemQuality = _let_11_[3]
        if (itemQuality == ITEM_QUALITY_GREY) then
          if canCollectTransmog(itemLink) then
            print(("[SlackwiseTweaks] Not selling transmog-able item: " .. itemLink))
          else
            C_Container.UseContainerItem(bag, slot)
          end
        else
        end
      else
      end
    end
  end
  return nil
end
local function isSpellKnown(spellName)
  local _let_15_ = GetSpellLink(spellName)
  local _ = _let_15_[1]
  local spellID = _let_15_[2]
  if spellID then
    return IsSpellKnown(spellID)
  else
    return false
  end
end
local function getKeyByValue(targetTable, targetValue)
  local function _17_()
    if (value == targetValue) then
      return __fnl_global__return(key)
    else
      return nil
    end
  end
  __fnl_global__each_2dpair({key, value, targetTable}, _17_())
  return nil
end
local function keys(targetTable)
  local collectedKeys = {}
  __fnl_global__each_2dpair({key, value, targetTable}, table.insert(collectedKeys, key))
  return collectedKeys
end
local function findFirstElement(targetTable, kvPredicate)
  local function _18_()
    if kvPredicate(key, value) then
      return __fnl_global__return({key, value})
    else
      return nil
    end
  end
  __fnl_global__each_2dpair({key, value, targetTable}, _18_())
  return {nil, nil}
end
local function findElements(targetTable, kvPredicate)
  local found = {}
  local function _19_()
    if kvPredicate(key, value) then
      found[key] = value
      return nil
    else
      return nil
    end
  end
  __fnl_global__each_2dpair({key, value, targetTable}, _19_())
  return found
end
local function findItemsByItemIDs(itemIDs)
  local found = {}
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 0, C_Container.GetContainerNumSlots(bag) do
      local containerItemInfo = C_Container.GetContainerItemInfo(bag, slot)
      if containerItemInfo then
        local itemName = C_Item.GetItemInfo(containerItemInfo.hyperlink)
        if (itemName and tContains(itemIDs, containerItemInfo.itemID)) then
          table.insert(found, containerItemInfo)
        else
        end
      else
      end
    end
  end
  return found
end
local function findItemsByRegex(regex)
  local found = {}
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 0, C_Container.GetContainerNumSlots(bag) do
      local containerItemInfo = C_Container.GetContainerItemInfo(bag, slot)
      if containerItemInfo then
        local itemName = C_Item.GetItemInfo(containerItemInfo.hyperlink)
        if (itemName and string.match(itemName, regex)) then
          table.insert(found, containerItemInfo)
        else
        end
      else
      end
    end
  end
  return found
end
local function groupBy(array, groupingFunction)
  local grouped = {}
  local function _25_()
    local _let_24_ = groupingFunction(value)
    local groupingKey = _let_24_[1]
    local newValue = _let_24_[2]
    if grouped[value] then
      return table.insert(grouped[groupingKey], newValue)
    else
      grouped[groupingKey] = {newValue}
      return nil
    end
  end
  __fnl_global__each_2dpair({key, value, array}, _25_())
  return grouped
end
local function findLargestIndex(array)
  local largestIndex = 0
  local function _27_()
    if (tonumber(key) and (key >= largestIndex)) then
      largestIndex = key
      return nil
    else
      return nil
    end
  end
  __fnl_global__each_2dpair({key, value, array}, _27_())
  return largestIndex
end
local function findParentMapByType(map, uiMapType)
  if not map then
    return nil
  else
    if ((map.mapType == uiMapType) or (map.mapType == Enum.UIMapType.Cosmic)) then
      return map
    else
      return findParentMapByType(C_Map.GetMapInfo(map.parentMapID), uiMapType)
    end
  end
end
local function getCurrentMap()
  return C_Map.GetMapInfo((C_Map.GetBestMapForUnit("player") or 0))
end
local function getCurrentContinent()
  local map = getCurrentMap()
  if map then
    return findParentMapByType(map, Enum.UIMapType.Continent)
  else
    return nil
  end
end
local function getCurrentZone()
  local map = getCurrentMap()
  if map then
    return findParentMapByType(map, Enum.UIMapType.Zone)
  else
    return nil
  end
end
local function isActuallyFlyableArea()
  local continent = getCurrentContinent()
  local continentID
  if continent then
    continentID = continent.mapID
  else
    continentID = 0
  end
  local zone = getCurrentZone()
  local zoneID
  if zone then
    zoneID = zone.mapID
  else
    zoneID = 0
  end
  local map = getCurrentMap()
  local mapID
  if map then
    mapID = map.mapID
  else
    mapID = 0
  end
  local listedFlyableContinent = not not tContains(ACTUALLY_FLYABLE_MAP_IDS.CONTINENTS, continentID)
  local listedFlyableZone = not not tContains(ACTUALLY_FLYABLE_MAP_IDS.ZONES, zoneID)
  local listedFlyableMap = not not tContains(ACTUALLY_FLYABLE_MAP_IDS.MAPS, mapID)
  local listedNonFlyableContinent = not not tContains(NOT_ACTUALLY_FLYABLE_MAP_IDS.CONTINENTS, continentID)
  local listedNonFlyableZone = not not tContains(NOT_ACTUALLY_FLYABLE_MAP_IDS.ZONES, zoneID)
  local listedNonFlyableMap = not not tContains(NOT_ACTUALLY_FLYABLE_MAP_IDS.MAPS, mapID)
  return cond(listedFlyableMap, true, listedNonFlyableMap, false, listedFlyableZone, true, listedNonFlyableZone, false, listedFlyableContinent, true, listedNonFlyableContinent, false, "else", IsFlyableArea())
end
local function printDebugMapInfo()
  local map = getCurrentMap()
  local zone = getCurrentZone()
  local continent = getCurrentContinent()
  local parentMap = (C_Map.GetMapInfo(map.parentMapID) or "nil")
  local p
  if isDebugging() then
    p = log
  else
    p = print
  end
  p("===============================")
  p((map.name .. ", " .. (parentMap.name or "nil")))
  p(("Zone: " .. zone.name .. " (" .. zone.mapID .. ")"))
  if continent then
    p(("Continent: " .. continent.name .. " (" .. continent.mapID .. ")"))
  else
  end
  p("-------------------------------------------------------")
  p(("mapID: " .. map.mapID))
  p(("parentMapID: " .. map.parentMapID))
  p(("mapType: " .. (getKeyByValue(Enum.UIMapType, map.mapType) or "nil") .. " (" .. (map.mapType or "nil") .. ")"))
  p(("Outdoor: " .. tostring(IsOutdoors())))
  p(("Submerged: " .. tostring(IsSubmerged())))
  p(("Flyable: " .. tostring(IsFlyableArea())))
  p(("AdvancedFlyable: " .. tostring(IsAdvancedFlyableArea())))
  p(("ActuallyFlyable: " .. tostring(isActuallyFlyableArea())))
  return p("===============================")
end
local DRUID_RARE_MOBS = {"Keen-eyed Cian", "Matriarch Keevah", "Moragh the Slothful", "Mosa Umbramane", "Ristar the Rabid", "Talthonei Ashwhisper"}
local function findDruidRareMobs(vignetteGUID)
  if not (getClassName() == "DRUID") then
    __fnl_global__return(nil)
  else
  end
  log(("VIGNETTE ID: " .. vignetteGUID))
  local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID)
  if vignetteInfo then
    local name = vignetteInfo.name
    log(("VIGNETTE NAME: " .. (name or "")))
    if tContains(DRUID_RARE_MOBS, name) then
      return foundDruidRare(name)
    else
      return nil
    end
  else
    return nil
  end
end
local foundDruidRares = {}
local function foundDruidRare(name)
  local currentUnixTimestamp = GetServerTime()
  local _let_40_ = GetGameTime()
  local currentHour = _let_40_[1]
  local currentMinute = _let_40_[2]
  local lastTimeFound = get(foundDruidRares, name)
  if (not lastTimeFound or isTimeWithin(lastTimeFound, (5 * 60), GetServerTime())) then
    foundDruidRares[name] = {currentUnixTimestamp, currentHour, currentMinute}
    return nil
  else
    return nil
  end
end
local function announceFoundDruidRare(name)
  log(("Found druid rare: " .. name))
  return SendChatMessage((name .. ".. spotted!"), "CHANNEL", nil, 5)
end
local function isTimeWithin(originUnixTimestamp, secondsToBeWithin, currentUnixTimestamp)
  return (currentUnixTimestamp >= (originUnixTimestamp + (secondsToBeWithin * 1000)))
end
return isTimeWithin
_G.BINDING_HEADER_SLACKWISETWEAKS = "SlackwiseTweaks"
_G.BINDING_NAME_SLACKWISETWEAKS_RESTART_SOUND = "Restart Sound"
_G.BINDING_NAME_SLACKWISETWEAKS_RELOADUI = "Reload UI"
_G.BINDING_NAME_SLACKWISETWEAKS_MOUNT = "Mount"
_G.BINDING_NAME_SLACKWISETWEAKS_SETBINDINGS = "Load Keybindings"
_G.BINDING_NAME_SLACKWISETWEAKS_BEST_HEALING_POTION = "Use Best Healing Potion"
_G.BINDING_NAME_SLACKWISETWEAKS_BEST_MANA_POTION = "Use Best Mana Potion"
_G.BINDING_NAME_SLACKWISETWEAKS_BEST_BANDAGE = "Use Best Bandage"
local BINDINGS = {}
BINDING_TYPE = {DEFAULT_BINDINGS = 0, ACCOUNT_BINDINGS = 1, CHARACTER_BINDINGS = 2}
BINDINGS_FUNCTIONS = {command = SetBinding, spell = SetBindingSpell, macro = SetBindingMacro, item = SetBindingItem}
local function setBinding(binding)
  local key = binding[1]
  local type = binding[2]
  local name = binding[3]
  return BINDINGS_FUNCTIONS[type](key, name)
end
local function getBindingDescription(bindingName)
  return (_G(("BINDING_NAME_" .. bindingName)) or "")
end
local function unbindUnwantedDefaults()
  return SetBinding("SHIFT-T")
end
local function bindBestUseItems()
  if InCombatLockdown() then
    runAfterCombat(bindBestUseItems)
    __fnl_global__return()
  else
  end
  ClearOverrideBindings(Self.itemBindingFrame)
  return __fnl_global__each_2dpair({itemType, itemMap, BEST_ITEMS}, log(("Binding " .. getBindingDescription(itemMap.BINDING_NAME) .. "...")), bindBestUseItem(itemMap))
end
local function bindBestUseItem(bestItemMap)
  local containerItemInfos = findItemsByItemIDs(keys(bestItemMap))
  if (isDebugging() and containerItemInfos) then
    log((getBindingDescription(bestItemMap.BINDING_NAME) .. ": found items:"))
    for i, item in ipairs(containerItemInfos) do
      log(("    " .. item.stackCount .. "x of " .. item.itemID .. " " .. item.hyperlink))
    end
  else
  end
  local itemsByBestStrength
  local function _3_(item)
    return bestItemMap[item.itemID], {item.itemID, item.stackCount}
  end
  itemsByBestStrength = groupBy(containerItemInfos, _3_)
  local bestItems = itemsByBestStrength[findLargestIndex(itemsByBestStrength)]
  if bestItems then
    local smallestStack = 9999
    local bestItemID = nil
    for i, itemStack in ipairs(bestItems) do
      local itemID = itemStack[1]
      local stackCount = itemStack[2]
      if (stackCount < smallestStack) then
        smallestStack = stackCount
        bestItemID = itemID
      else
      end
    end
    log(("Best found smallest stack itemID: " .. bestItemID))
    if bestItemID then
      local desiredBindingKeys = {GetBindingKey(bestItemMap.BINDING_NAME)}
      if (#desiredBindingKeys > 0) then
        for i, key in ipairs(desiredBindingKeys) do
          log(("Binding ID " .. bestItemID .. " " .. C_Item.GetItemNameByID(bestItemID) .. " to " .. key))
          SetOverrideBindingItem(Self.itemBindingFrame, true, key, ("item:" .. bestItemID))
        end
        return nil
      else
        return nil
      end
    else
      return nil
    end
  else
    return nil
  end
end
local function setBindings()
  if not isTester() then
    print("SlackwiseTweaks Bindings: Work in progress. Cannot bind currently.")
    __fnl_global__return()
  else
  end
  if InCombatLockdown() then
    runAfterCombat(setBindings)
    __fnl_global__return()
  else
  end
  LoadBindings(BINDING_TYPE.DEFAULT_BINDINGS)
  unbindUnwantedDefaults()
  for _, binding in ipairs(BINDINGS.GLOBAL) do
    setBinding(binding)
  end
  local game = getGameType()
  local class = getClassName()
  local bindings = BINDINGS[game][class]
  if isRetail() then
    local spec = getSpecName()
    if not spec then
      print("SlackwiseTweaks Binding: No spec currently to bind!")
    else
    end
    if not (bindings.CLASS == nil) then
      if bindings.CLASS.PRE_SCRIPT then
        bindings.CLASS.PRE_SCRIPT()
      else
      end
      for _, binding in ipairs(bindings.CLASS) do
        local key = binding[1]
        local type = binding[2]
        local name = binding[3]
        if not ((type == "spell") and not C_Spell.DoesSpellExist(name)) then
          setBinding(binding)
        else
        end
      end
      if bindings.CLASS.POST_SCRIPT then
        bindings.CLASS.POST_SCRIPT()
      else
      end
    else
    end
    if (spec and not (spec == "")) then
      if bindings[spec].PRE_SCRIPT then
        bindings[spec].PRE_SCRIPT()
      else
      end
      do
        local specBindings = bindings[spec]
        if not (specBindings == nil) then
          for _, binding in ipairs(specBindings) do
            if not ((binding[2] == "spell") and not C_Spell.DoesSpellExist(binding[3])) then
              setBinding(binding)
            else
            end
          end
        else
        end
      end
      if bindings[spec].POST_SCRIPT then
        bindings[spec].POST_SCRIPT()
      else
      end
    else
    end
    SaveBindings(BINDING_TYPE.CHARACTER_BINDINGS)
    return print(((spec or "CLASS-ONLY") .. " " .. class .. " binding presets loaded!"))
  elseif isClassic() then
    if bindings.PRE_SCRIPT then
      bindings.PRE_SCRIPT()
    else
    end
    for _, binding in ipairs(bindings) do
      local key = binding[1]
      local type = binding[2]
      local name = binding[3]
      if not ((type == "spell") and not C_Spell.DoesSpellExist(name)) then
        setBinding(binding)
      else
      end
    end
    if bindings.POST_SCRIPT then
      bindings.POST_SCRIPT()
    else
    end
    SaveBindings(BINDING_TYPE.CHARACTER_BINDINGS)
    return print((class .. " binding presets loaded!"))
  else
    return print("Unknown game type! Cannot rebind.")
  end
end
return setBindings
local options
local function _1_()
  return Self:IsEnabled()
end
local function _2_()
  if Self:IsEnabled() then
    return Self:Disable()
  else
    return Self:Enable()
  end
end
local function _4_()
  return db.global.isDebugging
end
local function _5_()
  db.global.isDebugging = not db.global.isDebugging
  if db.global.isDebugging then
    return print("SlackwiseTweaks Debugging ON")
  else
    return print("SlackwiseTweaks Debugging OFF")
  end
end
local function _7_()
  return setBindings()
end
local function _8_()
  db:ResetDB()
  return print("SlackwiseTweaks: ALL DATA WIPED")
end
options = {type = "group", args = {enable = {name = "Enabled", desc = ("Enable/disable " .. addonName), type = "toggle", get = _1_, set = _2_, order = 0}, debug = {name = "Enable Debugging", desc = "Enable debugging logs and stuff", type = "toggle", get = _4_, set = _5_}, bind = {type = "execute", name = "Set Bindings", desc = "Set binding presets for current character's class and spec.", func = _7_, hidden = true}, reset = {type = "execute", name = "Reset All Data", desc = "DANGER: Wipes all settings! Cannot be undone!", func = _8_, confirm = true}}}
return nil
local function handleDragonriding()
  if isTester() then
    if isDragonriding() then
      return bindDragonriding()
    else
      return unbindDragonriding()
    end
  else
    return nil
  end
end
local isDragonridingBound = false
local function bindDragonriding()
  if (not InCombatLockdown() and not isDragonridingBound) then
    SetOverrideBindingSpell(Self.frame, true, "BUTTON3", "Skyward Ascent")
    SetOverrideBindingSpell(Self.frame, true, "SHIFT-BUTTON3", "Surge Forward")
    SetOverrideBindingSpell(Self.frame, true, "CTRL-BUTTON3", "Whirling Surge")
    SetOverrideBindingSpell(Self.frame, true, "BUTTON5", "Aerial Halt")
    SetOverrideBindingSpell(Self.frame, true, "SHIFT-X", "Second Wind")
    SetOverrideBindingSpell(Self.frame, true, "CTRL-X", "Bronze Timelock")
    if (getClassName() == "DRUID") then
      SetOverrideBindingMacro(Self.frame, true, "X", "X")
    else
      SetOverrideBindingSpell(Self.frame, true, "X", "Aerial Halt")
    end
    isDragonridingBound = true
    return nil
  else
    return nil
  end
end
local function unbindDragonriding()
  if (not InCombatLockdown() and isDragonridingBound) then
    ClearOverrideBindings(Self.frame)
    isDragonridingBound = false
    return nil
  else
    return nil
  end
end
local SKYRIDING_SPELLID = 404464
local function isDragonriding()
  local dragonridingSpellIds = C_MountJournal.GetCollectedDragonridingMounts()
  if (C_UnitAuras.GetPlayerAuraBySpellID(SKYRIDING_SPELLID) and isActuallyFlyableArea()) then
    if (GetShapeshiftForm() == 3) then
      return true
    else
      if IsMounted() then
        for mountId in dragonridingSpellIds do
          local spellId = select(2, C_MountJournal.GetMountInfoByID(mountId))
          if C_UnitAuras.GetPlayerAuraBySpellID(spellId) then
            __fnl_global__return(true)
          else
          end
        end
        return nil
      else
        return nil
      end
    end
  else
    return false
  end
end
local MOUNTS_BY_USAGE = {}
local function setupEkil()
  if isEkil() then
    MOUNTS_BY_USAGE = {DEFAULT = {GROUND = get(MOUNT_IDS, "Ironbound Proto-Drake"), FLYING = get(MOUNT_IDS, "Ironbound Proto-Drake"), WATER = get(MOUNT_IDS, "Ironbound Proto-Drake"), GROUND_PASSENGER = get(MOUNT_IDS, "Renewed Proto-Drake"), FLYING_PASSENGER = get(MOUNT_IDS, "Renewed Proto-Drake"), GROUND_SHOWOFF = get(MOUNT_IDS, "Ironbound Proto-Drake"), FLYING_SHOWOFF = get(MOUNT_IDS, "Ironbound Proto-Drake")}}
    return nil
  else
    return nil
  end
end
local function mountByUsage(usage)
  if isDebugging() then
    printDebugMapInfo()
  else
  end
  local classMounts = (get(MOUNTS_BY_USAGE, getClassName()) or get(MOUNTS_BY_USAGE, "DEFAULT"))
  return C_MountJournal.SummonByID(get(classMounts, usage))
end
local function mountByName(mountName)
  return C_MountJournal.SummonByID(get(MOUNT_IDS, mountName))
end
local function isAlternativeMountRequested()
  return IsModifierKeyDown()
end
local function mount()
  local _12_
  do
    Dismount()
    _12_ = nil
  end
  local _13_
  do
    VehicleExit()
    _13_ = nil
  end
  local _14_
  do
    print("FLYING AREA")
    local _15_
    do
      mountByUsage("FLYING_SHOWOFF")
      _15_ = nil
    end
    local _16_
    do
      mountByUsage("FLYING_PASSENGER")
      _16_ = nil
    end
    local function _17_()
      mountByUsage("FLYING")
      return nil
    end
    _14_ = cond(isAlternativeMountRequested(), _15_, IsInGroup(), _16_, "else", _17_())
  end
  local _18_
  do
    mountByUsage("FLYING")
    _18_ = nil
  end
  local function _19_()
    mountByUsage("WATER")
    return nil
  end
  local _20_
  do
    mountByUsage("GROUND_SHOWOFF")
    _20_ = nil
  end
  local function _21_()
    mountByUsage("GROUND_PASSENGER")
    return nil
  end
  local _22_
  do
    mountByUsage("GROUND_SHOWOFF")
    _22_ = nil
  end
  local function _23_()
    mountByUsage("GROUND")
    return nil
  end
  return cond(IsMounted(), _12_, UnitUsingVehicle("player"), _13_, IsOutdoors(), cond((isActuallyFlyableArea() and not IsSubmerged()), _14_, IsSubmerged(), cond(isAlternativeMountRequested(), _18_, "else", _19_()), "else", cond(IsInGroup(), cond(isAlternativeMountRequested(), _20_, "else", _21_()), "else", cond(isAlternativeMountRequested(), _22_, "else", _23_()))))
end
return mount
MOUNTS_BY_USAGE = {DEFAULT = {GROUND = MOUNT_IDS["Swift Razzashi Raptor"], FLYING = MOUNT_IDS["Ashes of Al'ar"], WATER = MOUNT_IDS["Sea Turtle"], GROUND_PASSENGER = MOUNT_IDS["Mekgineer's Chopper"], FLYING_PASSENGER = MOUNT_IDS["Algarian Stormrider"], GROUND_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"], FLYING_SHOWOFF = MOUNT_IDS["X-45 Heartbreaker"]}, HUNTER = {GROUND = MOUNT_IDS["Swift Razzashi Raptor"], FLYING = MOUNT_IDS["Ashes of Al'ar"], WATER = MOUNT_IDS["Sea Turtle"], GROUND_PASSENGER = MOUNT_IDS["Mekgineer's Chopper"], FLYING_PASSENGER = MOUNT_IDS["Renewed Proto-Drake"], GROUND_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"], FLYING_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"]}, PALADIN = {GROUND = MOUNT_IDS["Highlord's Golden Charger"], FLYING = MOUNT_IDS["Chaos-Forged Gryphon"], WATER = MOUNT_IDS["Sea Turtle"], GROUND_PASSENGER = MOUNT_IDS["Algarian Stormrider"], FLYING_PASSENGER = MOUNT_IDS["Algarian Stormrider"], GROUND_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"], FLYING_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"]}, SHAMAN = {GROUND = MOUNT_IDS["Swift Razzashi Raptor"], FLYING = MOUNT_IDS["Ashes of Al'ar"], WATER = MOUNT_IDS["Sea Turtle"], GROUND_PASSENGER = MOUNT_IDS["Algarian Stormrider"], FLYING_PASSENGER = MOUNT_IDS["Algarian Stormrider"], GROUND_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"], FLYING_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"]}, PRIEST = {GROUND = MOUNT_IDS["Swift Razzashi Raptor"], FLYING = MOUNT_IDS["Ashes of Al'ar"], WATER = MOUNT_IDS["Sea Turtle"], GROUND_PASSENGER = MOUNT_IDS["Swift Razzashi Raptor"], FLYING_PASSENGER = MOUNT_IDS["Swift Razzashi Raptor"], GROUND_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"], FLYING_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"]}, MAGE = {GROUND = MOUNT_IDS["Celestial Steed"], FLYING = MOUNT_IDS["Celestial Steed"], WATER = MOUNT_IDS["Sea Turtle"], GROUND_PASSENGER = MOUNT_IDS["Celestial Steed"], FLYING_PASSENGER = MOUNT_IDS["Celestial Steed"], GROUND_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"], FLYING_SHOWOFF = MOUNT_IDS["Swift Razzashi Raptor"]}}
BINDINGS = {GLOBAL = {{"ALT-CTRL-END", "command", "SLACKWISETWEAKS_RELOADUI"}, {"ALT-CTRL-`", "command", "FOCUSTARGET"}, {"ALT-`", "command", "INTERACTTARGET"}, {"W", "command", "MOVEFORWARD"}, {"A", "command", "STRAFELEFT"}, {"S", "command", "MOVEBACKWARD"}, {"D", "command", "STRAFERIGHT"}, {"ALT-A", "command", "TURNLEFT"}, {"ALT-D", "command", "TURNRIGHT"}, {"F1", "command", "ACTIONBUTTON1"}, {"F2", "command", "ACTIONBUTTON2"}, {"F3", "command", "ACTIONBUTTON3"}, {"F4", "command", "ACTIONBUTTON4"}, {"F5", "command", "ACTIONBUTTON5"}, {"F6", "command", "ACTIONBUTTON6"}, {"F7", "command", "ACTIONBUTTON7"}, {"F8", "command", "ACTIONBUTTON8"}, {"F9", "command", "ACTIONBUTTON9"}, {"F10", "command", "ACTIONBUTTON10"}, {"F11", "command", "ACTIONBUTTON11"}, {"F12", "command", "ACTIONBUTTON12"}, {"1", "command", "NONE"}, {"2", "command", "NONE"}, {"3", "command", "NONE"}, {"4", "command", "NONE"}, {"5", "command", "NONE"}, {"6", "command", "NONE"}, {"7", "command", "NONE"}, {"8", "command", "NONE"}, {"9", "command", "NONE"}, {"0", "command", "NONE"}, {"-", "command", "NONE"}, {"=", "command", "NONE"}, {"SHIFT-1", "command", "NONE"}, {"SHIFT-2", "command", "NONE"}, {"SHIFT-3", "command", "NONE"}, {"SHIFT-4", "command", "NONE"}, {"SHIFT-5", "command", "NONE"}, {"SHIFT-6", "command", "NONE"}, {"SHIFT-7", "command", "NONE"}, {"SHIFT-8", "command", "NONE"}, {"SHIFT-9", "command", "NONE"}, {"SHIFT-0", "command", "NONE"}, {"CTRL-1", "command", "NONE"}, {"CTRL-2", "command", "NONE"}, {"CTRL-3", "command", "NONE"}, {"CTRL-4", "command", "NONE"}, {"CTRL-5", "command", "NONE"}, {"CTRL-6", "command", "NONE"}, {"CTRL-7", "command", "NONE"}, {"CTRL-8", "command", "NONE"}, {"CTRL-9", "command", "NONE"}, {"CTRL-0", "command", "NONE"}, {",", "command", "NONE"}, {"ALT-CTRL-W", "command", "TOGGLEFOLLOW"}, {"E", "command", "INTERACTTARGET"}, {"SHIFT-E", "command", "INTERACTTARGET"}, {"CTRL-E", "spell", "Single-Button Assistant"}, {"ALT-E", "command", "EXTRAACTIONBUTTON1"}, {"SHIFT-R", "command", "NONE"}, {"CTRL-R", "command", "NONE"}, {"CTRL-S", "command", "NONE"}, {"ALT-CTRL-S", "spell", "Survey"}, {"H", "command", "TOGGLEGROUPFINDER"}, {"SHIFT-H", "command", "TOGGLECHARACTER4"}, {"CTRL-H", "macro", "HEARTH"}, {"ALT-CTRL-H", "macro", "HEARTH_DALARAN"}, {"ALT-H", "command", "TOGGLEUI"}, {"ALT-CTRL-L", "command", "TOGGLEACTIONBARLOCK"}, {"X", "command", "SITORSTAND"}, {"SHIFT-X", "macro", "MOUNT_BEAR"}, {"CTRL-SHIFT-X", "macro", "MOUNT_DINO"}, {"ALT-X", "command", "SITORSTAND"}, {"ALT-CTRL-X", "command", "TOGGLERUN"}, {"ALT-CTRL-SHIFT-X", "spell", "Switch Flight Style"}, {"ALT-CTRL-SHIFT-V", "spell", "Recuperate"}, {"ALT-CTRL-SHIFT-M", "spell", "Switch Flight Style"}, {"ALT-C", "command", "SLACKWISETWEAKS_BEST_MANA_POTION"}, {"ALT-V", "command", "SLACKWISETWEAKS_BEST_HEALING_POTION"}, {"ALT-CTRL-V", "command", "SLACKWISETWEAKS_BEST_BANDAGE"}, {"V", "command", "NONE"}, {"SHIFT-V", "command", "NONE"}, {"CTRL-V", "command", "NONE"}, {"B", "command", "INTERACTTARGET"}, {"SHIFT-B", "command", "OPENALLBAGS"}, {"CTRL-B", "command", "TOGGLECHARACTER0"}, {"ALT-CTRL-B", "command", "SLACKWISETWEAKS_SETBINDINGS"}, {"ALT-B", "command", "TOGGLESHEATH"}, {"CTRL-M", "command", "TOGGLEMUSIC"}, {"ALT-M", "command", "TOGGLESOUND"}, {"ALT-CTRL-M", "command", "SLACKWISETWEAKS_RESTART_SOUND"}, {"SHIFT-UP", "command", "NONE"}, {"SHIFT-DOWN", "command", "NONE"}, {"SHIFT-ENTER", "command", "REPLY"}, {"CTRL-ENTER", "command", "REPLY2"}, {"SHIFT-SPACE", "command", "SLACKWISETWEAKS_MOUNT"}, {"SHIFT-HOME", "command", "SETVIEW1"}, {"HOME", "command", "SETVIEW2"}, {"END", "command", "SETVIEW3"}, {"PRINTSCREEN", "command", "SCREENSHOT"}, {"NUMLOCK", "command", "NONE"}, {"NUMPAD0", "command", "RAIDTARGET8"}, {"NUMPAD1", "command", "RAIDTARGET7"}, {"NUMPAD2", "command", "RAIDTARGET2"}, {"NUMPAD3", "command", "RAIDTARGET4"}, {"NUMPAD4", "command", "RAIDTARGET6"}, {"NUMPAD5", "command", "RAIDTARGET5"}, {"NUMPAD6", "command", "RAIDTARGET1"}, {"NUMPAD7", "command", "RAIDTARGET3"}, {"NUMPADDECIMAL", "command", "RAIDTARGETNONE"}, {"BUTTON3", "command", "TOGGLEAUTORUN"}, {"ALT-BUTTON2", "command", "TOGGLEPINGLISTENER"}, {"SHIFT-MOUSEWHEELUP", "command", "NONE"}, {"SHIFT-MOUSEWHEELDOWN", "command", "NONE"}}, RETAIL = {HUNTER = {CLASS = {{"F8", "spell", "Call Pet 1"}, {"F9", "spell", "Call Pet 2"}, {"F10", "spell", "Call Pet 3"}, {"F11", "spell", "Call Pet 4"}, {"F12", "spell", "Call Pet 5"}, {"`", "macro", "."}, {"1", "spell", "Explosive Shot"}, {"2", "spell", "Hunter's Mark"}, {"ALT-1", "macro", "MD"}, {"3", "spell", "Multi-Shot"}, {"SHIFT-3", "spell", "Explosive Shot"}, {"4", "spell", "Arcane Shot"}, {"Q", "macro", "PetControl"}, {"CTRL-Q", "command", "BONUSACTIONBUTTON7"}, {"CTRL-SHIFT-Q", "command", "BONUSACTIONBUTTON1"}, {"ALT-CTRL-Q", "macro", "PetToggle"}, {"ALT-SHIFT-Q", "spell", "Play Dead"}, {"ALT-CTRL-SHIFT-Q", "spell", "Eyes of the Beast"}, {"SHIFT-E", "spell", "Bursting Shot"}, {"ALT-CTRL-E", "macro", "ChainEagle"}, {"T", "macro", "Traps"}, {"F", "spell", "Concussive Shot"}, {"SHIFT-F", "spell", "Counter Shot"}, {"CTRL-F", "spell", "Intimidation"}, {"ALT-F", "spell", "Tranquilizing Shot"}, {"ALT-CTRL-F", "spell", "Scare Beast"}, {"ALT-CTRL-SHIFT-F", "spell", "Fireworks"}, {"Z", "spell", "Aspect of the Cheetah"}, {"SHIFT-Z", "spell", "Camouflage"}, {"ALT-SHIFT-Z", "spell", "Aspect of the Chameleon"}, {"CTRL-Z", "spell", "Feign Death"}, {"CTRL-SHIFT-Z", "macro", "Shadowmeld"}, {"C", "spell", ""}, {"SHIFT-C", "spell", ""}, {"CTRL-C", "macro", ""}, {"B", "spell", "Fetch"}, {"V", "spell", "Exhilaration"}, {"SHIFT-V", "spell", "Survival of the Fittest"}, {"CTRL-V", "spell", "Aspect of the Turtle"}, {"CTRL-SPACE", "spell", "Disengage"}, {"BUTTON4", "macro", "TrapsCursor"}, {"BUTTON5", "macro", "PetAttackCursor"}}, MARKSMANSHIP = {{"SHIFT-2", "spell", "Aimed Shot"}, {"CTRL-3", "spell", "Barrage"}, {"ALT-3", "spell", "Salvo"}, {"SHIFT-4", "spell", "Aimed Shot"}, {"5", "spell", "Kill Shot"}, {"SHIFT-5", "spell", "Sniper Shot"}, {"R", "spell", "Steady Shot"}, {"SHIFT-R", "spell", "Rapid Fire"}, {"G", "macro", "Trueshot!"}}, SURVIVAL = {{"1", "macro", "Serpent Sting"}, {"2", "spell", "Kill Command"}, {"4", "spell", "Shrapnel Bomb"}, {"5", "spell", "Kill Shot"}, {"E", "spell", "Raptor Strike"}, {"SHIFT-E", "spell", "Butchery"}, {"R", "spell", "Harpoon"}, {"F", "spell", "Wing Clip"}}}, PALADIN = {CLASS = {{"1", "command", "ACTIONBUTTON1"}, {"2", "command", "ACTIONBUTTON2"}, {"3", "command", "ACTIONBUTTON3"}, {"4", "command", "ACTIONBUTTON4"}, {"5", "command", "ACTIONBUTTON5"}, {"6", "command", "ACTIONBUTTON6"}, {"7", "command", "ACTIONBUTTON7"}, {"8", "command", "ACTIONBUTTON8"}, {"9", "command", "ACTIONBUTTON9"}, {"10", "command", "ACTIONBUTTON10"}, {"11", "command", "ACTIONBUTTON11"}, {"12", "command", "ACTIONBUTTON12"}, {"F8", "macro", "SUMMONPET"}, {"F9", "command", "SHAPESHIFTBUTTON1"}, {"F10", "command", "SHAPESHIFTBUTTON2"}, {"F11", "command", "SHAPESHIFTBUTTON3"}, {"F12", "command", "SHAPESHIFTBUTTON4"}, {"CTRL-SPACE", "spell", "Divine Steed"}, {"BUTTON4", "macro", "MOUSE4"}, {"BUTTON5", "macro", "MOUSE5"}, {"ALT-CTRL-SHIFT-X", "spell", "Contemplation"}, {"1", "spell", "Word of Glory"}, {"CTRL-1", "spell", "Lay on Hands"}, {"2", "spell", "Flash of Light"}, {"4", "spell", "Judgment"}, {"5", "spell", "Hammer of Wrath"}, {"Q", "spell", "Shield of the Righteous"}, {"ALT-Q", "spell", "Hand of Reckoning"}, {"E", "spell", "Crusader Strike"}, {"T", "macro", "BLESST"}, {"F", "spell", "Rebuke"}, {"SHIFT-F", "spell", "Hammer of Justice"}, {"CTRL-F", "spell", "Repentance"}, {"G", "macro", "WINGS"}, {"Z", "macro", "FREEDOM"}, {"SHIFT-Z", "spell", "Will to Survive"}, {"ALT-Z", "macro", "PVP_TRINKET"}, {"ALT-CTRL-Z", "macro", "REZ"}, {"C", "spell", "Consecration"}, {"SHIFT-C", "spell", "Divine Toll"}, {"V", "macro", "VITALITY"}, {"SHIFT-V", "spell", "Divine Shield"}, {"CTRL-SHIFT-V", "macro", "BOP_SELF"}, {"CTRL-V", "macro", "LAY_SELF"}}, HOLY = {{"`", "spell", "Barrier of Faith"}, {"SHIFT-1", "spell", "Cleanse"}, {"SHIFT-2", "spell", "Holy Light"}, {"3", "spell", "Light of Dawn"}, {"R", "macro", "SHOCK"}, {"SHIFT-R", "spell", "Holy Prism"}, {"SHIFT-G", "spell", "Aura Mastery"}, {"ALT-CTRL-SHIFT-Z", "spell", "Absolution"}, {"CTRL-F", "spell", "Blinding Light"}, {"C", "spell", "Consecration"}, {"CTRL-C", "macro", "BEACON_SELF"}}, PROTECTION = {{"SHIFT-1", "spell", "Cleanse Toxins"}, {"SHIFT-Q", "spell", "Bastion of Light"}, {"3", "spell", "Avenger's Shield"}, {"R", "spell", "Holy Bulwark"}, {"T", "spell", "Hand of Reckoning"}, {"CTRL-C", "spell", "Eye of Tyr"}}, RETRIBUTION = {{"SHIFT-1", "spell", "Cleanse Toxins"}, {"3", "spell", "Wake of Ashes"}, {"Q", "macro", "Q"}, {"SHIFT-Q", "spell", "Templar's Verdict"}, {"R", "spell", "Blade of Justice"}, {"CTRL-Z", "macro", "SANC_SELF"}, {"C", "spell", "Divine Storm"}, {"CTRL-C", "macro", "RECKON_SELF"}}}, DRUID = {CLASS = {{"BUTTON4", "macro", "MOUSE4"}, {"SHIFT-SPACE", "macro", "TRAVEL"}, {"CTRL-SPACE", "spell", "Wild Charge"}, {"CTRL-SHIFT-SPACE", "command", "SLACKWISETWEAKS_MOUNT"}, {"SHIFT-H", "spell", "Dreamwalk"}, {"1", "spell", "Rejuvenation"}, {"SHIFT-1", "spell", "Rejuvenation"}, {"2", "spell", "Regrowth"}, {"SHIFT-2", "spell", "Wild Growth"}, {"3", "spell", "Sunfire"}, {"SHIFT-3", "spell", "Starfire"}, {"4", "spell", "Moonfire"}, {"SHIFT-4", "spell", "Wrath"}, {"CTRL-4", "spell", "Starsurge"}, {"5", "spell", "Starsurge"}, {"Q", "spell", "Ferocious Bite"}, {"E", "macro", "SINGLE_TARGET"}, {"R", "macro", "AOE"}, {"SHIFT-R", "spell", "Swipe"}, {"CTRL-R", "spell", ""}, {"ALT-R", "spell", "Starfire"}, {"T", "macro", "T"}, {"F", "macro", "INTERRUPT"}, {"SHIFT-F", "spell", "Entangling Roots"}, {"CTRL-F", "spell", "Incapacitating Roar"}, {"ALT-CTRL-F", "spell", "Mass Entanglement"}, {"CTRL-G", "macro", "ULT"}, {"Z", "spell", "Dash"}, {"SHIFT-Z", "spell", "Stampeding Roar"}, {"CTRL-Z", "spell", "Shadowmeld"}, {"ALT-CTRL-Z", "macro", "REZ"}, {"X", "macro", "X"}, {"C", "macro", "CAT"}, {"SHIFT-C", "spell", "Prowl"}, {"V", "macro", "BEAR"}, {"SHIFT-V", "spell", "Barkskin"}, {"CTRL-V", "spell", "Renewal"}}, BALANCE = {{"CTRL-3", "spell", "Starfall"}, {"5", "spell", "Fury of Elune"}, {"SHIFT-5", "spell", "Wild Mushroom"}, {"X", "macro", "X"}, {"G", "spell", "Celestial Alignment"}, {"SHIFT-G", "spell", "Celestial Alignment"}}, FERAL = {}, GUARDIAN = {}, RESTORATION = {{"`", "spell", "Swiftmend"}, {"SHIFT-1", "spell", "Lifebloom"}, {"G", "spell", "Grove Guardians"}, {"SHIFT-G", "spell", "Flourish"}, {"CTRL-G", "spell", "Incarnation: Tree of Life"}, {"ALT-CTRL-G", "spell", "Tranquility"}, {"ALT-CTRL-V", "spell", "Tranquility"}}}, MAGE = {CLASS = {{"E", "spell", "Frostbolt"}, {"R", "spell", "Cone of Cold"}, {"T", "spell", "Fire Blast"}, {"F", "spell", "Frost Nova"}, {"SHIFT-F", "spell", "Counterspell"}, {"CTRL-F", "spell", "Polymorph"}, {"Z", "spell", "Invisibility"}, {"X", "spell", "Slow Fall"}, {"C", "spell", "Arcane Explosion"}, {"SHIFT-V", "spell", "Ice Cold"}, {"CTRL-V", "spell", "Mass Barrier"}, {"CTRL-SPACE", "spell", "Blink"}, {"ALT-CTRL-Z", "spell", "Shadowmeld"}}, ARCANE = {}, FIRE = {}, FROST = {{"BUTTON4", "macro", "BLIZZ_CURSOR"}, {"3", "spell", "Comet Storm"}, {"4", "spell", "Ice Lance"}, {"5", "spell", "Flurry"}, {"Q", "spell", "Frozen Orb"}, {"V", "spell", "Ice Barrier"}}}, SHAMAN = {CLASS = {{"1", "spell", "Flame Shock"}, {"2", "spell", "Healing Surge"}, {"SHIFT-2", "spell", "Healing Surge"}, {"3", "spell", "Earth Shock"}, {"4", "spell", "Frost Shock"}, {"5", "spell", "Primordial Wave"}, {"Q", "macro", "CHAIN"}, {"E", "spell", "Lightning Bolt"}, {"ALT-E", "spell", "Primal Strike"}, {"R", "spell", "Lava Burst"}, {"SHIFT-R", "spell", "Lightning Shield"}, {"CTRL-R", "spell", "Water Shield"}, {"T", "spell", "Healing Stream Totem"}, {"ALT-T", "spell", "Healing Tide Totem"}, {"SHIFT-T", "spell", "Spirit Link Totem"}, {"CTRL-T", "spell", "Earthbind Totem"}, {"F", "spell", "Wind Shear"}, {"SHIFT-F", "spell", "Wind Shear"}, {"CTRL-F", "spell", "Hex"}, {"G", "spell", "Spiritwalker's Grace"}, {"SHIFT-G", "spell", "Ancestral Guidance"}, {"CTRL-G", "spell", "Ascendance"}, {"SHIFT-CTRL-G", "spell", "Heroism"}, {"Z", "spell", "Ghost Wolf"}, {"SHIFT-Z", "spell", "Wind Rush Totem"}, {"CTRL-Z", "spell", "Stoneform"}, {"C", "spell", "Thunderstorm"}, {"SHIFT-C", "macro", "RAIN_SELF"}, {"V", "spell", "Astral Shift"}, {"CTRL-C", "spell", "Stone Bulwark Totem"}, {"CTRL-SPACE", "spell", "Gust of Wind"}, {"ALT-CTRL-Z", "spell", "Ancestral Spirit"}}, ELEMENTAL = {{"BUTTON4", "macro", "MOUSE4_ELE"}}, ENHANCEMENT = {}, RESTORATION = {{"BUTTON4", "macro", "MOUSE4_RESTO"}, {"1", "spell", "Riptide"}, {"ALT-1", "spell", "Purify Spirit"}, {"SHIFT-2", "spell", "Healing Wave"}}}, PRIEST = {CLASS = {{"1", "spell", "Renew"}, {"2", "spell", "Flash Heal"}, {"3", "spell", "Divine Star"}, {"4", "spell", "Shadow Word: Pain"}, {"Q", "spell", ""}, {"SHIFT-Q", "spell", "Shadowfiend"}, {"E", "spell", "Smite"}, {"T", "spell", "Dispel Magic"}, {"SHIFT-T", "spell", "Power Word: Fortitude"}, {"CTRL-T", "spell", "Power Word: Shield"}, {"F", "macro", "SOOTHE_SELF"}, {"SHIFT-F", "spell", "Psychic Scream"}, {"CTRL-F", "spell", "Dominate Mind"}, {"ALT-CTRL-F", "spell", "Mind Vision"}, {"G", "macro", "ULT"}, {"SHIFT-G", "spell", "Power Infusion"}, {"Z", "macro", "FEATHER_SELF"}, {"SHIFT-Z", "spell", "Fade"}, {"CTRL-Z", "spell", "Shadowmeld"}, {"ALT-CTRL-Z", "macro", "REZ"}, {"X", "macro", "LEVITATE_SELF"}, {"C", "spell", "Holy Nova"}, {"CTRL-C", "spell", "Halo"}, {"V", "spell", "Desperate Prayer"}, {"SHIFT-V", "spell", "Fade"}, {"CTRL-SPACE", "spell", "Leap of Faith"}, {"BUTTON4", "macro", "MOUSE4"}}, DISCIPLINE = {}, HOLY = {{"1", "spell", "Holy Word: Serenity"}, {"SHIFT-1", "spell", "Renew"}, {"SHIFT-2", "spell", "Heal"}, {"5", "spell", "Holy Word: Chastise"}, {"R", "spell", "Holy Fire"}, {"CTRL-SHIFT-G", "spell", "Symbol of Hope"}, {"SHIFT-C", "spell", "SANCTIFY_SELF"}, {"CTRL-V", "macro", "GUARD_SELF"}}, SHADOW = {}}, WARRIOR = {CLASS = {{"`", "spell", ""}, {"1", "spell", ""}, {"2", "spell", ""}, {"4", "spell", "Heroic Throw"}, {"5", "spell", "Champion's Spear"}, {"SHIFT-2", "spell", ""}, {"Q", "spell", "Shield Slam"}, {"SHIFT-Q", "spell", "Shield Block"}, {"CTRL-Q", "spell", "Shield Charge"}, {"R", "spell", ""}, {"E", "spell", "Hamstring"}, {"T", "spell", "Taunt"}, {"F", "spell", "Pummel"}, {"G", "spell", "Avatar"}, {"SHIFT-F", "spell", "Storm Bolt"}, {"CTRL-F", "spell", ""}, {"Z", "spell", "Charge"}, {"SHIFT-Z", "spell", "Shield Charge"}, {"CTRL-Z", "spell", "Shadowmeld"}, {"ALT-CTRL-Z", "spell", "Shadowmeld"}, {"X", "spell", ""}, {"C", "spell", "Thunder Clap"}, {"SHIFT-V", "spell", ""}, {"CTRL-V", "spell", ""}, {"CTRL-SPACE", "spell", "Heroic Leap"}, {"BUTTON4", "macro", "MOUSE4"}}, ARMS = {}, FURY = {}, PROTECTION = {{"V", "spell", "Shield Wall"}}}}, CLASSIC = {DRUID = {{"1", "command", "ACTIONBUTTON1"}, {"2", "command", "ACTIONBUTTON2"}, {"3", "command", "ACTIONBUTTON3"}, {"4", "command", "ACTIONBUTTON4"}, {"5", "command", "ACTIONBUTTON5"}, {"6", "command", "ACTIONBUTTON6"}, {"7", "command", "ACTIONBUTTON7"}, {"8", "command", "ACTIONBUTTON8"}, {"9", "command", "ACTIONBUTTON9"}, {"10", "command", "ACTIONBUTTON10"}, {"11", "command", "ACTIONBUTTON11"}, {"12", "command", "ACTIONBUTTON12"}}, PALADIN = {{"1", "command", "ACTIONBUTTON1"}, {"2", "command", "ACTIONBUTTON2"}, {"3", "command", "ACTIONBUTTON3"}, {"4", "command", "ACTIONBUTTON4"}, {"5", "command", "ACTIONBUTTON5"}, {"6", "command", "ACTIONBUTTON6"}, {"7", "command", "ACTIONBUTTON7"}, {"8", "command", "ACTIONBUTTON8"}, {"9", "command", "ACTIONBUTTON9"}, {"10", "command", "ACTIONBUTTON10"}, {"11", "command", "ACTIONBUTTON11"}, {"12", "command", "ACTIONBUTTON12"}, {"E", "macro", "!ENGAGE"}, {"F9", "command", "SHAPESHIFTBUTTON1"}, {"F10", "command", "SHAPESHIFTBUTTON2"}, {"F11", "command", "SHAPESHIFTBUTTON3"}, {"F12", "command", "SHAPESHIFTBUTTON4"}, {"`", "macro", "!STOP"}, {"BUTTON4", "macro", "MOUSE4"}, {"BUTTON5", "macro", "MOUSE5"}, {"Z", "spell", "Divine Protection"}, {"ALT-Z", "spell", "Perception"}, {"4", "spell", "Judgement"}, {"5", "spell", "Hammer of Wrath"}, {"C", "spell", "Consecration"}, {"SHIFT-C", "spell", "Divine Storm"}, {"3", "spell", "Divine Storm"}, {"Q", "spell", "Holy Light"}, {"ALT-Q", "spell", "Purify"}, {"CTRL-Z", "spell", "Redemption"}, {"G", "spell", "Blessing of Protection"}, {"SHIFT-G", "spell", "Lay on Hands"}, {"F", "spell", "Rebuke"}, {"SHIFT-F", "spell", "Hammer of Justice"}, {"T", "spell", "Blessing of Might"}, {"SHIFT-T", "spell", "Blessing of Wisdom"}, {"R", "spell", "Seal of Righteousness"}, {"SHIFT-R", "spell", "Seal of the Crusader"}, {"ALT-Z", "item", "Insignia of the Alliance"}}, PRIEST = {{"1", "command", "ACTIONBUTTON1"}, {"2", "command", "ACTIONBUTTON2"}, {"3", "command", "ACTIONBUTTON3"}, {"4", "command", "ACTIONBUTTON4"}, {"5", "command", "ACTIONBUTTON5"}, {"6", "command", "ACTIONBUTTON6"}, {"7", "command", "ACTIONBUTTON7"}, {"8", "command", "ACTIONBUTTON8"}, {"9", "command", "ACTIONBUTTON9"}, {"10", "command", "ACTIONBUTTON10"}, {"11", "command", "ACTIONBUTTON11"}, {"12", "command", "ACTIONBUTTON12"}, {"`", "macro", "!STOP"}, {"1", "spell", "Renew"}, {"2", "spell", "Lesser Heal"}, {"4", "spell", "Shadow Word: Pain"}, {"Q", "spell", "Power Word: Shield"}, {"E", "macro", "!ENGAGE"}, {"T", "spell", "Power Word: Fortitude"}, {"Z", "spell", "Fade"}, {"SHIFT-Z", "spell", "Shadowmeld"}, {"CTRL-Z", "spell", "Fade"}, {"V", "macro", "SHIELD_SELF"}}}}
return nil
