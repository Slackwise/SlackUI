local addon = _G.Slackwow

addon.bindingFunctions = {
  ["command"] = SetBinding,
  ["click"]   = SetBindingClick,
  ["spell"]   = SetBindingSpell,
  ["macro"]   = SetBindingMacro,
  ["item"]    = SetBindingItem
}

function addon.SetBinding(binding)
  local key   = binding[1]
  local type  = binding[2]
  local name  = binding[3]
  if type == "click" then
    addon.bindingFunctions[type](key, name, "LeftClick")
  else
    addon.bindingFunctions[type](key, name)
  end
end

function addon:SetBindings()
  LoadBindings(DEFAULT_BINDINGS)

  for _, binding in ipairs(addon.bindings.global) do
    addon.SetBinding(binding)
  end

  local class = string.lower(select(2, UnitClass("player")))
  local game
  if addon.IsClassic() then
    game = "classic"
  else
    game = "retail"
  end

  for _, binding in ipairs(addon.bindings[game][class]) do
    addon.SetBinding(binding)
  end
  
  if addon.IsClassic() then
    AttemptToSaveBindings(2)
  else
    SaveBindings(2)
  end
  
  print(game .. " " .. class .. " binding presets loaded!")
end

addon.bindings = {
  global = {
    {"F1",                    "command",  "TARGETPARTYMEMBER1"},
    {"F2",                    "command",  "TARGETPARTYMEMBER2"},
    {"F3",                    "command",  "TARGETPARTYMEMBER3"},
    {"F4",                    "command",  "TARGETPARTYMEMBER4"},
    {"F7",                    "command",  "TOGGLEFPS"},
    {"`",                     "command",  "NONE"},
    {"1",                     "command",  "NONE"},
    {"2",                     "command",  "NONE"},
    {"3",                     "command",  "NONE"},
    {"4",                     "command",  "NONE"},
    {"5",                     "command",  "NONE"},
    {"6",                     "command",  "NONE"},
    {"7",                     "command",  "NONE"},
    {"8",                     "command",  "NONE"},
    {"9",                     "command",  "NONE"},
    {"0",                     "command",  "NONE"},
    {"-",                     "command",  "NONE"},
    {"=",                     "command",  "NONE"},
    {"SHIFT-1",               "command",  "NONE"},
    {"SHIFT-2",               "command",  "NONE"},
    {"SHIFT-3",               "command",  "NONE"},
    {"SHIFT-4",               "command",  "NONE"},
    {"SHIFT-5",               "command",  "NONE"},
    {"SHIFT-6",               "command",  "NONE"},
    {"SHIFT-7",               "command",  "NONE"},
    {"SHIFT-8",               "command",  "NONE"},
    {"SHIFT-9",               "command",  "NONE"},
    {"SHIFT-0",               "command",  "NONE"},
    {"CTRL-1",                "command",  "NONE"},
    {"CTRL-2",                "command",  "NONE"},
    {"CTRL-3",                "command",  "NONE"},
    {"CTRL-4",                "command",  "NONE"},
    {"CTRL-5",                "command",  "NONE"},
    {"CTRL-6",                "command",  "NONE"},
    {"CTRL-7",                "command",  "NONE"},
    {"CTRL-8",                "command",  "NONE"},
    {"CTRL-9",                "command",  "NONE"},
    {"CTRL-0",                "command",  "NONE"},
    {",",                     "command",  "NONE"},
    {"SHIFT-R",               "command",  "NONE"},
    {"CTRL-R",                "command",  "NONE"},
    {"CTRL-S",                "command",  "NONE"},
    {"CTRL-H",                "command",  "TOGGLEUI"},
    {"CTRL-L",                "command",  "TOGGLEACTIONBARLOCK"},
    {"ALT-C",                 "command",  "TOGGLECHARACTER0"},
    {"X",                     "command",  "TOGGLESHEATH"},
    {"V",                     "command",  "NONE"},
    {"SHIFT-V",               "command",  "NONE"},
    {"CTRL-V",                "command",  "NONE"},
    {"B",                     "command",  "TOGGLEBACKPACK"},
    {"SHIFT-B",               "command",  "OPENALLBAGS"},
    {"CTRL-M",                "command",  "TOGGLEMUSIC"},
    {"ALT-M",                 "command",  "TOGGLESOUND"},
    {"SHIFT-UP",              "command",  "NONE"},
    {"SHIFT-DOWN",            "command",  "NONE"},
    {"SHIFT-ENTER",           "command",  "REPLY"},
    {"CTRL-ENTER",            "command",  "REPLY2"},
    {"SHIFT-SPACE",           "macro",    "Mount"},
    {"SHIFT-HOME",            "command",  "SETVIEW1"},
    {"HOME",                  "command",  "SETVIEW2"},
    {"END",                   "command",  "SETVIEW3"},
    {"PRINTSCREEN",           "command",  "SCREENSHOT"},
    {"NUMLOCK",               "command",  "NONE"},
    {"NUMPAD0",               "command",  "RAIDTARGET8"},
    {"NUMPAD1",               "command",  "RAIDTARGET7"},
    {"NUMPAD2",               "command",  "RAIDTARGET2"},
    {"NUMPAD3",               "command",  "RAIDTARGET4"},
    {"NUMPAD4",               "command",  "RAIDTARGET6"},
    {"NUMPAD5",               "command",  "RAIDTARGET5"},
    {"NUMPAD6",               "command",  "RAIDTARGET1"},
    {"NUMPAD7",               "command",  "RAIDTARGET3"},
    {"NUMPADDECIMAL",         "command",  "RAIDTARGETNONE"},
    {"BUTTON3",               "command",  "TOGGLEAUTORUN"},
    {"SHIFT-MOUSEWHEELUP",    "command",  "NONE"},
    {"SHIFT-MOUSEWHEELDOWN",  "command",  "NONE"}
  },
  retail = {
    hunter = {
      {"`",                         "macro",     "Stop"},
      {"1",                         "spell",     "Sniper Shot"},
      {"2",                         "command",   "NONE"},
      {"3",                         "spell",     "Multi-Shot"},
      {"4",                         "spell",     "Arcane Shot"},
      {"SHIFT-4",                   "spell",     "Aimed Shot"},
      {"5",                         "spell",     "A Murder of Crows"},
      {"6",                         "macro",     "ChainEagle"},
      {"7",                         "command",   "NONE"},
      {"8",                         "command",   "NONE"},
      {"9",                         "command",   "NONE"},
      {"0",                         "command",   "NONE"},
      {"-",                         "command",   "NONE"},
      {"=",                         "command",   "NONE"},
      {"Q",                         "macro",     "PetControl"},
      {"CTRL-Q",                    "macro",     "PetSpecial"},
      {"ALT-SHIFT-Q",               "click",     "PetActionButton1"},
      {"CTRL-SHIFT-Q",              "spell",     "Mend Pet"},
      {"ALT-CTRL-Q",                "spell",     "Revive Pet"},
      {"E",                         "spell",     "Bursting Shot"},
      {"ALT-E",                     "macro",     "MD"},
      {"R",                         "spell",     "Steady Shot"},
      {"SHIFT-R",                   "spell",     "Rapid Fire"},
      {"CTRL-R",                    "spell",     "Trueshot"},
      {"T",                         "spell",     "Flare"},
      {"SHIFT-T",                   "spell",     "Tar Trap"},
      {"CTRL-T",                    "spell",     "Freezing Trap"},
      {"ALT-CTRL-S",                "macro",     "Survey"},
      {"F",                         "spell",     "Concussive Shot"},
      {"SHIFT-F",                   "spell",     "Scatter Shot"},
      {"CTRL-F",                    "spell",     "Counter Shot"},
      {"ALT-F",                     "spell",     "Binding Shot"},
      {"Z",                         "spell",     "Camouflage"},
      {"CTRL-Z",                    "spell",     "Feign Death"},
      {"ALT-Z",                     "macro",     "Peace"},
      {"V",                         "spell",     "Exhilaration"},
      {"SHIFT-V",                   "spell",     "Survival of the Fittest"},
      {"CTRL-V",                    "spell",     "Aspect of the Turtle"},
      {"ALT-CTRL-V",                "item",      "Dense Embersilk Bandage"},
      {"C",                         "spell",     "Aspect of the Cheetah"},
      {"SHIFT-C",                   "spell",     "Gladiator's Medallion"},
      {"CTRL-C",                    "macro",     "Call"},
      {",",                         "command",   "NONE"},
      {"CTRL-SPACE",                "spell",     "Disengage"},
      {"BUTTON4",                   "macro",     "Mouse"},
      {"ALT-BUTTON4",               "macro",     "MouseAlt"}
    }
  },
  classic = {
    hunter = {
      {"1",                         "macro",     "Attack"},
      {"2",                         "spell",     "Kill Command"},
      {"3",                         "spell",     "Multi-Shot"},
      {"4",                         "spell",     "Arcane Shot"},
      {"5",                         "spell",     "Hunter's Mark"},
      {"SHIFT-5",                   "spell",     "Tranquilizing Shot"},
      {"Q",                         "macro",     "PetControl"},
      {"CTRL-Q",                    "macro",     "PetSpecial"},
      {"CTRL-SHIFT-Q",              "spell",     "Mend Pet"},
      {"ALT-CTRL-Q",                "spell",     "Revive Pet"},
      {"E",                         "spell",     "Wing Clip"},
      {"SHIFT-E",                   "macro",     "Melee"},
      {"R",                         "macro",     "R"},
      {"SHIFT-T",                   "spell",     "Frost Trap"},
      {"CTRL-T",                    "spell",     "Freezing Trap"},
      {"ALT-T",                     "spell",     "Immolation Trap"},
      {"SHIFT-ALT-T",               "spell",     "Explosive Trap"},
      {"ALT-CTRL-T",                "spell",     "Explosive Trap"},
      {"ALT-CTRL-A",                "macro",     "Burst!"},
      {"ALT-CTRL-S",                "spell",     "Survey"},
      {"F",                         "spell",     "Concussive Shot"},
      {"SHIFT-F",                   "spell",     "Serpent Sting"},
      {"CTRL-F",                    "spell",     "Wyvern Sting"},
      {"ALT-F",                     "spell",     "Distracting Shot"},
      {"ALT-CTRL-F",                "spell",     "Scare Beast"},
      {"G",                         "macro",     "Call"},
      {"Z",                         "spell",     "Disengage"},
      {"CTRL-Z",                    "spell",     "Feign Death"},
      {"ALT-Z",                     "macro",     "Peace"},
      {"CTRL-X",                    "item",      "Linen Bandage"},
      {"BUTTON4",                   "macro",     "Mouse"},
      {"ALT-BUTTON4",               "macro",     "MouseAlt"}
    }
  }
}

