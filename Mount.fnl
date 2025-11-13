(set _G.SlackwiseTweaks)

(fn handleDragonriding []
  (when (isTester)
    (if (isDragonriding)
      (bindDragonriding)
      (unbindDragonriding))))

(local isDragonridingBound false)

(fn bindDragonriding []
  (when (and (not (InCombatLockdown)) (not isDragonridingBound))
    (SetOverrideBindingSpell Self.frame true "BUTTON3" "Skyward Ascent")
    (SetOverrideBindingSpell Self.frame true "SHIFT-BUTTON3" "Surge Forward")
    (SetOverrideBindingSpell Self.frame true "CTRL-BUTTON3" "Whirling Surge")
    (SetOverrideBindingSpell Self.frame true "BUTTON5" "Aerial Halt")
    (SetOverrideBindingSpell Self.frame true "SHIFT-X" "Second Wind")
    (SetOverrideBindingSpell Self.frame true "CTRL-X" "Bronze Timelock")
    (if (= (getClassName) "DRUID")
      (SetOverrideBindingMacro Self.frame true "X" "X")
      (SetOverrideBindingSpell Self.frame true "X" "Aerial Halt"))
    (set isDragonridingBound true)))

(fn unbindDragonriding []
  (when (and (not (InCombatLockdown)) isDragonridingBound)
    (ClearOverrideBindings Self.frame)
    (set isDragonridingBound false)))

(local SKYRIDING_SPELLID 404464)
(fn isDragonriding []
  (let [dragonridingSpellIds (C_MountJournal.GetCollectedDragonridingMounts)]
    (if (and (C_UnitAuras.GetPlayerAuraBySpellID SKYRIDING_SPELLID) (isActuallyFlyableArea))
      (if (= (GetShapeshiftForm) 3)
        true
        (if (IsMounted)
          (do
            (each [mountId dragonridingSpellIds]
              (let [spellId (select 2 (C_MountJournal.GetMountInfoByID mountId))]
                (when (C_UnitAuras.GetPlayerAuraBySpellID spellId)
                  (return true)))))))
      false)))

(local MOUNTS_BY_USAGE {})

(fn setupEkil []
  (when (isEkil)
    (set MOUNTS_BY_USAGE {
      :DEFAULT {
        :GROUND (get MOUNT_IDS "Ironbound Proto-Drake")
        :FLYING (get MOUNT_IDS "Ironbound Proto-Drake")
        :WATER (get MOUNT_IDS "Ironbound Proto-Drake")
        :GROUND_PASSENGER (get MOUNT_IDS "Renewed Proto-Drake")
        :FLYING_PASSENGER (get MOUNT_IDS "Renewed Proto-Drake")
        :GROUND_SHOWOFF (get MOUNT_IDS "Ironbound Proto-Drake")
        :FLYING_SHOWOFF (get MOUNT_IDS "Ironbound Proto-Drake")
      }
    })))

(fn mountByUsage [usage]
  (when (isDebugging) (printDebugMapInfo))
  (let [classMounts (or (get MOUNTS_BY_USAGE (getClassName)) (get MOUNTS_BY_USAGE "DEFAULT"))]
    (C_MountJournal.SummonByID (get classMounts usage))))

(fn mountByName [mountName]
  (C_MountJournal.SummonByID (get MOUNT_IDS mountName)))

(fn isAlternativeMountRequested []
  (IsModifierKeyDown))

(fn mount []
  (cond
    (IsMounted) (do (Dismount) nil)
    (UnitUsingVehicle "player") (do (VehicleExit) nil)
    (IsOutdoors)
      (cond
        (and (isActuallyFlyableArea) (not (IsSubmerged)))
          (do
            (print "FLYING AREA")
            (cond
              (isAlternativeMountRequested) (do (mountByUsage "FLYING_SHOWOFF") nil)
              (IsInGroup) (do (mountByUsage "FLYING_PASSENGER") nil)
              :else (do (mountByUsage "FLYING") nil)))
        (IsSubmerged)
          (cond
            (isAlternativeMountRequested) (do (mountByUsage "FLYING") nil)
            :else (do (mountByUsage "WATER") nil))
        :else
          (cond
            (IsInGroup)
              (cond
                (isAlternativeMountRequested) (do (mountByUsage "GROUND_SHOWOFF") nil)
                :else (do (mountByUsage "GROUND_PASSENGER") nil))
            :else
              (cond
                (isAlternativeMountRequested) (do (mountByUsage "GROUND_SHOWOFF") nil)
                :else (do (mountByUsage "GROUND") nil))))))
