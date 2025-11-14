(global options {:args {:bind {:desc "Set binding presets for current character's class and spec."
                               :func (fn [] (set-bindings))
                               :hidden true
                               :name "Set Bindings"
                               :type :execute}
                        :debug {:desc "Enable debugging logs and stuff"
                                :get (fn [] db.global.isDebugging)
                                :name "Enable Debugging"
                                :set (fn []
                                       (set db.global.isDebugging
                                            (not db.global.isDebugging))
                                       (if db.global.isDebugging
                                           (print "SlackwiseTweaks Debugging ON")
                                           (print "SlackwiseTweaks Debugging OFF")))
                                :type :toggle}
                        :enable {:desc (.. "Enable/disable " addon-name)
                                 :get (fn [] (Self:IsEnabled))
                                 :name :Enabled
                                 :order 0
                                 :set (fn []
                                        (if (Self:IsEnabled) (Self:Disable)
                                            (Self:Enable)))
                                 :type :toggle}
                        :reset {:confirm true
                                :desc "DANGER: Wipes all settings! Cannot be undone!"
                                :func (fn [] (db:ResetDB)
                                        (print "SlackwiseTweaks: ALL DATA WIPED"))
                                :name "Reset All Data"
                                :type :execute}}
                 :type :group})	