;; Converted from Options.lua to Fennel
(local addonName _ ...)
(set _G.SlackwiseTweaks)

(local options {
  :type "group"
  :args {
    :enable {
      :name "Enabled"
      :desc (.. "Enable/disable " addonName)
      :type "toggle"
      :get (fn [] (Self:IsEnabled))
      :set (fn [] (if (Self:IsEnabled) (Self:Disable) (Self:Enable)))
      :order 0
    }
    :debug {
      :name "Enable Debugging"
      :desc "Enable debugging logs and stuff"
      :type "toggle"
      :get (fn [] db.global.isDebugging)
      :set (fn []
        (set db.global.isDebugging (not db.global.isDebugging))
        (if db.global.isDebugging
          (print "SlackwiseTweaks Debugging ON")
          (print "SlackwiseTweaks Debugging OFF")))
    }
    :bind {
      :type "execute"
      :name "Set Bindings"
      :desc "Set binding presets for current character's class and spec."
      :func (fn [] (setBindings))
      :hidden true
    }
    :reset {
      :type "execute"
      :name "Reset All Data"
      :desc "DANGER: Wipes all settings! Cannot be undone!"
      :func (fn []
        (db:ResetDB)
        (print "SlackwiseTweaks: ALL DATA WIPED"))
      :confirm true
    }
  }
})
