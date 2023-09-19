local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhTW")
if not L then return end

L.SaveCVars = "保存 CVars"
L.RestoreCVars = "恢復 CVars"
L.ReloadUI = "重載插件"
L.SaveComplete = "保存完成!"
L.RestoreComplete = "恢復完成! 請點擊<<< 重載插件 >>>按鈕!"
L.Invalid = "無效恢復, 因為無保存數據!"
