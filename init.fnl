(local Self (. LibStub "AceAddon-3.0" :NewAddon
  "SlackwiseTweaks"
  "AceConsole-3.0"
  "AceEvent-3.0"))
(set Self.config (. LibStub "AceConfig-3.0"))
(set Self.frame (CreateFrame "Frame" "SlackwiseTweaks"))
(set Self.itemBindingFrame (CreateFrame "Frame" "SlackwiseTweaks Item Bindings"))
(set (_G.SlackwiseTweaks) Self)
(set Self.Self Self)
(setmetatable Self {:__index _G})
(setfenv 1 Self)

(local [addonName addonTable] Self)

(local dbDefaults
  {:global {:isDebugging false :log []}
   :profile {:mounts {
     :ground nil
     :ground-showoff nil
     :skyriding nil
     :skyriding-showoff nil
     :steadyflight nil
     :steadyflight-showoff nil
     :water nil
     :water-showoff nil
     :ground-passenger nil
     :ground-passenger-showoff nil
     :skyriding-passenger nil
     :skyriding-passenger-showoff nil
     :steadyflight-passenger nil
     :steadyflight-passenger-showoff nil}}})

(fn getBattletag []
  (select 2 (BNGetInfo)))

(fn isSlackwise []
  (= (getBattletag) "Slackwise#1121"))

(fn isTester []
  (isSlackwise))

(fn isRetail []
  (if (= WOW_PROJECT_ID WOW_PROJECT_MAINLINE)
    true
    false))

(fn isClassic []
  (if (= WOW_PROJECT_ID WOW_PROJECT_CLASSIC)
    true
    false))

(fn getGameType []
  (cond
    (isRetail) "RETAIL"
    (isClassic) "CLASSIC"
    :else "UNKNOWN"))

(fn isDebugging []
  (if (isInitialized)
    Self.db.global.isDebugging
    (if (isSlackwise)
      true
      false)))

(local COLOR_START "\124c")
(local COLOR_END "\124r")

(fn color [color]
  (fn [text]
    (.. COLOR_START "FF" color text COLOR_END)))

(local grey (color "AAAAAA"))

(fn log [message & args]
  (when (isDebugging)
    (print (.. (grey (date)) "  " message))
    (when (isInitialized)
      (table.insert Self.db.global.log (.. (date) "  " message))
      (when args
        (each [i v (ipairs args)]
          (print (.. "Arg " i " = " v))
          (table.insert Self.db.global.log (.. "Arg " i " = " v)))))))

(fn OnInitialize [self]
  (set self.db (. LibStub "AceDB-3.0" :New "SlackwiseTweaksDB" dbDefaults))
  (. config :RegisterOptionsTable "SlackwiseTweaks" options "slack")
  (set self.configDialog (. LibStub "AceConfigDialog-3.0" :AddToBlizOptions "SlackwiseTweaks")))

(fn isInitialized []
  (not (not (get Self "configDialog"))))

;; Load dependencies in order
(dofile "static-data.fnl")
(dofile "core.fnl")
(dofile "bindings.fnl")
(dofile "options.fnl")
(dofile "mount.fnl")
(dofile "slackwise.fnl")