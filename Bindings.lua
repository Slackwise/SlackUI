local addon = _G.Slackwow

function addon:SetBindings()
    local class = select(2, UnitClass("player"))

    --LoadBindings(DEFAULT_BINDINGS)

    table.foreach(bindings.global, SetBinding)
    table.foreach(bindings[class].command, SetBinding)
    table.foreach(bindings[class].spell, SetBindingSpell)
    table.foreach(bindings[class].macro, SetBindingMacro)
    table.foreach(bindings[class].item, SetBindingItem)

    SaveBindings(2)
end

addon.bindings = {
    global = {
        "BUTTON3"                       = "TOGGLEAUTORUN",
        "PRINTSCREEN"                   = "SCREENSHOT",
        "NUMPAD0"                       = "RAIDTARGET8",
        "NUMPAD1"                       = "RAIDTARGET7",
        "NUMPAD2"                       = "RAIDTARGET2",
        "NUMPAD3"                       = "RAIDTARGET4",
        "NUMPAD4"                       = "RAIDTARGET6",
        "NUMPAD5"                       = "RAIDTARGET5",
        "NUMPAD6"                       = "RAIDTARGET1",
        "NUMPAD7"                       = "RAIDTARGET3",
        "NUMPADDECIMAL"                 = "RAIDTARGETNONE",
        "B"                             = "TOGGLEBACKPACK",
        "G"                             = "TARGETLASTHOSTILE",
        "SHIFT-B"                       = "OPENALLBAGS",
        "SHIFT-MOUSEWHEELUP"            = "NONE",
        "SHIFT-MOUSEWHEELDOWN"          = "NONE",
        "SHIFT-UP"                      = "NONE",
        "SHIFT-DOWN"                    = "NONE",
        "CTRL-H"                        = "TOGGLEUI",
        "CTRL-M"                        = "TOGGLEMUSIC",
        "CTRL-S"                        = "NONE",
        "CTRL-SHIFT-R"                  = "TOGGLEFPS",
        "ALT-C"                         = "TOGGLECHARACTER0"
        "ALT-M"                         = "TOGGLESOUND",
    },
    HUNTER = {
        command = {
            "3"                         = "ACTIONBUTTON3",
            "4"                         = "ACTIONBUTTON4",
            "SHIFT-ENTER"               = "REPLY",
            "SHIFT-4"                   = "ACTIONBUTTON5",
            "CTRL-ENTER"                = "REPLY2"
        },
        spell = {
            "`"                         = "Auto Shot",
            "1"                         = "Raptor Strike",
            "2"                         = "Steady Shot",
            "5"                         = "Kill Shot",
            "E"                         = "Wing Clip",
            "F"                         = "Concussive Shot",
            "T"                         = "Deterrence",
            "SHIFT-3"                   = "Multi-Shot",
            "SHIFT-5"                   = "Tranquilizing Shot",
            "SHIFT-F"                   = "Serpent Sting",
            "SHIFT-T"                   = "Frost Trap",
            "CTRL-SPACE"                = "Disengage",
            "CTRL-4"                    = "Arcane Shot",
            "CTRL-5"                    = "Viper String",
            "CTRL-Q"                    = "Mend Pet",
            "CTRL-T"                    = "Freezing Trap",
            "CTRL-Z"                    = "Feign Death",
            "ALT-F"                     = "Distracting Shot",
            "ALT-T"                     = "Trueshot Aura",
            "ALT-CTRL-A"                = "Readiness",
            "ALT-CTRL-Q"                = "Revive Pet",
            "ALT-CTRL-Z"                = "Trinket",
            "ALT-SHIFT-F"               = "Eyes of the Beast"
        },
        macro = {
            "BUTTON4"                   = "Mouse",
            "F5"                        = "ModeSwitch",
            "C"                         = "Call",
            "Q"                         = "PetControl",
            "R"                         = "R",
            "SHIFT-SPACE"               = "Mount",
            "CTRL-E"                    = "Engage",
            "CTRL-X"                    = "Bandage",
            "ALT-E"                     = "MD",
            "ALT-Z"                     = "Peace"
        },
        item = {
        }
    }
}
