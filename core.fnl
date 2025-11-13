(setfenv 1 (_G.SlackwiseTweaks))

;; General API Documentation (see comments in original Lua)

;; Event Handlers
(fn Self:OnEnable []
  (setCVars)
  (. self :RegisterEvent "MERCHANT_SHOW")
  (. self :RegisterEvent "PLAYER_ENTERING_WORLD")
  (. self :RegisterEvent "UNIT_AURA")
  (. self :RegisterEvent "PLAYER_REGEN_ENABLED")
  ;; (. self :RegisterEvent "PLAYER_REGEN_DISABLED")
  (. self :RegisterEvent "ACTIVE_TALENT_GROUP_CHANGED")
  (. self :RegisterEvent "BAG_UPDATE_DELAYED")
  ;; (. self :RegisterEvent "NAME_PLATE_UNIT_ADDED")
  ;; (. self :RegisterEvent "VIGNETTE_MINIMAP_UPDATED")
)

(fn Self:OnDisable [])

(fn Self:BAG_UPDATE_DELAYED []
  (bindBestUseItems))

(fn Self:PLAYER_ENTERING_WORLD [eventName isLogin isReload]
  (setupEkil)
  (handleDragonriding))

(fn Self:MERCHANT_SHOW [eventName]
  (repairAllItems)
  (sellGreyItems))

(fn Self:PLAYER_REGEN_ENABLED [eventName]
  (handleDragonriding)
  (runAfterCombatActions))

(fn Self:PLAYER_REGEN_DISABLED [eventName])

(fn Self:ACTIVE_TALENT_GROUP_CHANGED [currentSpecID previousSpecID]
  (setBindings))

(fn Self:UNIT_AURA [eventName unitTarget updateInfo]
  (when (= unitTarget "player")
    (handleDragonriding)))

(local afterCombatActions [])
(fn runAfterCombat [f]
  (table.insert afterCombatActions f))

(fn runAfterCombatActions []
  (while (> (length afterCombatActions) 0)
    (when (not (InCombatLockdown))
      ((table.remove afterCombatActions)))))

(fn inVehicle []
  (UnitHasVehicleUI "player"))

(fn isEkil []
  (= (getBattletag) "ekil#1612"))

(fn getClassName []
  (select 2 (UnitClass "player")))

(fn getSpecName []
  (let [specIndex (GetSpecialization)]
    (when specIndex
      (log (.. "specIndex = " (or specIndex "nil")))
      (let [[specID specName] (GetSpecializationInfo specIndex)]
        (log (.. "specID = " (or specID "nil")))
        (log (.. "specName = " (or specName "nil")))
        (when specName
          (strupper specName)))))
)

(fn setCVars []
  (SetCVar "cameraDistanceMaxZoomFactor" 2.6)
  (SetCVar "minimapTrackingShowAll" 1))

(fn repairAllItems []
  (when (CanMerchantRepair)
    (RepairAllItems)))

(local ITEM_QUALITY_GREY 0)

(fn canCollectTransmog [itemInfo]
  (if (isClassic)
    false
    (let [[itemAppearanceID sourceID] (C_TransmogCollection.GetItemInfo itemInfo)]
      (if sourceID
        (let [[_ _ _ _ isCollected _ _ _ _] (C_TransmogCollection.GetAppearanceSourceInfo sourceID)]
          (not isCollected))
        false))))

(fn sellGreyItems []
  (for [bag 0 NUM_BAG_SLOTS]
    (for [slot 0 (C_Container.GetContainerNumSlots bag)]
      (let [link (C_Container.GetContainerItemLink bag slot)]
        (when link
          (let [[_ itemLink itemQuality] (C_Item.GetItemInfo link)]
            (when (= itemQuality ITEM_QUALITY_GREY)
              (if (canCollectTransmog itemLink)
                (print (.. "[SlackwiseTweaks] Not selling transmog-able item: " itemLink))
                (C_Container.UseContainerItem bag slot)))))))))

(fn isSpellKnown [spellName]
  (let [[_ spellID] (GetSpellLink spellName)]
    (if spellID
      (IsSpellKnown spellID)
      false)))

(fn getKeyByValue [targetTable targetValue]
  (each-pair [key value targetTable]
    (when (= value targetValue)
      (return key)))
  nil)

(fn keys [targetTable]
  (let [collectedKeys []]
    (each-pair [key value targetTable]
      (table.insert collectedKeys key))
    collectedKeys))

(fn findFirstElement [targetTable kvPredicate]
  (each-pair [key value targetTable]
    (when (kvPredicate key value)
      (return [key value])))
  [nil nil])

(fn findElements [targetTable kvPredicate]
  (let [found {}]
    (each-pair [key value targetTable]
      (when (kvPredicate key value)
        (set found[key] value)))
    found))

(fn findItemsByItemIDs [itemIDs]
  (let [found []]
    (for [bag 0 NUM_BAG_SLOTS]
      (for [slot 0 (C_Container.GetContainerNumSlots bag)]
        (let [containerItemInfo (C_Container.GetContainerItemInfo bag slot)]
          (when containerItemInfo
            (let [itemName (C_Item.GetItemInfo containerItemInfo.hyperlink)]
              (when (and itemName (tContains itemIDs containerItemInfo.itemID))
                (table.insert found containerItemInfo)))))))
    found))

(fn findItemsByRegex [regex]
  (let [found []]
    (for [bag 0 NUM_BAG_SLOTS]
      (for [slot 0 (C_Container.GetContainerNumSlots bag)]
        (let [containerItemInfo (C_Container.GetContainerItemInfo bag slot)]
          (when containerItemInfo
            (let [itemName (C_Item.GetItemInfo containerItemInfo.hyperlink)]
              (when (and itemName (string.match itemName regex))
                (table.insert found containerItemInfo)))))))
    found))

(fn groupBy [array groupingFunction]
  (let [grouped {}]
    (each-pair [key value array]
      (let [[groupingKey newValue] (groupingFunction value)]
        (if grouped[value]
          (table.insert grouped[groupingKey] newValue)
          (set grouped[groupingKey] [newValue]))))
    grouped))

(fn findLargestIndex [array]
  (var largestIndex 0)
  (each-pair [key value array]
    (when (and (tonumber key) (>= key largestIndex))
      (set largestIndex key)))
  largestIndex)

(fn findParentMapByType [map uiMapType]
  (if (not map)
    nil
    (if (or (= map.mapType uiMapType) (= map.mapType Enum.UIMapType.Cosmic))
      map
      (findParentMapByType (C_Map.GetMapInfo map.parentMapID) uiMapType))))

(fn getCurrentMap []
  (C_Map.GetMapInfo (or (C_Map.GetBestMapForUnit "player") 0)))

(fn getCurrentContinent []
  (let [map (getCurrentMap)]
    (if map
      (findParentMapByType map Enum.UIMapType.Continent)
      nil)))

(fn getCurrentZone []
  (let [map (getCurrentMap)]
    (if map
      (findParentMapByType map Enum.UIMapType.Zone)
      nil)))

(fn isActuallyFlyableArea []
  (let [continent (getCurrentContinent)
        continentID (if continent continent.mapID 0)
        zone (getCurrentZone)
        zoneID (if zone zone.mapID 0)
        map (getCurrentMap)
        mapID (if map map.mapID 0)
        listedFlyableContinent (not (not (tContains ACTUALLY_FLYABLE_MAP_IDS.CONTINENTS continentID)))
        listedFlyableZone (not (not (tContains ACTUALLY_FLYABLE_MAP_IDS.ZONES zoneID)))
        listedFlyableMap (not (not (tContains ACTUALLY_FLYABLE_MAP_IDS.MAPS mapID)))
        listedNonFlyableContinent (not (not (tContains NOT_ACTUALLY_FLYABLE_MAP_IDS.CONTINENTS continentID)))
        listedNonFlyableZone (not (not (tContains NOT_ACTUALLY_FLYABLE_MAP_IDS.ZONES zoneID)))
        listedNonFlyableMap (not (not (tContains NOT_ACTUALLY_FLYABLE_MAP_IDS.MAPS mapID)))]
    (cond
      listedFlyableMap true
      listedNonFlyableMap false
      listedFlyableZone true
      listedNonFlyableZone false
      listedFlyableContinent true
      listedNonFlyableContinent false
      :else (IsFlyableArea))))

(fn printDebugMapInfo []
  (let [map (getCurrentMap)
        zone (getCurrentZone)
        continent (getCurrentContinent)
        parentMap (or (C_Map.GetMapInfo map.parentMapID) "nil")
        p (if (isDebugging) log print)]
    (p "===============================")
    (p (.. map.name ", " (or parentMap.name "nil")))
    (p (.. "Zone: " zone.name " (" zone.mapID ")"))
    (when continent
      (p (.. "Continent: " continent.name " (" continent.mapID ")")))
    (p "-------------------------------------------------------")
    (p (.. "mapID: " map.mapID))
    (p (.. "parentMapID: " map.parentMapID))
    (p (.. "mapType: " (or (getKeyByValue Enum.UIMapType map.mapType) "nil") " (" (or map.mapType "nil") ")"))
    (p (.. "Outdoor: " (tostring (IsOutdoors))))
    (p (.. "Submerged: " (tostring (IsSubmerged))))
    (p (.. "Flyable: " (tostring (IsFlyableArea))))
    (p (.. "AdvancedFlyable: " (tostring (IsAdvancedFlyableArea))))
    (p (.. "ActuallyFlyable: " (tostring (isActuallyFlyableArea))))
    (p "===============================")))

(local DRUID_RARE_MOBS [
  "Keen-eyed Cian"
  "Matriarch Keevah"
  "Moragh the Slothful"
  "Mosa Umbramane"
  "Ristar the Rabid"
  "Talthonei Ashwhisper"
])

(fn findDruidRareMobs [vignetteGUID]
  (when (not (= (getClassName) "DRUID")) (return nil))
  (log (.. "VIGNETTE ID: " vignetteGUID))
  (let [vignetteInfo (C_VignetteInfo.GetVignetteInfo vignetteGUID)]
    (when vignetteInfo
      (let [name vignetteInfo.name]
        (log (.. "VIGNETTE NAME: " (or name "")))
        (when (tContains DRUID_RARE_MOBS name)
          (foundDruidRare name))))))

(local foundDruidRares {})
(fn foundDruidRare [name]
  (let [currentUnixTimestamp (GetServerTime)
        [currentHour currentMinute] (GetGameTime)
        lastTimeFound (get foundDruidRares name)]
    (when (or (not lastTimeFound) (isTimeWithin lastTimeFound (* 5 60) (GetServerTime)))
      (set foundDruidRares[name] [currentUnixTimestamp currentHour currentMinute]))))

(fn announceFoundDruidRare [name]
  (log (.. "Found druid rare: " name))
  (SendChatMessage (.. name ".. spotted!") "CHANNEL" nil 5))

(fn isTimeWithin [originUnixTimestamp secondsToBeWithin currentUnixTimestamp]
  (>= currentUnixTimestamp (+ originUnixTimestamp (* secondsToBeWithin 1000))))

;; TODO: Update broken fishing pole right-click handler (see original Lua for details)
