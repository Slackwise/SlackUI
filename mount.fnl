(fn handle-dragonriding []
  (when (is-tester)
    (if (is-dragonriding) (bind-dragonriding) (unbind-dragonriding))))
(var is-dragonriding-bound false)
(fn bind-dragonriding []
  (when (and (not (InCombatLockdown)) (not is-dragonriding-bound))
    (Set-override-binding-spell Self.frame true :BUTTON3 "Skyward Ascent")
    (Set-override-binding-spell Self.frame true :SHIFT-BUTTON3 "Surge Forward")
    (Set-override-binding-spell Self.frame true :CTRL-BUTTON3 "Whirling Surge")
    (Set-override-binding-spell Self.frame true :BUTTON5 "Aerial Halt")
    (Set-override-binding-spell Self.frame true :SHIFT-X "Second Wind")
    (Set-override-binding-spell Self.frame true :CTRL-X "Bronze Timelock")
    (if (= (GetClassName) :DRUID)
        (SetOverrideBindingMacro Self.frame true :X :X)
        (SetOverrideBindingSpell Self.frame true :X "Aerial Halt"))
    (global is-dragonriding-bound true)))
(fn unbind-dragonriding []
  (when (and (not (InCombatLockdown)) is-dragonriding-bound)
    (ClearOverrideBindings Self.frame)
    (set is-dragonriding-bound false)))
(global SKYRIDING_SPELLID 404464)
(fn is-dragonriding []
  (let [dragonriding-spell-ids (C_MountJournal.GetCollectedDragonridingMounts)]
    (when (and (C_UnitAuras.GetPlayerAuraBySpellID SKYRIDING_SPELLID)
               (is-actually-flyable-area))
      (if (= (GetShapeshiftForm 3) (lua "return true") (Is-mounted)
          (each [_ mount-id (ipairs dragonriding-spell-ids)]
            (local spell-id
                   (select 2 (C_MountJournal.GetMountInfoByID mount-id)))
            (when (C_UnitAuras.GetPlayerAuraBySpellID spell-id)
              (lua "return true")))))
    false))
(var MOUNTS_BY_USAGE {})
(fn setup-ekil []
  (when (is-ekil)
    (global MOUNTS_BY_USAGE
            {:DEFAULT {:FLYING (. MOUNT_IDS "Ironbound Proto-Drake")
                       :FLYING_PASSENGER (. MOUNT_IDS "Renewed Proto-Drake")
                       :FLYING_SHOWOFF (. MOUNT_IDS "Ironbound Proto-Drake")
                       :GROUND (. MOUNT_IDS "Ironbound Proto-Drake")
                       :GROUND_PASSENGER (. MOUNT_IDS "Renewed Proto-Drake")
                       :GROUND_SHOWOFF (. MOUNT_IDS "Ironbound Proto-Drake")
                       :WATER (. MOUNT_IDS "Ironbound Proto-Drake")}})))
(fn mount-by-usage [usage]
  (when (is-debugging) (print-debug-map-info))
  (local class-mounts (or (. MOUNTS_BY_USAGE (GetClassName))
                          (. MOUNTS_BY_USAGE :DEFAULT)))
  (C_MountJournal.SummonByID (. class-mounts usage)))
(fn mount-by-name [mount-name]
  (C_MountJournal.SummonByID (. MOUNT_IDS mount-name)))
(fn is-alternative-mount-requested [] (IsModifierKeyDown))
(fn mount []
  (when (IsMounted) (Dismount) (lua "return "))
  (when (UnitUsingVehicle :player) (VehicleExit) (lua "return "))
  (when (IsOutdoors)
    (if (and (is-actually-flyable-area) (not (IsSubmerged)))
        (do
          (log "FLYING AREA")
          (when (is-alternative-mount-requested)
            (mount-by-usage :FLYING_SHOWOFF))
          (if (IsInGroup) (do
                              (mount-by-usage :FLYING_PASSENGER)
                              (lua "return "))
              (do
                (mount-by-usage :FLYING) (lua "return ")))
          nil) (IsSubmerged)
        (do
          (when (is-alternative-mount-requested) (mount-by-usage :FLYING)
            (lua "return "))
          (mount-by-usage :WATER)
          nil) (if (IsInGroup)
                          (do
                            (when (is-alternative-mount-requested)
                              (mount-by-usage :GROUND_SHOWOFF))
                            (mount-by-usage :GROUND_PASSENGER))
                          (do
                            (when (is-alternative-mount-requested)
                              (mount-by-usage :GROUND_SHOWOFF))
                            (mount-by-usage :GROUND))))))