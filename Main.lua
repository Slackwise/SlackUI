--INITIALIZE
local Self = LibStub("AceAddon-3.0"):NewAddon(
	"SlackUI",
	"AceConsole-3.0",
	"AceEvent-3.0"
)
Self.config = LibStub("AceConfig-3.0")
Self.frame = CreateFrame("Frame", "SlackUI")
_G.SlackUI = Self
Self.Self = Self
setmetatable(Self, {__index = _G}) -- The global environment is now checked if a key is not found in addon
setfenv(1, Self) -- Namespace local to addon

addonName, addonTable = ...

dbDefaults = {
	profile = {
		isDebugging = false
	}
}

--[[
	General API Documentation:
	https://wow.gamepedia.com/World_of_Warcraft_API
	https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentation
]]--

function isDebugging()
	return SlackUIDB.isDebugging
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
		if arg then
			for i, v in ipairs(arg) do
				print("Arg " .. i .. " = " .. v)
			end
		end
	end
end

--Event Handlers
function Self:OnInitialize()
	Self.db = LibStub("AceDB-3.0"):New("SlackUIDB", dbDefaults, true)
	config:RegisterOptionsTable("SlackUI", options, "slack")

	setMaxCameraDistance()
end

function Self:OnEnable()
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	-- self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function Self:OnDisable()
end

function Self:PLAYER_ENTERING_WORLD(eventName, isLogin, isReload) -- Out of combat
	handleDragonriding()
end

function Self:MERCHANT_SHOW(eventName)
	repairAllItems()
	-- sellGreyItems()
end

function Self:PLAYER_REGEN_ENABLED(eventName) -- Out of combat
	handleDragonriding()
end

function Self:PLAYER_REGEN_DISABLED(eventName) -- In combat

end

function Self:UNIT_AURA(eventName, unitTarget, updateInfo) -- https://wowpedia.fandom.com/wiki/UNIT_AURA
	if unitTarget == "player" then
		log("Aura handling dragonriding...")
		handleDragonriding()
	end
end

function handleDragonriding(markDragonriding)
	if isTester() then
		if markDragonriding ~= nil then
			isDragonriding(markDragonriding)
		end 
		if isDragonriding() then
			bindDragonriding()
		else
			unbindDragonriding()
		end
	end
end

isDragonridingBound = false

function bindDragonriding()
	if not InCombatLockdown() and not isDragonridingBound then
		SetOverrideBindingSpell(Self.frame, true, "BUTTON3", "Skyward Ascent")
		SetOverrideBindingSpell(Self.frame, true, "BUTTON5", "Surge Forward")
		isDragonridingBound = true
		log("Dragonriding keys BOUND")
	end 
end

function unbindDragonriding()
	if not InCombatLockdown() and isDragonridingBound then
		ClearOverrideBindings(Self.frame)
		isDragonridingBound = false
		log("Dragonriding keys CLEARED")
	end
end

isDragonridingFlag = nil
function isDragonriding(dragonriding)
	if dragonriding ~= nil then
		isDragonridingFlag = dragonriding
		return dragonRidingFlag
	end

	if isDragonridingFlag == nil then
		isDragonridingFlag = isCurrentlyDragonriding()
	end
	
	return isDragonridingFlag
end

function isCurrentlyDragonriding()
	log("Checking if dragonriding...")
	local dragonridingSpellIds = C_MountJournal.GetCollectedDragonridingMounts()
	if IsMounted() then
		for _, mountId in ipairs(dragonridingSpellIds) do
			local spellId = select(2, C_MountJournal.GetMountInfoByID(mountId))
			if C_UnitAuras.GetPlayerAuraBySpellID(spellId) then
				return true
			end
		end
	end
	return false
end


function inVehicle()
	return UnitHasVehicleUI("player")
end

function getBattletag()
	return select(2, BNGetInfo())
end

function isSlackwise()
	return getBattletag() == "Slackwise#1121" or false
end

-- Gatekeeping new features with no UI
function isTester()
	-- Use a checkbox in settings later, probably, but right now it's just me
	return isSlackwise()
end

function getClassName()
	return select(2, UnitClass("player"))
end

function getSpecName()
	return strupper(select(2, GetSpecializationInfo(GetSpecialization())))
end

function setMaxCameraDistance()
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
end

function repairAllItems()
	if CanMerchantRepair() then
		RepairAllItems() -- #TODO: pass `true` for guild repairs if currently raiding with guild
	end
end

function sellGreyItems()
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 0, C_Container.GetContainerNumSlots(bag) do
			local link = C_Container.GetContainerItemLink(bag, slot)
			if link and select(3, GetItemInfo(link)) == 0 then
				C_Container.UseContainerItem(bag, slot)
			end
		end
	end
end

--- Recursively search up the map hierarchy to find a specific map type.
-- @param map - The map to start at.
-- @param upMapType - An Enum.UIMapType of the map you're trying to find.
-- @return UiMapDetails
function findParentMapByType(map, uiMapType)
	if map.mapType == uiMapType or map.mapType == Enum.UIMapType.Cosmic then
		return map
	end 
	return findParentMapByType(C_Map.GetMapInfo(map.parentMapID), uiMapType)
end

function getCurrentMap()
	return C_Map.GetMapInfo((C_Map.GetBestMapForUnit("player")))
end

function getCurrentContinent()
	return findParentMapByType(getCurrentMap(), Enum.UIMapType.Continent)
end

function getCurrentZone()
	return findParentMapByType(getCurrentMap(), Enum.UIMapType.Zone)
end

ACTUALLY_FLYABLE_MAPS = {
	CONTINENTS = {
		619, -- Broken Isles
	},
	ZONES = {
	}
}

NOT_ACTUALLY_FLYABLE_MAPS = {
	CONTINENTS = {
		905,	-- Argus
	},
	ZONES = {
	}
}

function isActuallyFlyableArea()
	local continentID = getCurrentContinent().mapID
	local zoneID 			= getCurrentZone().mapID

	local listedFlyableContinent    = not not tContains(	   ACTUALLY_FLYABLE_MAPS.CONTINENTS,  continentID  )
	local listedFlyableZone         = not not tContains(	   ACTUALLY_FLYABLE_MAPS.ZONES,       zoneID       )

	local listedNonFlyableContinent = not not tContains(	NOT_ACTUALLY_FLYABLE_MAPS.CONTINENTS,  continentID  )
	local listedNonFlyableZone      = not not tContains(	NOT_ACTUALLY_FLYABLE_MAPS.ZONES,       zoneID       )

	local listedFlyable             = listedFlyableContinent    or listedFlyableZone
	local listedNonFlyable          = listedNonFlyableContinent or listedNonFlyableZone

	if listedNonFlyable then
		return false
	end

	if listedFlyable then
		return true
	end

	return IsFlyableArea()
end

function printDebugMapInfo()
	local map = getCurrentMap()
	local zone = getCurrentZone()
	local continent = getCurrentContinent()
	local parentMap = C_Map.GetMapInfo(map.parentMapID)
	print("MapID: " .. map.mapID)
	print("===============================")
	print(map.name .. ", " .. parentMap.name)
	print("Zone: "      .. zone.name .. " (" .. zone.mapID .. ')')
	print("Continent: " .. continent.name .. " (" .. continent.mapID .. ')')
	print("-------------------------------------------------------") -- Chat window does not used fixed width; trying to match header
	print("mapID: "       .. map.mapID)
	print("parentMapID: " .. map.parentMapID)
	print("mapType: "     .. Enum.UIMapType[map.mapType] .. '('..map.mapType..')')
	print("Outdoor: "     .. tostring(IsOutdoors()))
	print("Submerged: "   .. tostring(IsSubmerged()))
	print("Flyable: "     .. tostring(IsFlyableArea()))
	print("ActuallyFlyable: " .. tostring(isActuallyFlyableArea()))
	print("===============================")
end

MOUNT_IDS = { -- from https://wowpedia.fandom.com/wiki/MountID
	["Swift Razzashi Raptor"] = 110,
	["Ashes of Al'ar"]        = 183,
	["Sea Turtle"]            = 312,
	["Renewed Proto-Drake"]   = 1589
}

MOUNT_FAVORITES = {
	['RAPTOR']    = MOUNT_IDS["Swift Razzashi Raptor"],
	['PHOENIX']   = MOUNT_IDS["Ashes of Al'ar"],
	['TURTLE']    = MOUNT_IDS["Sea Turtle"],
	['DRAGON']    = MOUNT_IDS["Renewed Proto-Drake"]
}

MOUNTS_BY_USAGE = {
	['GROUND'] = MOUNT_FAVORITES.RAPTOR,
	['FLYING'] = MOUNT_FAVORITES.PHOENIX,
	['WATER']  = MOUNT_FAVORITES.TURTLE,
	['DRAGON'] = MOUNT_FAVORITES.DRAGON -- Dragonriding
}

function mountByUsage(usage)
	C_MountJournal.SummonByID(MOUNTS_BY_USAGE[usage])
	if usage == "DRAGON" then
		isDragonriding(true)
	else
		isDragonriding(false)
	end
end

function isAlternativeMountRequested()
	return IsControlKeyDown()
end

function mount()  
	if IsMounted() then
		Dismount()
		isDragonriding(false)
		return
	end

	if UnitUsingVehicle("player") then
		VehicleExit()
		return
	end

	if IsOutdoors() then
		if isActuallyFlyableArea() and not IsSubmerged() then -- Summon flying mount
			if isAlternativeMountRequested() then -- But we may want to show off our ground mount
				mountByUsage("GROUND")
				return
			end
			mountByUsage("FLYING")
			return
		elseif IsAdvancedFlyableArea() and not IsSubmerged() then -- Summon dragonriding mount
			if isAlternativeMountRequested() and isActuallyFlyableArea() then -- But we may want to show off our ground mount
				mountByUsage("FLYING")
				return
			elseif isAlternativeMountRequested() then
				mountByUsage("GROUND")
				return
			end
			mountByUsage("DRAGON")
			return
		elseif IsSubmerged() then -- Summon water mount
			if isAlternativeMountRequested() then -- But we may want to fly out of the water
				mountByUsage("FLYING")
				return
			end
			mountByUsage("WATER")
			return
		else -- Summon ground mount
			if isAlternativeMountRequested() then -- But we may want to show off our flying mount
				mountByUsage("FLYING")
				return
			end
			mountByUsage("GROUND")
			return
		end
	end
end


--[[ -- TODO: Update broken fishing pole right-click handler
function events:PLAYER_EQUIPMENT_CHANGED(slot, hasItem)
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
