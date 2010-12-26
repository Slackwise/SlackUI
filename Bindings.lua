local addon = _G.Slackwow

function addon:SetBindings()
    local class = select(2, UnitClass("player"))
    local b = addon.bindings

    LoadBindings(DEFAULT_BINDINGS)
    
    for k, v in pairs(b.global) do SetBinding(k, v) end
    for k, v in pairs(b[class].command) do SetBinding(k, v) end
    for k, v in pairs(b[class].click) do SetBindingClick(k, v, "LeftButton") end
    for k, v in pairs(b[class].spell) do SetBindingSpell(k, v) end
    for k, v in pairs(b[class].macro) do SetBindingMacro(k, v) end
    for k, v in pairs(b[class].item) do SetBindingItem(k, v) end

    SaveBindings(2)
    print(class .. " binding presets loaded!")
end

addon.bindings = {
    global = {
        ["BUTTON3"]                       = "TOGGLEAUTORUN",
        ["PRINTSCREEN"]                   = "SCREENSHOT",
        ["NUMLOCK"]                       = "NONE",
        ["NUMPAD0"]                       = "RAIDTARGET8",
        ["NUMPAD1"]                       = "RAIDTARGET7",
        ["NUMPAD2"]                       = "RAIDTARGET2",
        ["NUMPAD3"]                       = "RAIDTARGET4",
        ["NUMPAD4"]                       = "RAIDTARGET6",
        ["NUMPAD5"]                       = "RAIDTARGET5",
        ["NUMPAD6"]                       = "RAIDTARGET1",
        ["NUMPAD7"]                       = "RAIDTARGET3",
        ["NUMPADDECIMAL"]                 = "RAIDTARGETNONE",
        ["F1"]                            = "TARGETPARTYMEMBER1", 
        ["F2"]                            = "TARGETPARTYMEMBER2", 
        ["F3"]                            = "TARGETPARTYMEMBER3", 
        ["F4"]                            = "TARGETPARTYMEMBER4", 
        ["F7"]                            = "TOGGLEFPS",
        ["B"]                             = "TOGGLEBACKPACK",
        ["G"]                             = "TARGETLASTHOSTILE",
        ["SHIFT-ENTER"]                   = "REPLY",
        ["SHIFT-MOUSEWHEELUP"]            = "NONE",
        ["SHIFT-MOUSEWHEELDOWN"]          = "NONE",
        ["SHIFT-UP"]                      = "NONE",
        ["SHIFT-DOWN"]                    = "NONE",
        ["CTRL-ENTER"]                    = "REPLY2",
        ["SHIFT-1"]                       = "NONE",
        ["SHIFT-2"]                       = "NONE",
        ["SHIFT-3"]                       = "NONE",
        ["SHIFT-4"]                       = "NONE",
        ["SHIFT-5"]                       = "NONE",
        ["SHIFT-6"]                       = "NONE",
        ["SHIFT-B"]                       = "OPENALLBAGS",
        ["SHIFT-R"]                       = "NONE",
        ["CTRL-H"]                        = "TOGGLEUI",
        ["CTRL-M"]                        = "TOGGLEMUSIC",
        ["CTRL-L"]                        = "TOGGLEACTIONBARLOCK",
        ["CTRL-R"]                        = "NONE",
        ["CTRL-S"]                        = "NONE",
        ["ALT-C"]                         = "TOGGLECHARACTER0",
        ["ALT-M"]                         = "TOGGLESOUND",
    },
    HUNTER = {
        command = {
            ["-"]                         = "NONE",
            ["="]                         = "NONE",
            ["0"]                         = "NONE",
            ["3"]                         = "ACTIONBUTTON4",
            ["4"]                         = "ACTIONBUTTON5",
            ["6"]                         = "NONE",
            ["7"]                         = "NONE",
            ["8"]                         = "NONE",
            ["9"]                         = "NONE",
            ["SHIFT-3"]                   = "ACTIONBUTTON3",
            ["CTRL-F"]                    = "ACTIONBUTTON12",
        },
        click = {
            ["ALT-SHIFT-Q"]               = "PetActionButton1",
        },
        spell = {
            ["2"]                         = "Kill Command",
            ["5"]                         = "Kill Shot",
            ["C"]                         = "Camouflage",
            ["E"]                         = "Wing Clip",
            ["F"]                         = "Concussive Shot",
            ["T"]                         = "Deterrence",
            ["SHIFT-4"]                   = "Arcane Shot",
            ["SHIFT-5"]                   = "Widow Venom",
            ["SHIFT-E"]                   = "Raptor Strike",
            ["SHIFT-F"]                   = "Serpent Sting",
            ["SHIFT-T"]                   = "Ice Trap",
            ["CTRL-SPACE"]                = "Disengage",
            ["CTRL-3"]                    = "Multi-Shot",
            ["CTRL-4"]                    = "Tranquilizing Shot",
            ["CTRL-E"]                    = "Scatter Shot",
            ["CTRL-Q"]                    = "Mend Pet",
            ["CTRL-T"]                    = "Freezing Trap",
            ["CTRL-Z"]                    = "Feign Death",
            ["ALT-F"]                     = "Distracting Shot",
            ["ALT-T"]                     = "Explosive Trap",
            ["ALT-CTRL-E"]                = "Readiness",
            ["ALT-CTRL-R"]                = "Snake Trap",
            ["ALT-CTRL-Q"]                = "Revive Pet",
            ["ALT-CTRL-S"]                = "Survey",
            ["ALT-CTRL-Z"]                = "Trinket",
        },
        macro = {
            ["BUTTON4"]                   = "Mouse",
            ["ALT-BUTTON4"]               = "MouseAlt",
            ["`"]                         = "StopAttack",
            ["1"]                         = "Engage",
            ["F5"]                        = "ModeSwitch",
            ["SHIFT-C"]                   = "Call",
            ["Q"]                         = "PetControl",
            ["R"]                         = "R",
            ["SHIFT-SPACE"]               = "Mount",
            ["CTRL-X"]                    = "Bandage",
            ["ALT-E"]                     = "MD",
            ["ALT-Z"]                     = "Peace",
            ["ALT-CTRL-S"]                = "5min",
        },
        item = {
        }
    }
}
