local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if not L then return end

L.SaveCVars = "Save CVars"
L.RestoreCVars = "Restore CVars"
L.ReloadUI = "Reload UI"
L.SaveComplete = "Save Complete!"
L.RestoreComplete = "Restore Complete! <<< PLEASE PRESS THE RELOAD UI BUTTON >>>!"
L.Invalid = "Invalid cannot restore, please save first!"
L.NoCmds = "Error: Could not get all commands!"
