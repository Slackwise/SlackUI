;; Converted from Slackwise.lua to Fennel
(set _G.SlackwiseTweaks)

;; MOUNTS_BY_USAGE table
(local MOUNTS_BY_USAGE {
  :DEFAULT {
    :GROUND (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING (get MOUNT_IDS "Ashes of Al'ar")
    :WATER (get MOUNT_IDS "Sea Turtle")
    :GROUND_PASSENGER (get MOUNT_IDS "Mekgineer's Chopper")
    :FLYING_PASSENGER (get MOUNT_IDS "Algarian Stormrider")
    :GROUND_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING_SHOWOFF (get MOUNT_IDS "X-45 Heartbreaker")
  }
  :HUNTER {
    :GROUND (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING (get MOUNT_IDS "Ashes of Al'ar")
    :WATER (get MOUNT_IDS "Sea Turtle")
    :GROUND_PASSENGER (get MOUNT_IDS "Mekgineer's Chopper")
    :FLYING_PASSENGER (get MOUNT_IDS "Renewed Proto-Drake")
    :GROUND_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
  }
  :PALADIN {
    :GROUND (get MOUNT_IDS "Highlord's Golden Charger")
    :FLYING (get MOUNT_IDS "Chaos-Forged Gryphon")
    :WATER (get MOUNT_IDS "Sea Turtle")
    :GROUND_PASSENGER (get MOUNT_IDS "Algarian Stormrider")
    :FLYING_PASSENGER (get MOUNT_IDS "Algarian Stormrider")
    :GROUND_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
  }
  :SHAMAN {
    :GROUND (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING (get MOUNT_IDS "Ashes of Al'ar")
    :WATER (get MOUNT_IDS "Sea Turtle")
    :GROUND_PASSENGER (get MOUNT_IDS "Algarian Stormrider")
    :FLYING_PASSENGER (get MOUNT_IDS "Algarian Stormrider")
    :GROUND_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
  }
  :PRIEST {
    :GROUND (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING (get MOUNT_IDS "Ashes of Al'ar")
    :WATER (get MOUNT_IDS "Sea Turtle")
    :GROUND_PASSENGER (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING_PASSENGER (get MOUNT_IDS "Swift Razzashi Raptor")
    :GROUND_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
  }
  :MAGE {
    :GROUND (get MOUNT_IDS "Celestial Steed")
    :FLYING (get MOUNT_IDS "Celestial Steed")
    :WATER (get MOUNT_IDS "Sea Turtle")
    :GROUND_PASSENGER (get MOUNT_IDS "Celestial Steed")
    :FLYING_PASSENGER (get MOUNT_IDS "Celestial Steed")
    :GROUND_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
    :FLYING_SHOWOFF (get MOUNT_IDS "Swift Razzashi Raptor")
  }
})

;; BINDINGS table (truncated for brevity)
(local BINDINGS {
  :GLOBAL [
    ["ALT-CTRL-END" "command" "SLACKWISETWEAKS_RELOADUI"]
    ["ALT-CTRL-`" "command" "FOCUSTARGET"]
    ;; ... more bindings ...
  ]
  ;; ... more class and spec bindings ...
})
