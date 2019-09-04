local addon = _G.Slackwow

addon.bindingFunctions = {
  ["command"] = SetBinding,
  ["click"]   = SetBindingClick,
  ["spell"]   = SetBindingSpell,
  ["macro"]   = SetBindingMacro,
  ["item"]    = SetBindingItem
}

function addon:SetBinding(bindingArray)
  local key = binding[0]
  local type = binding[1]
  local name = [binding[2]
  if type = "click" then
    bindingFunctions[type](key, name, "LeftClick")
  else
    bindingFunctions[type](key, name)
  end
end

function addon:SetBindings()
  LoadBindings(DEFAULT_BINDINGS)

  for _, binding in ipairs(addon.bindings.global) do
    addon:SetBinding(binding)
  end

  local class = string.lower(select(2, UnitClass("player")))
  local game
  if addon:IsClassic() then
    game = "classic"
  else
    game = "retail"
  end

  for _, binding in ipairs(addon.bindings[game][class]) do
    addon:SetBinding(binding)
  end
  
  if addon:IsClassic() then
    AttemptToSaveBindings(2)
  else
    SaveBindings(2)
  end
  
  print(game .. " " .. class .. " binding presets loaded!")
end

addon.bindings = {
  global {
    ["F1"                    "command",  "TARGETPARTYMEMBER1"],
    ["F2"                    "command",  "TARGETPARTYMEMBER2"],
    ["F3"                    "command",  "TARGETPARTYMEMBER3"],
    ["F4"                    "command",  "TARGETPARTYMEMBER4"],
    ["F7"                    "command",  "TOGGLEFPS"],
    ["`"                     "command",  "NONE"],
    ["1"                     "command",  "NONE"],
    ["2"                     "command",  "NONE"],
    ["3"                     "command",  "NONE"],
    ["4"                     "command",  "NONE"],
    ["5"                     "command",  "NONE"],
    ["6"                     "command",  "NONE"],
    ["7"                     "command",  "NONE"],
    ["8"                     "command",  "NONE"],
    ["9"                     "command",  "NONE"],
    ["0"                     "command",  "NONE"],
    ["-"                     "command",  "NONE"],
    ["="                     "command",  "NONE"],
    ["SHIFT-1"               "command",  "NONE"],
    ["SHIFT-2"               "command",  "NONE"],
    ["SHIFT-3"               "command",  "NONE"],
    ["SHIFT-4"               "command",  "NONE"],
    ["SHIFT-5"               "command",  "NONE"],
    ["SHIFT-6"               "command",  "NONE"],
    ["SHIFT-7"               "command",  "NONE"],
    ["SHIFT-8"               "command",  "NONE"],
    ["SHIFT-9"               "command",  "NONE"],
    ["SHIFT-0"               "command",  "NONE"],
    ["CTRL-1"                "command",  "NONE"],
    ["CTRL-2"                "command",  "NONE"],
    ["CTRL-3"                "command",  "NONE"],
    ["CTRL-4"                "command",  "NONE"],
    ["CTRL-5"                "command",  "NONE"],
    ["CTRL-6"                "command",  "NONE"],
    ["CTRL-7"                "command",  "NONE"],
    ["CTRL-8"                "command",  "NONE"],
    ["CTRL-9"                "command",  "NONE"],
    ["CTRL-0"                "command",  "NONE"],
    [","                     "command",  "NONE"],
    ["ALT-C"                 "command",  "TOGGLECHARACTER0"],
    ["B"                     "command",  "TOGGLEBACKPACK"],
    ["SHIFT-B"               "command",  "OPENALLBAGS"],
    ["SHIFT-R"               "command",  "NONE"],
    ["CTRL-R"                "command",  "NONE"],
    ["CTRL-S"                "command",  "NONE"],
    ["CTRL-H"                "command",  "TOGGLEUI"],
    ["CTRL-L"                "command",  "TOGGLEACTIONBARLOCK"],
    ["CTRL-M"                "command",  "TOGGLEMUSIC"],
    ["ALT-M"                 "command",  "TOGGLESOUND"],
    ["SHIFT-UP"              "command",  "NONE"],
    ["SHIFT-DOWN"            "command",  "NONE"],
    ["SHIFT-ENTER"           "command",  "REPLY"],
    ["CTRL-ENTER"            "command",  "REPLY2"],
    ["SHIFT-SPACE"           "macro",    "Mount"],
    ["SHIFT-HOME"            "command",  "SETVIEW1"],
    ["HOME"                  "command",  "SETVIEW2"],
    ["END"                   "command",  "SETVIEW3"],
    ["PRINTSCREEN"           "command",  "SCREENSHOT"],
    ["NUMLOCK"               "command",  "NONE"],
    ["NUMPAD0"               "command",  "RAIDTARGET8"],
    ["NUMPAD1"               "command",  "RAIDTARGET7"],
    ["NUMPAD2"               "command",  "RAIDTARGET2"],
    ["NUMPAD3"               "command",  "RAIDTARGET4"],
    ["NUMPAD4"               "command",  "RAIDTARGET6"],
    ["NUMPAD5"               "command",  "RAIDTARGET5"],
    ["NUMPAD6"               "command",  "RAIDTARGET1"],
    ["NUMPAD7"               "command",  "RAIDTARGET3"],
    ["NUMPADDECIMAL"         "command",  "RAIDTARGETNONE"],
    ["BUTTON3",              "command",  "TOGGLEAUTORUN"],
    ["SHIFT-MOUSEWHEELUP"    "command",  "NONE"],
    ["SHIFT-MOUSEWHEELDOWN"  "command",  "NONE"],
  },
  retail = {
    hunter = {
      ["F5"                        "macro",     "ModeSwitch"],
      ["`"                         "command",   "ACTIONBUTTON1",        --StopAttack MACRO
      ["0"                         "command",   "NONE"],
      ["1"                         "macro",     "Engage"],
      ["2"                         "spell",     "Kill Command"],
      ["3"                         "command",   "ACTIONBUTTON4",        --Chimera Shot || Explosive Shot
      ["CTRL-3"                    "spell",     "Multi-Shot"],
      ["SHIFT-3"                   "command",   "ACTIONBUTTON3",        --Aimed Shot
      ["4"                         "command",   "ACTIONBUTTON5",        --Steady Shot || Cobra Shot
      ["SHIFT-4"                   "spell",     "Arcane Shot"],
      ["CTRL-4"                    "spell",     "Cobra Shot"],
      ["5"                         "command",   "ACTIONBUTTON6",        --Kill Shot
      ["SHIFT-5"                   "spell",     "Tranquilizing Shot"],
      ["6"                         "command",   "NONE"],
      ["7"                         "command",   "NONE"],
      ["8"                         "command",   "NONE"],
      ["9"                         "command",   "NONE"],
      ["-"                         "command",   "NONE"],
      ["Q"                         "macro",     "PetControl"],
      ["CTRL-Q"                    "macro",     "PetSpecial"],
      ["ALT-SHIFT-Q"               "click",     "PetActionButton1"],
      ["CTRL-SHIFT-Q"              "spell",     "Mend Pet"],
      ["ALT-CTRL-Q"                "spell",     "Revive Pet"],
      ["E"                         "spell",     "Wing Clip"],
      ["SHIFT-E"                   "command",   "ACTIONBUTTON2",        --Raptor Strike
      ["CTRL-E"                    "command",   "ACTIONBUTTON7",        --Scatter MACRO
      ["ALT-E"                     "macro",     "MD"],
      ["R"                         "macro",     "R"],
      ["T"                         "command",   "ACTIONBUTTON8",        --Deterrence
      ["SHIFT-T"                   "spell",     "Ice Trap"],
      ["CTRL-T"                    "spell",     "Freezing Trap"],
      ["ALT-T"                     "spell",     "Snake Trap"],
      ["ALT-CTRL-T"                "spell",     "Explosive Trap"],
      ["ALT-CTRL-A"                "macro",     "Burst!"],
      ["ALT-CTRL-S"                "spell",     "Survey"],
      ["F"                         "command",   "ACTIONBUTTON10",       --Concussive Shot
      ["SHIFT-F"                   "spell",     "Serpent Sting"],
      ["CTRL-F"                    "command",   "ACTIONBUTTON12",       --Silencing Shot || Wyvern Sting MACRO
      ["ALT-F"                     "spell",     "Distracting Shot"],
      ["ALT-CTRL-F"                "spell",     "Scare Beast"],
      ["G"                         "macro",     "Call"],
      ["CTRL-G"                    "spell",     "Readiness"],
      ["CTRL-Z"                    "command",   "ACTIONBUTTON11",       --Feign Death
      ["ALT-Z"                     "macro",     "Peace"],
      ["CTRL-X"                    "item",      "Dense Embersilk Bandage"]
      ["C"                         "spell",     "Camouflage"],
      [","                         "command",   "NONE"],
      ["CTRL-SPACE"                "command",   "ACTIONBUTTON9",        --Disengage
      ["BUTTON4"                   "macro",     "Mouse"],
      ["ALT-BUTTON4"               "macro",     "MouseAlt"],
    },
  },
  classic = {
    hunter = {
      ["1"                         "macro",     "Attack"],
      ["2"                         "spell",     "Kill Command"],
      ["3"                         "spell",     "Multi-Shot"],
      ["4"                         "spell",     "Arcane Shot"],
      ["5"                         "spell",     "Hunter's Mark"],
      ["SHIFT-5"                   "spell",     "Tranquilizing Shot"],
      ["Q"                         "macro",     "PetControl"],
      ["CTRL-Q"                    "macro",     "PetSpecial"],
      ["CTRL-SHIFT-Q"              "spell",     "Mend Pet"],
      ["ALT-CTRL-Q"                "spell",     "Revive Pet"],
      ["E"                         "spell",     "Wing Clip"],
      ["SHIFT-E"                   "macro",     "Melee"],
      ["R"                         "macro",     "R"],
      ["SHIFT-T"                   "spell",     "Frost Trap"],
      ["CTRL-T"                    "spell",     "Freezing Trap"],
      ["ALT-T"                     "spell",     "Immolation Trap"],
      ["SHIFT-ALT-T"               "spell",     "Explosive Trap"],
      ["ALT-CTRL-T"                "spell",     "Explosive Trap"],
      ["ALT-CTRL-A"                "macro",     "Burst!"],
      ["ALT-CTRL-S"                "spell",     "Survey"],
      ["F"                         "spell",     "Concussive Shot"],
      ["SHIFT-F"                   "spell",     "Serpent Sting"],
      ["CTRL-F"                    "spell",     "Wyvern Sting"],       --Silencing Shot || Wyvern Sting MACRO
      ["ALT-F"                     "spell",     "Distracting Shot"],
      ["ALT-CTRL-F"                "spell",     "Scare Beast"],
      ["G"                         "macro",     "Call"],
      ["Z"                         "spell",     "Disengage"],
      ["CTRL-Z"                    "spell",     "Feign Death"],
      ["ALT-Z"                     "macro",     "Peace"],
      ["CTRL-X"                    "item",      "Linen Bandage"]
      ["BUTTON4"                   "macro",     "Mouse"],
      ["ALT-BUTTON4"               "macro",     "MouseAlt"],
    }
  }
}