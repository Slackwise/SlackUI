(global BINDING_HEADER_SLACKWISETWEAKS :SlackwiseTweaks)
(global BINDING_NAME_SLACKWISETWEAKS_RESTART_SOUND "Restart Sound")
(global BINDING_NAME_SLACKWISETWEAKS_RELOADUI "Reload UI")
(global BINDING_NAME_SLACKWISETWEAKS_MOUNT :Mount)
(global BINDING_NAME_SLACKWISETWEAKS_SETBINDINGS "Load Keybindings")
(global BINDING_HEADER_SLACKWISETWEAKS :SlackwiseTweaks)
(global BINDING_NAME_SLACKWISETWEAKS_RESTART_SOUND "Restart Sound")
(global BINDING_NAME_SLACKWISETWEAKS_RELOADUI "Reload UI")
(global BINDING_NAME_SLACKWISETWEAKS_MOUNT :Mount)
(global BINDING_NAME_SLACKWISETWEAKS_SETBINDINGS "Load Keybindings")
(global BINDING_NAME_SLACKWISETWEAKS_BEST_HEALING_POTION
        "Use Best Healing Potion")
(global BINDING_NAME_SLACKWISETWEAKS_BEST_MANA_POTION "Use Best Mana Potion")
(global BINDING_NAME_SLACKWISETWEAKS_BEST_BANDAGE "Use Best Bandage")
(global BINDINGS {})
(global BINDING_TYPE {:ACCOUNT_BINDINGS 1
                      :CHARACTER_BINDINGS 2
                      :DEFAULT_BINDINGS 0})
(global BINDINGS_FUNCTIONS
        {:command Set-binding
         :item Set-binding-item
         :macro Set-binding-macro
         :spell Set-binding-spell})
(fn set-binding [binding]
  (let [(key type name) (unpack binding)]
    ((. BINDINGS_FUNCTIONS type) key name)))
(fn get-binding-description [binding-name]
  (or (. _G (.. :BINDING_NAME_ binding-name)) ""))
(fn unbind-unwanted-defaults [] (Set-binding :SHIFT-T))
(fn bind-best-use-items []
  (when (InCombatLockdown) (run-after-combat bind-best-use-items)
    (lua "return "))
  (Clear-override-bindings Self.itemBindingFrame)
  (each [item-type item-map (pairs BEST_ITEMS)]
    (log (.. "Binding " (get-binding-description item-map.BINDING_NAME) "..."))
    (bind-best-use-item item-map)))
(fn bind-best-use-item [best-item-map]
  (let [container-item-infos (find-items-by-item-iDs (keys best-item-map))]
    (when (and (is-debugging) container-item-infos)
      (log (.. (get-binding-description best-item-map.BINDING_NAME)
               ": found items:"))
      (each [i item (ipairs container-item-infos)]
        (log (.. "    " item.stackCount "x of " item.itemID " " item.hyperlink))))
    (local items-by-best-strength
           (group-by container-item-infos
                     (fn [item]
                       (values (. best-item-map item.itemID)
                               [item.itemID item.stackCount]))))
    (local best-items
           (. items-by-best-strength
              (find-largest-index items-by-best-strength)))
    (when best-items
      (var smallest-stack 9999)
      (var best-item-iD nil)
      (each [i item-stack (ipairs best-items)]
        (local (item-iD stack-count) (unpack item-stack))
        (when (< stack-count smallest-stack) (set smallest-stack stack-count)
          (set best-item-iD item-iD)))
      (log (.. "Best found smallest stack itemID: " best-item-iD))
      (when best-item-iD
        (local desired-binding-keys
               [(Get-binding-key best-item-map.BINDING_NAME)])
        (when (> (length desired-binding-keys) 0)
          (each [i key (ipairs desired-binding-keys)]
            (log (.. "Binding ID " best-item-iD " "
                     (C_Item.GetItemNameByID best-item-iD) " to " key))
            (Set-override-binding-item Self.itemBindingFrame true key
                                       (.. "item:" best-item-iD))))))))
(fn set-bindings []
  (when (not (is-tester))
    (print "SlackwiseTweaks Bindings: Work in progress. Cannot bind currently.")
    (lua "return "))
  (when (InCombatLockdown) (run-after-combat set-bindings) (lua "return "))
  (Load-bindings BINDING_TYPE.DEFAULT_BINDINGS)
  (unbind-unwanted-defaults)
  (each [_ binding (ipairs BINDINGS.GLOBAL)] (set-binding binding))
  (local game (get-game-type))
  (local class (get-class-name))
  (local bindings (. BINDINGS game class))
  (if (is-retail) (let [spec (get-spec-name)]
                    (when (not spec)
                      (print "SlackwiseTweaks Binding: No spec currently to bind!"))
                    (when (not= bindings.CLASS nil)
                      (when bindings.CLASS.PRE_SCRIPT
                        (bindings.CLASS.PRE_SCRIPT))
                      (each [_ binding (ipairs bindings.CLASS)]
                        (local (key type name) (unpack binding))
                        (when (not (and (= type :spell)
                                        (not (C_Spell.DoesSpellExist name))))
                          (set-binding binding)))
                      (when bindings.CLASS.POST_SCRIPT
                        (bindings.CLASS.POST_SCRIPT)))
                    (when (and spec (not= spec ""))
                      (when (. bindings spec :PRE_SCRIPT)
                        ((. bindings spec :PRE_SCRIPT)))
                      (local spec-bindings (. bindings spec))
                      (when (not= spec-bindings nil)
                        (each [_ binding (ipairs spec-bindings)]
                          (when (not (and (= (. binding 2) :spell)
                                          (not (C_Spell.DoesSpellExist (. binding
                                                                          3)))))
                            (set-binding binding))))
                      (when (. bindings spec :POST_SCRIPT)
                        ((. bindings spec :POST_SCRIPT))))
                    (Save-bindings BINDING_TYPE.CHARACTER_BINDINGS)
                    (print (.. (or spec :CLASS-ONLY) " " class
                               " binding presets loaded!")))
      (is-classic)
      (do
        (when bindings.PRE_SCRIPT (bindings.PRE_SCRIPT))
        (each [_ binding (ipairs bindings)]
          (local (key type name) (unpack binding))
          (when (not (and (= type :spell) (not (C_Spell.DoesSpellExist name))))
            (set-binding binding)))
        (when bindings.POST_SCRIPT (bindings.POST_SCRIPT))
        (Save-bindings BINDING_TYPE.CHARACTER_BINDINGS)
        (print (.. class " binding presets loaded!")))
      (print "Unknown game type! Cannot rebind.")))	