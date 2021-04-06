local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "ruRU")
if not L then return end

--Special thanks to Hubbotu
--https://github.com/Hubbotu/CVars_RUS/blob/main/ruRU.lua

L.SaveCVars = "Сохранить CVars"
L.RestoreCVars = "Восстановить CVars"
L.ReloadUI = "Перезагрузить интерфейс"
L.SaveComplete = "Сохранение завершено!"
L.RestoreComplete = "Восстановление завершено! <<< ПОЖАЛУЙСТА, НАЖМИТЕ КНОПКУ ПЕРЕЗАГРУЗКИ ИНТЕРФЕЙСА >>>!"
L.Invalid = "Невозможно восстановить, пожалуйста сначала сохраните!"