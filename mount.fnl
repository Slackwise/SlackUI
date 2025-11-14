(fn _G.handle-dragonriding []
  (when (is-tester)
    (if (is-dragonriding) (bind-dragonriding) (unbind-dragonriding))))
(global is-dragonriding-bound false)
(fn _G.bind-dragonriding []
  (when (and (not (In-combat-lockdown)) (not is-dragonriding-bound))
    (Set-override-binding-spell Self.frame true :BUTTON3 "Skyward Ascent")
    (Set-override-binding-spell Self.frame true :SHIFT-BUTTON3 "Surge Forward")
    (Set-override-binding-spell Self.frame true :CTRL-BUTTON3 "Whirling Surge")
    (Set-override-binding-spell Self.frame true :BUTTON5 "Aerial Halt")
    (Set-override-binding-spell Self.frame true :SHIFT-X "Second Wind")
    (Set-override-binding-spell Self.frame true :CTRL-X "Bronze Timelock")
    (if (= (get-class-name) :DRUID)
        (Set-override-binding-macro Self.frame true :X :X)
        (Set-override-binding-spell Self.frame true :X "Aerial Halt"))
    (global is-dragonriding-bound true)))
(fn _G.unbind-dragonriding []
  (when (and (not (In-combat-lockdown)) is-dragonriding-bound)
    (Clear-override-bindings Self.frame)
    (global is-dragonriding-bound false)))
(global SKYRIDING_SPELLID 404464)
(fn _G.is-dragonriding []
  (let [dragonriding-spell-ids (C_Mount-journal.GetCollectedDragonridingMounts)]
    (when (and (C_Unit-auras.GetPlayerAuraBySpellID SKYRIDING_SPELLID)
               (is-actually-flyable-area))
      (if (= (Get-shapeshift-form) 3) (lua "return true") (Is-mounted)
          (each [_ mount-id (ipairs dragonriding-spell-ids)]
            (local spell-id
                   (select 2 (C_Mount-journal.GetMountInfoByID mount-id)))
            (when (C_Unit-auras.GetPlayerAuraBySpellID spell-id)
              (lua "return true")))))
    false))
(global MOUNTS_BY_USAGE {})
(fn _G.setup-ekil []
  (when (is-ekil)
    (global MOUNTS_BY_USAGE
            {:DEFAULT {:FLYING (. MOUNT_IDS "Ironbound Proto-Drake")
                       :FLYING_PASSENGER (. MOUNT_IDS "Renewed Proto-Drake")
                       :FLYING_SHOWOFF (. MOUNT_IDS "Ironbound Proto-Drake")
                       :GROUND (. MOUNT_IDS "Ironbound Proto-Drake")
                       :GROUND_PASSENGER (. MOUNT_IDS "Renewed Proto-Drake")
                       :GROUND_SHOWOFF (. MOUNT_IDS "Ironbound Proto-Drake")
                       :WATER (. MOUNT_IDS "Ironbound Proto-Drake")}})))
(fn _G.mount-by-usage [usage]
  (when (is-debugging) (print-debug-map-info))
  (local class-mounts (or (. MOUNTS_BY_USAGE (get-class-name))
                          (. MOUNTS_BY_USAGE :DEFAULT)))
  (C_Mount-journal.SummonByID (. class-mounts usage)))
(fn _G.mount-by-name [mount-name]
  (C_Mount-journal.SummonByID (. MOUNT_IDS mount-name)))
(fn _G.is-alternative-mount-requested [] (Is-modifier-key-down))
(fn _G.mount []
  (when (Is-mounted) (Dismount) (lua "return "))
  (when (Unit-using-vehicle :player) (Vehicle-exit) (lua "return "))
  (when (Is-outdoors)
    (if (and (is-actually-flyable-area) (not (Is-submerged)))
        (do
          (log "FLYING AREA")
          (when (is-alternative-mount-requested)
            (mount-by-usage :FLYING_SHOWOFF)
            (lua "return "))
          (if (Is-in-group) (do
                              (mount-by-usage :FLYING_PASSENGER)
                              (lua "return "))
              (do
                (mount-by-usage :FLYING) (lua "return ")))
          nil) (Is-submerged)
        (do
          (when (is-alternative-mount-requested) (mount-by-usage :FLYING)
            (lua "return "))
          (mount-by-usage :WATER)
          nil) (if (Is-in-group)
                          (do
                            (when (is-alternative-mount-requested)
                              (mount-by-usage :GROUND_SHOWOFF)
                              (lua "return "))
                            (mount-by-usage :GROUND_PASSENGER)
                            nil)
                          (do
                            (when (is-alternative-mount-requested)
                              (mount-by-usage :GROUND_SHOWOFF)
                              (lua "return "))
                            (mount-by-usage :GROUND)
                            nil)))))	