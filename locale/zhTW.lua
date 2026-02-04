local ADDON_NAME, addon = ...

local L = addon:NewLocale("zhTW")
if not L then return end

L.SaveCVars = "備份 CVars"
L.RestoreCVars = "還原 CVars"
L.ReloadUI = "重載介面"
L.SaveComplete = "備份完成！"
L.RestoreComplete = "還原成功！請點擊「重載介面」按鈕！"
L.Invalid = "無法還原，因為缺少備份資料！"
L.NoCmds = "錯誤：無法取得所有指令！"
L.Loaded = "已載入"
L.MainTitle = "CVarsBackup by Xruptor"
L.DBLabel = "資料庫"
L.CurrLabel = "目前"
L.NilLabel = "空值"
