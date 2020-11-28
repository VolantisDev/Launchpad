#Warn

A_IconHidden := A_IsCompiled

#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

TraySetIcon("Graphics\Launchpad.ico")

SplitPath(A_ScriptName,,,, appName)

app := Launchpad.new(appName, A_ScriptDir)
app.Windows.OpenUpdaterWindow()

; OnError("HandleError")

; HandleError(thrown, mode) {
;     MsgBox("An unhandled error has occurred. Exiting Launchpad.")
;     ExitApp
; }
