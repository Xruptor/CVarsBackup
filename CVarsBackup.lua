local ADDON_NAME, addon = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BackdropTemplateMixin and "BackdropTemplate")
end
addon = _G[ADDON_NAME]

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local debugf = tekDebug and tekDebug:GetFrame(ADDON_NAME)
local function Debug(...)
    if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end
end

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" or event == "PLAYER_LOGIN" then
		if event == "ADDON_LOADED" then
			local arg1 = ...
			if arg1 and arg1 == ADDON_NAME then
				self:UnregisterEvent("ADDON_LOADED")
				self:RegisterEvent("PLAYER_LOGIN")
			end
			return
		end
		if IsLoggedIn() then
			self:EnableAddon(event, ...)
			self:UnregisterEvent("PLAYER_LOGIN")
		end
		return
	end
	if self[event] then
		return self[event](self, event, ...)
	end
end)

local IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

--Blizzard_Console_AutoComplete.lua Enum.ConsoleCategory
local CategoryNames = {
	[0] = "Debug",
	[1] = "Graphics",
	[2] = "Console",
	[3] = "Combat",
	[4] = "Game",
	[5] = "Default",
	[6] = "Net",
	[7] = "Sound",
	[8] = "GM",
	[9] = "None",
}

local function GetHashTableLen(tbl)
	local count = 0
	for _, __ in pairs(tbl) do
		count = count + 1
	end
	return count
end

local function GetCVars()

	local xGetAllCommands = (C_Console and C_Console.GetAllCommands) or ConsoleGetAllCommands
	if not xGetAllCommands then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: %s", ADDON_NAME, L.NoCmds))
		return
	end
	local t = {}

	for _, info in pairs(xGetAllCommands()) do
		if info.commandType == 0 --Use CVar not scripts
			and info.category ~= 0 --Ignore Debug Category from Enum.ConsoleCategory
			and not strfind(info.command:lower(), 'debug') -- Ignore commands with "debug" in their names
			and info.category ~= 8 --Ignore GM Category from Enum.ConsoleCategory
		then
			local value = GetCVar(info.command)
			t[info.command] = value
		end
	end
	return t
end

local function RestoreCVars()
	if not CVarsBkp_DB or GetHashTableLen(CVarsBkp_DB) <= 0 then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: %s", ADDON_NAME, L.Invalid))
		return
	end

	local xGetAllCommands = (C_Console and C_Console.GetAllCommands) or ConsoleGetAllCommands
	if not xGetAllCommands then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: %s", ADDON_NAME, L.NoCmds))
		return
	end

	--first lets restore our stored values
	for k, value in pairs(CVarsBkp_DB) do
		SetCVar(k, value)
	end

	for _, info in pairs(xGetAllCommands()) do
		if info.commandType == 0 --Use CVar not scripts
			and info.category ~= 0 --Ignore Debug Category from Enum.ConsoleCategory
			and not strfind(info.command:lower(), 'debug') -- Ignore commands with "debug" in their names
			and info.category ~= 8 --Ignore GM Category from Enum.ConsoleCategory
			and not CVarsBkp_DB[info.command]
		then
			--if we don't have it on our saved list then it's probably nil, so lets set that
			SetCVar(info.command, nil)
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: %s", ADDON_NAME, L.RestoreComplete))
end

local function CheckDiffs()
	if not CVarsBkp_DB or GetHashTableLen(CVarsBkp_DB) <= 0 then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: %s", ADDON_NAME, L.Invalid))
		return
	end

	local xGetAllCommands = (C_Console and C_Console.GetAllCommands) or ConsoleGetAllCommands
	if not xGetAllCommands then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: %s", ADDON_NAME, L.NoCmds))
		return
	end

	for _, info in pairs(xGetAllCommands()) do
		if info.commandType == 0 --Use CVar not scripts
			and info.category ~= 0 --Ignore Debug Category from Enum.ConsoleCategory
			and not strfind(info.command:lower(), 'debug') -- Ignore commands with "debug" in their names
			and info.category ~= 8 --Ignore GM Category from Enum.ConsoleCategory
		then
			local value = GetCVar(info.command)
			if CVarsBkp_DB[info.command] ~= nil then
				if CVarsBkp_DB[info.command] ~= value then
					DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: |cFF20ff20DB:|r %s  |  |cFF20ff20Curr:|r %s", info.command, tostring(info.command),  tostring(value)))
				end
			else
				if value ~= nil then
					DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: |cFFFF6347DB:|r %s  |  |cFFFF6347Curr:|r %s", info.command, "NIL",  tostring(value)))
				end
			end
		end
	end
end

local function IsInBG()
	if (GetNumBattlefieldScores() > 0) then
		return true
	end
	return false
end

local function IsInArena()
	if not IsRetail then return false end
	local a,b = IsActiveBattlefieldArena()
	if not a then
		return false
	end
	return true
end

local function CheckCombatStatus()
	return IsInBG() or IsInArena() or InCombatLockdown() or UnitAffectingCombat("player") or (IsRetail and C_PetBattles.IsInBattle())
end

----------------------
--      Enable      --
----------------------

function addon:EnableAddon()

	if not CVarsBkp_DB then CVarsBkp_DB = {} end

	self:CreateUtilityFrame()

	local ver = GetAddOnMetadata(ADDON_NAME,"Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFF20ff20%s|r] loaded", ADDON_NAME, ver or "1.0"))
end

StaticPopupDialogs["CVARSBACKUP_SAVE"] = {
	text = L.SaveCVars,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		CVarsBkp_DB = GetCVars()
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r: %s", ADDON_NAME, L.SaveComplete))
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

StaticPopupDialogs["CVARSBACKUP_RESTORE"] = {
	text = L.RestoreCVars,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		RestoreCVars()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

function addon:CreateUtilityFrame()

	self:SetWidth(200)
	self:SetHeight(140)
	self:SetMovable(false)
	self:SetClampedToScreen(true)
	self:EnableMouse(true)

	--self:SetScale(XanDUR_DB.scale)

	self:SetPoint("CENTER", UIParent, "CENTER")

	self:SetBackdrop( {
		bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground";
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border";
		tile = true; tileSize = 32; edgeSize = 16;
		insets = { left = 5; right = 5; top = 5; bottom = 5; };
	} );
	self:SetBackdropBorderColor(0.5, 0.5, 0.5);
	self:SetBackdropColor(0.5, 0.5, 0.5, 0.6)

	local g = self:CreateFontString("$parentText", "ARTWORK", "GameFontNormalSmall")
	g:SetJustifyH("LEFT")
	g:SetPoint("TOP",0,-5)
	g:SetText("CVarsBackup by Xruptor")

	local closeBtn = CreateFrame("Button", nil, self, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", C_EditMode and -3 or 2, C_EditMode and -3 or 1) --check for classic servers to adjust for positioning using a check for the new EditMode

	local saveButton = CreateFrame("Button", ADDON_NAME.."_save_button", self, "UIPanelButtonTemplate")
	saveButton:SetText(L.SaveCVars)
	saveButton:SetHeight(30)
	saveButton:SetWidth(saveButton:GetTextWidth() + 30)
	saveButton:SetPoint("CENTER", self, "TOP", 0, -40)
	saveButton:SetScript("OnUpdate", function()
		--only allow this button to be clicked if we are not in combat
		if not CheckCombatStatus() then
			saveButton:SetEnabled(true)
		else
			saveButton:SetEnabled(false)
		end
	end)
	saveButton:SetScript("OnClick", function()
		StaticPopup_Show("CVARSBACKUP_SAVE")
	end)

	local restoreButton = CreateFrame("Button", ADDON_NAME.."_restore_button", self, "UIPanelButtonTemplate")
	restoreButton:SetText(L.RestoreCVars)
	restoreButton:SetHeight(30)
	restoreButton:SetWidth(restoreButton:GetTextWidth() + 30)
	restoreButton:SetPoint("CENTER", self, "TOP", 0, -75)
	restoreButton:SetScript("OnUpdate", function()
		--only allow this button to be clicked if we are not in combat
		if not CheckCombatStatus() then
			restoreButton:SetEnabled(true)
		else
			restoreButton:SetEnabled(false)
		end
	end)
	restoreButton:SetScript("OnClick", function()
		StaticPopup_Show("CVARSBACKUP_RESTORE")
	end)

	local reloadUIButton = CreateFrame("Button", ADDON_NAME.."_reloadui_button", self, "UIPanelButtonTemplate")
	reloadUIButton:SetText(L.ReloadUI)
	reloadUIButton:SetHeight(30)
	reloadUIButton:SetWidth(reloadUIButton:GetTextWidth() + 30)
	reloadUIButton:SetPoint("CENTER", self, "TOP", 0, -110)
	reloadUIButton:SetScript("OnUpdate", function()
		--only allow this button to be clicked if we are not in combat
		if not CheckCombatStatus() then
			reloadUIButton:SetEnabled(true)
		else
			reloadUIButton:SetEnabled(false)
		end
	end)
	reloadUIButton:SetScript("OnClick", function()
		--some settings require you to restart the GX
		RestartGx()
		--some settings require you to restart the sound
		Sound_GameSystem_RestartSoundSystem()
		--you need to reload the UI
		ReloadUI()
	end)

	local diffButton = CreateFrame("Button", ADDON_NAME.."_reloadui_button", self, "UIPanelButtonTemplate")
	diffButton:SetText("!=")
	diffButton:SetHeight(30)
	diffButton:SetWidth(diffButton:GetTextWidth() + 12)
	diffButton:SetPoint("CENTER", self, "BOTTOM", 82, 20)
	diffButton:SetScript("OnUpdate", function()
		--only allow this button to be clicked if we are not in combat
		if not CheckCombatStatus() then
			diffButton:SetEnabled(true)
		else
			diffButton:SetEnabled(false)
		end
	end)
	diffButton:SetScript("OnClick", function()
		CheckDiffs()
	end)

	self:Show()
end

