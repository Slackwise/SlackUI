addon = _G.Slackwow

function addon:SetBindings()
    local class = select(2, UnitClass("player"))

    --LoadBindings(DEFAULT_BINDINGS)

    table.foreach(bindings.global, SetBinding)
    table.foreach(binding[class].command, SetBinding)
    table.foreach(binding[class].spell, SetBindingSpell)
    table.foreach(binding[class].macro, SetBindingMacro)
    table.foreach(binding[class].item, SetBindingItem)

    SaveBindings(2)
end

addon.bindings = {
    global = {
        "BUTTON3"                       = "TOGGLEAUTORUN",
        "PRINTSCREEN"                   = "SCREENSHOT",
        "SHIFT-MOUSEWHEELUP"            = "NONE",
        "SHIFT-MOUSEWHEELDOWN"          = "NONE",
        "SHIFT-UP"                      = "NONE",
        "SHIFT-DOWN"                    = "NONE",
        "G"                             = "TARGETLASTHOSTILE",
        "B"                             = "TOGGLEBACKPACK",
        "SHIFT-B"                       = "OPENALLBAGS",
        "CTRL-M"                        = "TOGGLEMUSIC",
        "ALT-M"                         = "TOGGLESOUND",
        "CTRL-S"                        = "NONE",
        "NUMPAD0"                       = "RAIDTARGET8",
        "NUMPAD1"                       = "RAIDTARGET7",
        "NUMPAD2"                       = "RAIDTARGET2",
        "NUMPAD3"                       = "RAIDTARGET4",
        "NUMPAD4"                       = "RAIDTARGET6",
        "NUMPAD5"                       = "RAIDTARGET5",
        "NUMPAD6"                       = "RAIDTARGET1",
        "NUMPAD7"                       = "RAIDTARGET3",
        "NUMPADDECIMAL"                 = "RAIDTARGETNONE",
        "CTRL-SHIFT-R"                  = "TOGGLEFPS",
        "CTRL-H"                        = "TOGGLEUI",
        "ALT-C"                         = "TOGGLECHARACTER0"
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
            "CTRL-SPACE"                = "Disengage",
            "CTRL-4"                    = "Arcane Shot",
            "CTRL-5"                    = "Viper String",
            "CTRL-Q"                    = "Mend Pet",
            "CTRL-T"                    = "Freezing Trap",
            "CTRL-Z"                    = "Feign Death",
            "SHIFT-3"                   = "Multi-Shot",
            "SHIFT-5"                   = "Tranquilizing Shot",
            "SHIFT-F"                   = "Serpent Sting",
            "SHIFT-T"                   = "Frost Trap",
            "ALT-F"                     = "Distracting Shot",
            "ALT-T"                     = "Trueshot Aura",
            "ALT-CTRL-A"                = "Readiness",
            "ALT-CTRL-Q"                = "Revive Pet",
            "ALT-CTRL-Z"                = "Trinket",
            "ALT-SHIFT-F"               = "Eyes of the Beast"


        },
        macro = {
            "SHIFT-SPACE"               = "Mount",
            "BUTTON4"                   = "Mouse",
            "F5"                        = "ModeSwitch",
            "C"                         = "Call",
            "Q"                         = "PetControl",
            "R"                         = "R",
            "CTRL-E"                    = "Engage",
            "CTRL-X"                    = "Bandage",
            "ALT-E"                     = "MD",
            "ALT-Z"                     = "Peace"

        },
        item = {
        }
    }
}
