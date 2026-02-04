local ADDON_NAME, addon = ...

local L = addon:NewLocale("ruRU")
if not L then return end

L.SaveCVars = "Сохранить CVars"
L.RestoreCVars = "Восстановить CVars"
L.ReloadUI = "Перезагрузить интерфейс"
L.SaveComplete = "Сохранение завершено!"
L.RestoreComplete = "Восстановление завершено! <<< ПОЖАЛУЙСТА, НАЖМИТЕ КНОПКУ ПЕРЕЗАГРУЗКИ ИНТЕРФЕЙСА >>>!"
L.Invalid = "Невозможно восстановить, пожалуйста сначала сохраните!"
L.NoCmds = "Ошибка: не удалось получить список команд!"
L.Loaded = "загружен"
L.MainTitle = "CVarsBackup от Xruptor"
L.DBLabel = "БД"
L.CurrLabel = "Текущее"
L.NilLabel = "НЕТ"
