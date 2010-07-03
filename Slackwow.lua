--INITIALIZE
local frame = CreateFrame("Button", "Slackwow", UIParent)
local events = {}

--BINDINGS
BINDING_HEADER_SLACKWOW = "Slackwow"
BINDING_NAME_ZENMODE = "Zen Mode"

--EVENT HANDLERS
function events:PLAYER_ENTERING_WORLD(...)
    Slackwow_ZenMode()
end

--[[
local function events:PLAYER_EQUIPMENT_CHANGED(slot, hasItem)
    if InCombat() then return
    if select(6, GetItemInfo(GetInventoryItemID("player", slot))) == "Fishing Poles" then
        --Right-click to cast.
        if not frame:IsHooked(WorldFrame, "OnMouseDown") then
            frame:HookScript(WorldFrame, "OnMouseDown",
                function()
                end
            )
        end
    else
        --Undo right-click casting.
        if frame:IsHooked(WorldFrame, "OnMouseDown") then
            frame:Unhook(WorldFrame, "OnMouseDown")
        end
    end
end
]]

--ZEN MODE
function Slackwow_ZenMode()
    if SexyCooldownMAIN ~= nil then
        SexyCooldownMAIN:SetParent(nil)
    else
        return
    end
    if not SexyCooldownMAIN:IsVisible() then
        --ZEN MODE ON
        MinimapCluster:Hide()
        MainMenuBar:Hide()
        MultiBarBottomRight:Hide()
        SexyCooldownMAIN:Show()
    else
        --ZEN MODE OFF
        MinimapCluster:Show()
        MainMenuBar:Show()
        MultiBarBottomRight:Show()
        SexyCooldownMAIN:Hide()
    end
end

--FINALZE
frame:SetScript("OnEvent",
    function(self, event, ...)
        events[event](self, ...)
    end
)
for k, v in pairs(events) do
    frame:RegisterEvent(k)
end
