local ADDON_NAME, addon = ...

local L = addon:NewLocale("itIT")
if not L then return end

L.SaveCVars = "Save CVars"
L.RestoreCVars = "Restore CVars"
L.ReloadUI = "Reload UI"
L.SaveComplete = "Save Complete!"
L.RestoreComplete = "Restore Complete! <<< PLEASE PRESS THE RELOAD UI BUTTON >>>!"
L.Invalid = "Invalid cannot restore, please save first!"
L.NoCmds = "Error: Could not get all commands!"
L.Loaded = "loaded"
L.MainTitle = "CVarsBackup by Xruptor"
L.DBLabel = "DB"
L.CurrLabel = "Curr"
L.NilLabel = "NIL"
