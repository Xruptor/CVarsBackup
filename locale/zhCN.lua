local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhCN")
if not L then return end

L.SaveCVars = "保存 CVars"
L.RestoreCVars = "恢复 CVars"
L.ReloadUI = "重载插件"
L.SaveComplete = "保存完成!"
L.RestoreComplete = "恢复完成! 请按<<< 重载插件 >>>按钮!"
L.Invalid = "无效恢复, 无保存资料!"
