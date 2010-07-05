--INITIALIZE
local frame = CreateFrame("Button", "Slackwow", UIParent)
local events = {}

--BINDINGS
BINDING_HEADER_SLACKWOW = "Slackwow"
BINDING_NAME_ZENMODE = "Zen Mode"

--EVENT HANDLERS


--[[
function events:PLAYER_LOGIN(...)
    Slackwow_ZenMode()
end
]]

--Sell gray items. Adapted from tekJunkSeller.
function event:MERCHANT_SHOW()
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 0, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and select(3, GetItemInfo(link)) == 0 then
				ShowMerchantSellCursor(1)
				UseContainerItem(bag, slot)
			end
		end
	end
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

--Get rid of the minimenu and move the bar down.
--[[
for _, v in ipairs({"MainMenuBar", "MainMenuExpBar", "MainMenuBarMaxLevelBar", "ReputationWatchStatusBar", "ReputationWatchBar"}) do
    getglobal(v):SetWidth(1024);
end;
MainMenuBarTexture0:SetPoint("BOTTOM", MainMenuBar, "BOTTOM", -384, 0);
MainMenuBarTexture1:SetPoint("BOTTOM", MainMenuBar, "BOTTOM", -128, 0);
MainMenuBarLeftEndCap:SetPoint("BOTTOM", MainMenuBar, "BOTTOM", -544, 0);
MainMenuBarRightEndCap:SetPoint("BOTTOM", MainMenuBar, "BOTTOM", 544, 0);
MultiBarLeft:Show();
MultiBarLeftButton1:ClearAllPoints();
MultiBarLeftButton1:SetPoint("BOTTOMLEFT", ActionButton12, "BOTTOMRIGHT", 12, 0);
for i = 2, 12 do
    getglobal("MultiBarLeftButton" .. i):ClearAllPoints();
    getglobal("MultiBarLeftButton" .. i):SetPoint("BOTTOMLEFT", getglobal("MultiBarLeftButton" .. i-1), "BOTTOMRIGHT", 6, 0);
end;
]]

--Realign bottom of UI.
--[[
--for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0)
end
DEFAULT_CHAT_FRAME:ClearAllPoints()
DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent")
MainMenuBarLeftEndCap:Hide()
MainMenuBarRightEndCap:Hide()
MainMenuBar:ClearAllPoints()
MainMenuBar:SetPoint("BOTTOMRIGHT", "UIParent")
]]

--FINALZE
frame:SetScript("OnEvent",
    function(self, event, ...)
        events[event](self, ...)
    end
)
for k, v in pairs(events) do
    frame:RegisterEvent(k)
end
