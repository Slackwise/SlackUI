--INITIALIZE
local Self = LibStub("AceAddon-3.0"):NewAddon(
  "SlackUI",
  "AceConsole-3.0",
  "AceEvent-3.0"
)
Self.config = LibStub("AceConfig-3.0")
Self.frame = CreateFrame("Frame", "SlackUI")
Self.itemBindingFrame = CreateFrame("Frame", "SlackUI Item Bindings")
_G.SlackUI = Self
Self.Self = Self
setmetatable(Self, {__index = _G}) -- The global environment is now checked if a key is not found in addon
setfenv(1, Self) -- Namespace local to addon

addonName, addonTable = ...

dbDefaults = {
  global = {
    isDebugging = false,
    log = {}
  },
  char = {
    mounts = {
      ["ground"] = nil,
      ["ground-showoff"] = nil,
      ["skyriding"] = nil,
      ["skyriding-showoff"] = nil,
      ["steadyflight"] = nil,
      ["steadyflight-showoff"] = nil,
      ["water"] = nil,
      ["water-showoff"] = nil,
      ["ground-passenger"] = nil,
      ["ground-passenger-showoff"] = nil,
      ["skyriding-passenger"] = nil,
      ["skyriding-passenger-showoff"] = nil,
      ["steadyflight-passenger"] = nil,
      ["steadyflight-passenger-showoff"] = nil,
    }
  }
}

function isDebugging()
  return db.global.isDebugging
end

COLOR_START = "\124c"
COLOR_END   = "\124r"

function color(color)
  return function(text)
    return COLOR_START .. "FF" .. color .. text .. COLOR_END
  end
end

grey = color("AAAAAA")

function log(message, ...)
  if isDebugging() then
    print(grey(date()) .. "  " .. message)
    table.insert(db.global.log, date() .. "  " .. message)
    if arg then
      for i, v in ipairs(arg) do
        print("Arg " .. i .. " = " .. v)
        table.insert(db.global.log, "Arg " .. i .. " = " .. v)
      end
    end
  end
end

--Event Handlers
function Self:OnInitialize()
  Self.db = LibStub("AceDB-3.0"):New("SlackUIDB", dbDefaults, true)
  config:RegisterOptionsTable("SlackUI", options, "slack")
end