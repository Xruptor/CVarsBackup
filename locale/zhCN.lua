local ADDON_NAME, addon = ...

local L = addon:NewLocale("zhCN")
if not L then return end

L.SaveCVars = "保存 CVars"
L.RestoreCVars = "恢复 CVars"
L.ReloadUI = "重载界面"
L.SaveComplete = "保存完成!"
L.RestoreComplete = "恢复完成! 请按<<< 重载界面 >>>按钮!"
L.Invalid = "无效恢复, 无保存资料!"
L.NoCmds = "错误：无法获取全部命令!"
L.Loaded = "已载入"
L.MainTitle = "CVarsBackup 作者 Xruptor"
L.DBLabel = "数据库"
L.CurrLabel = "当前"
L.NilLabel = "空"
