local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhTW")
if not L then return end

L.SaveCVars = "備份 CVars"
L.RestoreCVars = "還原 CVars"
L.ReloadUI = "重載介面"
L.SaveComplete = "備份完成！"
L.RestoreComplete = "還原成功！請點擊「重載介面」按鈕！"
L.Invalid = "無法還原，因為缺少備份資料！"
