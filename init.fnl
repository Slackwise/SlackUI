(local Self (: (Lib-stub :AceAddon-3.0) :NewAddon :SlackwiseTweaks
               :AceConsole-3.0 :AceEvent-3.0))
(set Self.config (Lib-stub :AceConfig-3.0))
(set Self.frame (Create-frame :Frame :SlackwiseTweaks))
(set Self.itemBindingFrame
     (Create-frame :Frame "SlackwiseTweaks Item Bindings"))
(set _G.SlackwiseTweaks Self)
(set Self.Self Self)
(setmetatable Self {:__index _G})
(setfenv 1 Self)
(global (addon-name addon-table) ...)
(global db-defaults
        {:global {:isDebugging false :log {}}
         :profile {:mounts {:ground nil
                            :ground-passenger nil
                            :ground-passenger-showoff nil
                            :ground-showoff nil
                            :skyriding nil
                            :skyriding-passenger nil
                            :skyriding-passenger-showoff nil
                            :skyriding-showoff nil
                            :steadyflight nil
                            :steadyflight-passenger nil
                            :steadyflight-passenger-showoff nil
                            :steadyflight-showoff nil
                            :water nil
                            :water-showoff nil}}})
(fn get-battletag [] (select 2 (BNGet-info)))
(fn is-slackwise []
  (or (= (get-battletag) "Slackwise#1121") false))
(fn is-tester [] (is-slackwise))
(fn is-retail [] (if (= WOW_PROJECT_ID WOW_PROJECT_MAINLINE) true false))
(fn is-classic [] (if (= WOW_PROJECT_ID WOW_PROJECT_CLASSIC) true false))
(fn get-game-type []
  (if (is-retail) :RETAIL
      (is-classic) :CLASSIC
      :UNKNOWN))
(fn is-debugging []
  (when (is-initialized)
    (let [___antifnl_rtn_1___ Self.db.global.isDebugging]
      (lua "return ___antifnl_rtn_1___")))
  (if (is-slackwise) true false))
(global COLOR_START :|c)
(global COLOR_END :|r)
(fn color [color] (fn [text] (.. COLOR_START :FF color text COLOR_END)))
(global grey (color :AAAAAA))
(fn log [message ...]
  (when (is-debugging)
    (print (.. (grey (date)) "  " message))
    (when (is-initialized)
      (table.insert Self.db.global.log (.. (date) "  " message))
      (when arg
        (each [i v (ipairs arg)] (print (.. "Arg " i " = " v))
          (table.insert Self.db.global.log (.. "Arg " i " = " v)))))))
(fn Self.OnInitialize [self]
  (set Self.db (: (Lib-stub :AceDB-3.0) :New :SlackwiseTweaksDB db-defaults))
  (config:RegisterOptionsTable :SlackwiseTweaks options :slack)
  (set Self.configDialog (: (Lib-stub :AceConfigDialog-3.0) :AddToBlizOptions
                            :SlackwiseTweaks)))
(fn is-initialized []
  (not (not (. Self :configDialog))))	