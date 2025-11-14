;; Bindings have to be in global scope,
;; so we need them to be set before `setfenv()` changes scope!
(set _G.BINDING_HEADER_SLACKWISETWEAKS "SlackwiseTweaks")
(set _G.BINDING_NAME_SLACKWISETWEAKS_RESTART_SOUND "Restart Sound")
(set _G.BINDING_NAME_SLACKWISETWEAKS_RELOADUI "Reload UI")
(set _G.BINDING_NAME_SLACKWISETWEAKS_MOUNT "Mount")
(set _G.BINDING_NAME_SLACKWISETWEAKS_SETBINDINGS "Load Keybindings")
(set _G.BINDING_NAME_SLACKWISETWEAKS_BEST_HEALING_POTION "Use Best Healing Potion")
(set _G.BINDING_NAME_SLACKWISETWEAKS_BEST_MANA_POTION "Use Best Mana Potion")
(set _G.BINDING_NAME_SLACKWISETWEAKS_BEST_BANDAGE "Use Best Bandage")


(var BINDINGS {})

(set BINDING_TYPE {
  :DEFAULT_BINDINGS   0
  :ACCOUNT_BINDINGS   1
  :CHARACTER_BINDINGS 2
})

(set BINDINGS_FUNCTIONS {
  :command SetBinding
  :spell   SetBindingSpell
  :macro   SetBindingMacro
  :item    SetBindingItem
})

(fn setBinding [binding]
  (let [[key type name] binding]
    ((. BINDINGS_FUNCTIONS type) key name)))

(fn getBindingDescription [bindingName]
  (or (_G (.. "BINDING_NAME_" bindingName)) ""))

(fn unbindUnwantedDefaults []
  (SetBinding "SHIFT-T"))

(fn bindBestUseItems []
  (when (InCombatLockdown)
    (runAfterCombat bindBestUseItems))

  (ClearOverrideBindings Self.itemBindingFrame)

  (each-pair [itemType itemMap BEST_ITEMS]
    (log (.. "Binding " (getBindingDescription itemMap.BINDING_NAME) "..."))
    (bindBestUseItem itemMap)))

(fn bindBestUseItem [bestItemMap]
  (let [containerItemInfos (findItemsByItemIDs (keys bestItemMap))]
    (when (and (isDebugging) containerItemInfos)
      (log (.. (getBindingDescription bestItemMap.BINDING_NAME) ": found items:"))
      (each [i item (ipairs containerItemInfos)]
        (log (.. "    " item.stackCount "x of " item.itemID " " item.hyperlink))))

    (let [itemsByBestStrength (groupBy containerItemInfos
      (fn [item]
        (values (. bestItemMap item.itemID) [item.itemID item.stackCount])))
          bestItems (. itemsByBestStrength (findLargestIndex itemsByBestStrength))]
      (when bestItems
        (var smallestStack 9999)
        (var bestItemID nil)
        (each [i itemStack (ipairs bestItems)]
          (let [[itemID stackCount] itemStack]
            (when (< stackCount smallestStack)
              (set smallestStack stackCount)
              (set bestItemID itemID))))
        (log (.. "Best found smallest stack itemID: " bestItemID))

        (when bestItemID
          (let [desiredBindingKeys [(GetBindingKey bestItemMap.BINDING_NAME)]]
            (when (> (length desiredBindingKeys) 0)
              (each [i key (ipairs desiredBindingKeys)]
                (log (.. "Binding ID " bestItemID " " (C_Item.GetItemNameByID bestItemID) " to " key))
                (SetOverrideBindingItem Self.itemBindingFrame true key (.. "item:" bestItemID))))))))))

(fn setBindings []
  (when (not (isTester))
    (print "SlackwiseTweaks Bindings: Work in progress. Cannot bind currently."))

  (when (InCombatLockdown)
    (runAfterCombat setBindings))

  (LoadBindings BINDING_TYPE.DEFAULT_BINDINGS)
  (unbindUnwantedDefaults)

  ;; Global bindings:
  (each [_ binding (ipairs BINDINGS.GLOBAL)]
    (setBinding binding))

  ;; Class specific bindings:
  (let [game (getGameType)
        class (getClassName)
        bindings (. BINDINGS game class)]

    (if (isRetail)
      (let [spec (getSpecName)]
        (when (not spec)
          (print "SlackwiseTweaks Binding: No spec currently to bind!"))

        (when (not (= bindings.CLASS nil))
          (when bindings.CLASS.PRE_SCRIPT
            (bindings.CLASS.PRE_SCRIPT))
          (each [_ binding (ipairs bindings.CLASS)]
            (let [[key type name] binding]
              (when (not (and (= type "spell") (not (C_Spell.DoesSpellExist name))))
                (setBinding binding))))
          (when bindings.CLASS.POST_SCRIPT
            (bindings.CLASS.POST_SCRIPT)))

        (when (and spec (not (= spec "")))
          (when (. bindings spec :PRE_SCRIPT)
            ((. bindings spec :PRE_SCRIPT)))
          (let [specBindings (. bindings spec)]
            (when (not (= specBindings nil))
              (each [_ binding (ipairs specBindings)]
                (when (not (and (= (. binding 2) "spell") (not (C_Spell.DoesSpellExist (. binding 3)))))
                  (setBinding binding)))))
          (when (. bindings spec :POST_SCRIPT)
            ((. bindings spec :POST_SCRIPT))))

        (SaveBindings BINDING_TYPE.CHARACTER_BINDINGS)
        (print (.. (or spec "CLASS-ONLY") " " class " binding presets loaded!")))

      (isClassic)
      (do
        (when bindings.PRE_SCRIPT
          (bindings.PRE_SCRIPT))

        (each [_ binding (ipairs bindings)]
          (let [[key type name] binding]
            (when (not (and (= type "spell") (not (C_Spell.DoesSpellExist name))))
              (setBinding binding))))

        (when bindings.POST_SCRIPT
          (bindings.POST_SCRIPT))

        (SaveBindings BINDING_TYPE.CHARACTER_BINDINGS)
        (print (.. class " binding presets loaded!")))

      ;; else: Unknown game type
      (print "Unknown game type! Cannot rebind."))))
