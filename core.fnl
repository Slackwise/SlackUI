(fn Self.OnEnable [self] (set-cVars) (self:RegisterEvent :MERCHANT_SHOW)
  (self:RegisterEvent :PLAYER_ENTERING_WORLD)
  (self:RegisterEvent :UNIT_AURA)
  (self:RegisterEvent :PLAYER_REGEN_ENABLED)
  (self:RegisterEvent :ACTIVE_TALENT_GROUP_CHANGED)
  (self:RegisterEvent :BAG_UPDATE_DELAYED))
(fn Self.OnDisable [self])
(fn Self.BAG_UPDATE_DELAYED [self] (bind-best-use-items))
(fn Self.PLAYER_ENTERING_WORLD [self event-name is-login is-reload]
  (setup-ekil)
  (handle-dragonriding))
(fn Self.MERCHANT_SHOW [self event-name] (repair-all-items) (sell-grey-items))
(fn Self.PLAYER_REGEN_ENABLED [self event-name] (handle-dragonriding)
  (run-after-combat-actions))
(fn Self.PLAYER_REGEN_DISABLED [self event-name])
(fn Self.ACTIVE_TALENT_GROUP_CHANGED [self current-spec-iD previous-spec-iD]
  (set-bindings))
(fn Self.UNIT_AURA [self event-name unit-target update-info]
  (when (= unit-target :player) (handle-dragonriding)))
(global after-combat-actions {})
(fn run-after-combat [f] (table.insert after-combat-actions f))
(fn run-after-combat-actions []
  (while (> (length after-combat-actions) 0)
    (when (not (InCombatLockdown)) ((table.remove after-combat-actions)))))
(fn in-vehicle [] (Unit-has-vehicle-uI :player))
(fn is-ekil []
  (or (= (get-battletag) "ekil#1612") false))
(fn get-class-name [] (select 2 (Unit-class :player)))
(fn get-spec-name []
  (let [spec-index (Get-specialization)]
    (when spec-index
      (log (.. "specIndex = " (or spec-index :nil)))
      (local (spec-iD spec-name) (Get-specialization-info spec-index))
      (log (.. "specID = " (or spec-iD :nil)))
      (log (.. "specName = " (or spec-name :nil)))
      (when spec-name
        (let [___antifnl_rtns_1___ [(strupper spec-name)]]
          (lua "return (table.unpack or unpack)(___antifnl_rtns_1___)"))))
    nil))
(fn set-cVars [] (Set-cVar :cameraDistanceMaxZoomFactor 2.6)
  (Set-cVar :minimapTrackingShowAll 1))
(fn repair-all-items [] (when (Can-merchant-repair) (Repair-all-items)))
(fn can-collect-transmog [item-info]
  (when (is-classic) (lua "return false"))
  (local (item-appearance-iD source-iD)
         (C_Transmog-collection.GetItemInfo item-info))
  (when source-iD
    (local (category-iD visual-iD can-enchant icon is-collected item-link
                        transmog-link unknown1 item-sub-type-index)
           (C_Transmog-collection.GetAppearanceSourceInfo source-iD))
    (let [___antifnl_rtn_1___ (not is-collected)]
      (lua "return ___antifnl_rtn_1___")))
  false)
(global ITEM_QUALITY_GREY 0)
(fn sell-grey-items []
  (for [bag 0 NUM_BAG_SLOTS]
    (for [slot 0 (C_Container.GetContainerNumSlots bag)]
      (local link (C_Container.GetContainerItemLink bag slot))
      (when link
        (local (item-name item-link item-quality) (C_Item.GetItemInfo link))
        (when (= item-quality ITEM_QUALITY_GREY)
          (if (can-collect-transmog item-link)
              (print (.. "[SlackwiseTweaks] Not selling transmog-able item: "
                         item-link))
              (C_Container.UseContainerItem bag slot)))))))
(fn is-spell-known [spell-name]
  (let [(link spell-iD) (Get-spell-link spell-name)]
    (when spell-iD
      (let [___antifnl_rtns_1___ [(Is-spell-known spell-iD)]]
        (lua "return (table.unpack or unpack)(___antifnl_rtns_1___)")))
    false))
(fn get-key-by-value [target-table target-value]
  (each [key value (pairs target-table)]
    (when (= value target-value) (lua "return key")))
  nil)
(fn keys [target-table]
  (let [collected-keys {}]
    (each [key value (pairs target-table)] (table.insert collected-keys key))
    collected-keys))
(fn find-first-element [target-table kv-predicate]
  (each [key value (pairs target-table)]
    (when (kv-predicate key value) (lua "return key, value")))
  (values nil nil))
(fn find-elements [target-table kv-predicate]
  (let [found {}]
    (each [key value (pairs target-table)]
      (when (kv-predicate key value) (tset found key value)))
    found))
(fn find-items-by-item-iDs [item-iDs]
  (let [found {}]
    (for [bag 0 NUM_BAG_SLOTS]
      (for [slot 0 (C_Container.GetContainerNumSlots bag)]
        (local container-item-info (C_Container.GetContainerItemInfo bag slot))
        (when container-item-info
          (local item-name (C_Item.GetItemInfo container-item-info.hyperlink))
          (when (and item-name (t-contains item-iDs container-item-info.itemID))
            (table.insert found container-item-info)))))
    found))
(fn find-items-by-regex [regex]
  (let [found {}]
    (for [bag 0 NUM_BAG_SLOTS]
      (for [slot 0 (C_Container.GetContainerNumSlots bag)]
        (local container-item-info (C_Container.GetContainerItemInfo bag slot))
        (when container-item-info
          (local item-name (C_Item.GetItemInfo container-item-info.hyperlink))
          (when (and item-name (string.match item-name regex))
            (table.insert found container-item-info)))))
    found))
(fn group-by [array grouping-function]
  (let [grouped {}]
    (each [key value (pairs array)]
      (local (grouping-key new-value) (grouping-function value))
      (if (. grouped value) (table.insert (. grouped grouping-key) new-value)
          (tset grouped grouping-key [new-value])))
    grouped))
(fn find-largest-index [array]
  (var largest-index 0)
  (each [key value (pairs array)]
    (when (and (tonumber key) (>= key largest-index)) (set largest-index key)))
  largest-index)
(fn find-parent-map-by-type [map ui-map-type]
  (when (not map) (lua "return nil"))
  (when (or (= map.mapType ui-map-type) (= map.mapType Enum.UIMapType.Cosmic))
    (lua "return map"))
  (find-parent-map-by-type (C_Map.GetMapInfo map.parentMapID) ui-map-type))
(fn get-current-map []
  (C_Map.GetMapInfo (or (C_Map.GetBestMapForUnit :player) 0)))
(fn get-current-continent []
  (let [map (get-current-map)]
    (when map
      (let [___antifnl_rtns_1___ [(find-parent-map-by-type map
                                                           Enum.UIMapType.Continent)]]
        (lua "return (table.unpack or unpack)(___antifnl_rtns_1___)")))
    nil))
(fn get-current-zone []
  (let [map (get-current-map)]
    (when map
      (let [___antifnl_rtns_1___ [(find-parent-map-by-type map
                                                           Enum.UIMapType.Zone)]]
        (lua "return (table.unpack or unpack)(___antifnl_rtns_1___)")))
    nil))
(fn is-actually-flyable-area []
  (let [continent (get-current-continent)
        continent-iD (or (and continent continent.mapID) 0)
        zone (get-current-zone)
        zone-iD (or (and zone zone.mapID) 0)
        map (get-current-map)
        map-iD (or (and map map.mapID) 0)
        listed-flyable-continent (not (not (t-contains ACTUALLY_FLYABLE_MAP_IDS.CONTINENTS
                                                       continent-iD)))
        listed-flyable-zone (not (not (t-contains ACTUALLY_FLYABLE_MAP_IDS.ZONES
                                                  zone-iD)))
        listed-flyable-map (not (not (t-contains ACTUALLY_FLYABLE_MAP_IDS.MAPS
                                                 map-iD)))
        listed-non-flyable-continent (not (not (t-contains NOT_ACTUALLY_FLYABLE_MAP_IDS.CONTINENTS
                                                           continent-iD)))
        listed-non-flyable-zone (not (not (t-contains NOT_ACTUALLY_FLYABLE_MAP_IDS.ZONES
                                                      zone-iD)))
        listed-non-flyable-map (not (not (t-contains NOT_ACTUALLY_FLYABLE_MAP_IDS.MAPS
                                                     map-iD)))]
    (when listed-flyable-map (lua "return true"))
    (when listed-non-flyable-map (lua "return false"))
    (when listed-flyable-zone (lua "return true"))
    (when listed-non-flyable-zone (lua "return false"))
    (when listed-flyable-continent (lua "return true"))
    (when listed-non-flyable-continent (lua "return false"))
    (Is-flyable-area)))
(fn print-debug-map-info []
  (let [map (get-current-map)
        zone (get-current-zone)
        continent (get-current-continent)
        parent-map (or (C_Map.GetMapInfo map.parentMapID) :nil)]
    (if (is-debugging) (global p log) (global p print))
    (p "===============================")
    (p (.. map.name ", " (or parent-map.name :nil)))
    (p (.. "Zone: " zone.name " (" zone.mapID ")"))
    (when continent
      (p (.. "Continent: " continent.name " (" continent.mapID ")")))
    (p "-------------------------------------------------------")
    (p (.. "mapID: " map.mapID))
    (p (.. "parentMapID: " map.parentMapID))
    (p (.. "mapType: " (or (get-key-by-value Enum.UIMapType map.mapType) :nil)
           " (" (or map.mapType :nil) ")"))
    (p (.. "Outdoor: " (tostring (Is-outdoors))))
    (p (.. "Submerged: " (tostring (Is-submerged))))
    (p (.. "Flyable: " (tostring (Is-flyable-area))))
    (p (.. "AdvancedFlyable: " (tostring (Is-advanced-flyable-area))))
    (p (.. "ActuallyFlyable: " (tostring (is-actually-flyable-area))))
    (p "===============================")))
(global DRUID_RARE_MOBS ["Keen-eyed Cian"
                         "Matriarch Keevah"
                         "Moragh the Slothful"
                         "Mosa Umbramane"
                         "Ristar the Rabid"
                         "Talthonei Ashwhisper"])
(fn find-druid-rare-mobs [vignette-gUID]
  (when (not= (get-class-name) :DRUID) (lua "return "))
  (log (.. "VIGNETTE ID: " vignette-gUID))
  (local vignette-info (C_Vignette-info.GetVignetteInfo vignette-gUID))
  (when (not vignette-info) (lua "return "))
  (local name vignette-info.name)
  (log (.. "VIGNETTE NAME: " (or name "")))
  (when (t-contains DRUID_RARE_MOBS name) (found-druid-rare name)))
(global found-druid-rares {})
(fn found-druid-rare [name]
  (let [current-unix-timestamp (Get-server-time)
        (current-hour current-minute) (Get-game-time)
        last-time-found (. found-druid-rares name)]
    (when (or (not last-time-found)
              (is-time-within last-time-found (* 5 60) (Get-server-time)))
      (tset found-druid-rares name
            [current-unix-timestamp current-hour current-minute]))))
(fn announce-found-druid-rare [name] (log (.. "Found druid rare: " name))
  (Send-chat-message (name ".. spotted!") :CHANNEL nil 5))
(fn is-time-within [origin-unix-timestamp
                       seconds-to-be-within
                       current-unix-timestamp]
  (>= current-unix-timestamp
      (+ origin-unix-timestamp (* seconds-to-be-within 1000))))	