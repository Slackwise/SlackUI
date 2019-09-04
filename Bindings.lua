local addon = _G.Slackwow

function addon:SetBindings()
  local class = select(2, UnitClass("player"))
  local b = addon.bindings
  local game

  if IsClassic() then
    game = "classic"
  else
    game = "retail"
  end

  LoadBindings(DEFAULT_BINDINGS)
  
  for k, v in pairs(b.global) do SetBinding(k, v) end
  for k, v in pairs(b[game][class].command) do SetBinding(k, v) end
  for k, v in pairs(b[game][class].click) do SetBindingClick(k, v, "LeftButton") end
  for k, v in pairs(b[game][class].spell) do SetBindingSpell(k, v) end
  for k, v in pairs(b[game][class].macro) do SetBindingMacro(k, v) end
  for k, v in pairs(b[game][class].item) do SetBindingItem(k, v) end

  if IsClassic() then
    AttemptToSaveBindings(2)
  else
    SaveBindings(2)
  end
  print(game .. " " .. class .. " binding presets loaded!")
end

addon.bindings = {
  global = {
    ["BUTTON3"]                       = "TOGGLEAUTORUN",
    ["SHIFT-HOME"]                    = "SETVIEW1",
    ["HOME"]                          = "SETVIEW2",
    ["END"]                           = "SETVIEW3",
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
    ["SHIFT-ENTER"]                   = "REPLY",
    ["SHIFT-MOUSEWHEELUP"]            = "NONE",
    ["SHIFT-MOUSEWHEELDOWN"]          = "NONE",
    ["SHIFT-UP"]                      = "NONE",
    ["SHIFT-DOWN"]                    = "NONE",
    ["CTRL-ENTER"]                    = "REPLY2",
    ["1"]                             = "NONE",
    ["2"]                             = "NONE",
    ["3"]                             = "NONE",
    ["4"]                             = "NONE",
    ["5"]                             = "NONE",
    ["6"]                             = "NONE",
    ["7"]                             = "NONE",
    ["8"]                             = "NONE",
    ["9"]                             = "NONE",
    ["0"]                             = "NONE",
    ["-"]                             = "NONE",
    ["="]                             = "NONE",
    ["SHIFT-1"]                       = "NONE",
    ["SHIFT-2"]                       = "NONE",
    ["SHIFT-3"]                       = "NONE",
    ["SHIFT-4"]                       = "NONE",
    ["SHIFT-5"]                       = "NONE",
    ["SHIFT-6"]                       = "NONE",
    ["SHIFT-7"]                       = "NONE",
    ["SHIFT-8"]                       = "NONE",
    ["SHIFT-9"]                       = "NONE",
    ["SHIFT-0"]                       = "NONE",
    ["CTRL-1"]                        = "NONE",
    ["CTRL-2"]                        = "NONE",
    ["CTRL-3"]                        = "NONE",
    ["CTRL-4"]                        = "NONE",
    ["CTRL-5"]                        = "NONE",
    ["CTRL-6"]                        = "NONE",
    ["CTRL-7"]                        = "NONE",
    ["CTRL-8"]                        = "NONE",
    ["CTRL-9"]                        = "NONE",
    ["CTRL-0"]                        = "NONE",
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
  retail = {
    HUNTER = {
      command = {
        ["-"]                         = "NONE",
        ["="]                         = "NONE",
        ["`"]                         = "ACTIONBUTTON1",        --StopAttack MACRO
        ["0"]                         = "NONE",
        ["3"]                         = "ACTIONBUTTON4",        --Chimera Shot || Explosive Shot
        ["4"]                         = "ACTIONBUTTON5",        --Steady Shot || Cobra Shot
        ["5"]                         = "ACTIONBUTTON6",        --Kill Shot
        ["6"]                         = "NONE",
        ["7"]                         = "NONE",
        ["8"]                         = "NONE",
        ["9"]                         = "NONE",
        ["F"]                         = "ACTIONBUTTON10",       --Concussive Shot
        ["T"]                         = "ACTIONBUTTON8",        --Deterrence
        ["SHIFT-3"]                   = "ACTIONBUTTON3",        --Aimed Shot
        ["SHIFT-E"]                   = "ACTIONBUTTON2",        --Raptor Strike
        ["CTRL-E"]                    = "ACTIONBUTTON7",        --Scatter MACRO
        ["CTRL-F"]                    = "ACTIONBUTTON12",       --Silencing Shot || Wyvern Sting MACRO
        ["CTRL-Z"]                    = "ACTIONBUTTON11",       --Feign Death
        ["CTRL-SPACE"]                = "ACTIONBUTTON9",        --Disengage
      },
      click = {
        ["ALT-SHIFT-Q"]               = "PetActionButton1",
      },
      spell = {
        ["2"]                         = "Kill Command",
        ["C"]                         = "Camouflage",
        ["E"]                         = "Wing Clip",
        ["SHIFT-4"]                   = "Arcane Shot",
        ["6"]                         = "Widow Venom",
        ["SHIFT-F"]                   = "Serpent Sting",
        ["CTRL-G"]                    = "Readiness",
        ["SHIFT-T"]                   = "Ice Trap",
        ["CTRL-3"]                    = "Multi-Shot",
        ["CTRL-4"]                    = "Cobra Shot",
        ["SHIFT-5"]                   = "Tranquilizing Shot",
        ["CTRL-T"]                    = "Freezing Trap",
        ["CTRL-SHIFT-Q"]              = "Mend Pet",
        ["ALT-F"]                     = "Distracting Shot",
        ["ALT-T"]                     = "Snake Trap",
        ["ALT-CTRL-F"]                = "Scare Beast",
        ["ALT-CTRL-Q"]                = "Revive Pet",
        ["ALT-CTRL-S"]                = "Survey",
        ["ALT-CTRL-T"]                = "Explosive Trap",
      },
      macro = {
        ["BUTTON4"]                   = "Mouse",
        ["ALT-BUTTON4"]               = "MouseAlt",
        ["1"]                         = "Engage",
        ["F5"]                        = "ModeSwitch",
        ["G"]                         = "Call",
        ["Q"]                         = "PetControl",
        ["R"]                         = "R",
        ["SHIFT-SPACE"]               = "Mount",
        ["CTRL-Q"]                    = "PetSpecial",
        ["ALT-E"]                     = "MD",
        ["ALT-Z"]                     = "Peace",
        ["ALT-CTRL-A"]                = "Burst!",
      },
      item = {
        ["SHIFT-G"]                   = "Medallion of the Alliance",
        ["CTRL-X"]                    = "Dense Embersilk Bandage",
      }
    },
    DEATHKNIGHT = {
      command = {},
      click = {},
      spell = {
        ["BUTTON4"]                   = "Death and Decay",
        ["F1"]                        = "Blood Presence",
        ["F2"]                        = "Frost Presence",
        ["F3"]                        = "Unholy Presence",
        ["`"]                         = "Rune Tap",
        ["1"]                         = "Blood Boil",
        ["2"]                         = "Pestilence",
        ["3"]                         = "Plague Strike",
        ["C"]                         = "Anti-Magic Shell",
        ["F"]                         = "Mind Freeze",
        ["G"]                         = "Every Man for Himself",
        ["Q"]                         = "Death Grip",
        ["T"]                         = "Dark Command",
        ["SHIFT-3"]                   = "Necrotic Strike",
        ["SHIFT-4"]                   = "Outbreak",
        ["SHIFT-5"]                   = "Empower Rune Weapon",
        ["SHIFT-C"]                   = "Vampiric Blood",
        ["SHIFT-E"]                   = "Death Strike",
        ["SHIFT-F"]                   = "Strangulate",
        ["SHIFT-Q"]                   = "Chains of Ice",
        ["SHIFT-R"]                   = "Death Coil",
        ["CTRL-3"]                    = "Bone Shield",
        ["CTRL-4"]                    = "Horn of Winter",
        ["CTRL-C"]                    = "Icebound Fortitude",
        ["CTRL-E"]                    = "Obliterate",
        ["CTRL-F"]                    = "Hungering Cold",
        ["CTRL-R"]                    = "Dark Simulacrum",
        ["ALT-1"]                     = "Blood Tap",
        ["ALT-4"]                     = "Icy Touch",
        ["ALT-E"]                     = "Festering Strike",
        ["ALT-F"]                     = "Path of Frost",
        ["ALT-G"]                     = "Death Gate",
        ["ALT-CTRL-A"]                = "Army of the Dead",
      },
      macro = {
        ["4"]                         = "Frost",
        ["5"]                         = "Ult",
        ["E"]                         = "Blood", --Heart Strike or Blood
        ["R"]                         = "Rune",
        ["SHIFT-SPACE"]               = "Mount",
        ["SHIFT-G"]                   = "Licheal",
        ["ALT-R"]                     = "RaisePact",
      },
      item = {
      },
    },
  },
  classic = {
    HUNTER = {
      command = {
      },
      click = {
        ["ALT-SHIFT-Q"]               = "PetActionButton1",
      },
      spell = {
        ["2"]                         = "Kill Command",
        ["3"]                         = "Multi-Shot",
        ["4"]                         = "Arcane Shot",
        ["5"]                         = "Hunter's Mark",
        ["E"]                         = "Wing Clip",
        ["F"]                         = "Concussive Shot",
        ["SHIFT-F"]                   = "Serpent Sting",
        ["SHIFT-5"]                   = "Tranquilizing Shot",
        ["SHIFT-T"]                   = "Frost Trap",
        ["CTRL-T"]                    = "Freezing Trap",
        ["ALT-T"]                     = "Immolation Trap",
        ["SHIFT-ALT-T"]               = "Explosive Trap",
        ["CTRL-SHIFT-Q"]              = "Mend Pet",
        ["ALT-F"]                     = "Distracting Shot",
        ["ALT-T"]                     = "Snake Trap",
        ["ALT-CTRL-F"]                = "Scare Beast",
        ["ALT-CTRL-Q"]                = "Revive Pet",
        ["ALT-CTRL-S"]                = "Survey",
        ["ALT-CTRL-T"]                = "Explosive Trap",
        ["Z"]                         = "Disengage",
        ["CTRL-Z"]                    = "Feign Death",
        ["CTRL-F"]                    = "Wyvern Sting",       --Silencing Shot || Wyvern Sting MACRO
      },
      macro = {
        ["1"]                         = "Attack",
        ["SHIFT-E"]                   = "Melee",
        ["BUTTON4"]                   = "Mouse",
        ["ALT-BUTTON4"]               = "MouseAlt",
        ["G"]                         = "Call",
        ["Q"]                         = "PetControl",
        ["R"]                         = "R",
        ["SHIFT-SPACE"]               = "Mount",
        ["CTRL-Q"]                    = "PetSpecial",
        ["ALT-Z"]                     = "Peace",
        ["ALT-CTRL-A"]                = "Burst!",
      },
      item = {
        ["CTRL-X"]                    = "Linen Bandage",
      }
    },
  }
}