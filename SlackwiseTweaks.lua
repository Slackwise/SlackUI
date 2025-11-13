local Self = LibStub["AceAddon-3.0"].NewAddon.SlackwiseTweaks["AceConsole-3.0"]["AceEvent-3.0"]
Self.config = LibStub["AceConfig-3.0"]
Self.frame = CreateFrame("Frame", "SlackwiseTweaks")
Self.itemBindingFrame = CreateFrame("Frame", "SlackwiseTweaks Item Bindings")
_G.SlackwiseTweaks = Self
Self.Self = Self
setmetatable(Self, {__index = _G})
setfenv(1, Self)
local addonName = Self.addonName
local addonTable = Self.addonTable
local dbDefaults = {global = {log = {}, isDebugging = false}, profile = {mounts = {ground = nil, ["ground-showoff"] = nil, skyriding = nil, ["skyriding-showoff"] = nil, steadyflight = nil, ["steadyflight-showoff"] = nil, water = nil, ["water-showoff"] = nil, ["ground-passenger"] = nil, ["ground-passenger-showoff"] = nil, ["skyriding-passenger"] = nil, ["skyriding-passenger-showoff"] = nil, ["steadyflight-passenger"] = nil, ["steadyflight-passenger-showoff"] = nil}}}
local function getBattletag()
  return select(2, BNGetInfo())
end
local function isSlackwise()
  return (getBattletag() == "Slackwise#1121")
end
local function isTester()
  return isSlackwise()
end
local function isRetail()
  if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
    return true
  else
    return false
  end
end
local function isClassic()
  if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
    return true
  else
    return false
  end
end
local function getGameType()
  return cond(isRetail(), "RETAIL", isClassic(), "CLASSIC", "else", "UNKNOWN")
end
local function isDebugging()
  if isInitialized() then
    return Self.db.global.isDebugging
  else
    if isSlackwise() then
      return true
    else
      return false
    end
  end
end
local COLOR_START = "|c"
local COLOR_END = "|r"
local function color(color0)
  local function _5_(text)
    return (COLOR_START .. "FF" .. color0 .. text .. COLOR_END)
  end
  return _5_
end
local grey = color("AAAAAA")
local function log(message, ...)
  local args = {...}
  if isDebugging() then
    print((grey(date()) .. "  " .. message))
    if isInitialized() then
      table.insert(Self.db.global.log, (date() .. "  " .. message))
      if args then
        for i, v in ipairs(args) do
          print(("Arg " .. i .. " = " .. v))
          table.insert(Self.db.global.log, ("Arg " .. i .. " = " .. v))
        end
        return nil
      else
        return nil
      end
    else
      return nil
    end
  else
    return nil
  end
end
local function OnInitialize(self)
  self.db = LibStub["AceDB-3.0"].New.SlackwiseTweaksDB[dbDefaults]
  do local _ = config.RegisterOptionsTable.SlackwiseTweaks[options].slack end
  self.configDialog = LibStub["AceConfigDialog-3.0"].AddToBlizOptions.SlackwiseTweaks
  return nil
end
local function isInitialized()
  return not not get(Self, "configDialog")
end
dofile("static-data.fnl")
dofile("core.fnl")
dofile("bindings.fnl")
dofile("options.fnl")
dofile("mount.fnl")
return dofile("slackwise.fnl")
